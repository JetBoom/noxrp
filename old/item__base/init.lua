--[[
	This is the item base entity.
]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_props.lua")

include("shared.lua")


--To be changed later, basically enables the entity to be used in the burying system
ENT.CanBeBuried = true

--Initialization
function ENT:Initialize()
	self:SetLockedDown(self:GetLockedDown() or false)

	if self:GetItemCount() == 0 then
		self:SetItemCount(1)
	end

	self:SetTemperature(TEMPERATURE_BASE_ENTITY)

	self:SetupLocalVars()
end

--This sets the data into the item, and loads the item object into the entity.
function ENT:SetData(pitem, data)
	self.Data = pitem or {}

	--If we have a base data name that we're based off of, then set it
	if self.DataName then
		self:SetBaseItem(self.DataName)
	end

	--If we aren't loading a specific item with specific data, then just create a new one
	if not pitem then
		self.Data = Item(self.DataName)

		if data then
			self.Data:SetData(data)
		end
	end

	--Set the overhead title as the name + the amount of items
	if self.Data.GetItemName then
		if self.Data:GetAmount() > 1 then
			self:SetDisplayName(self.Data:GetItemName().." [x"..self.Data:GetAmount().."]")
		else
			self:SetDisplayName(self.Data:GetItemName())
		end
	end

	--Adds [BROKEN] to the title if the durability is zero
	--TODO: make this a bit prettier instead of just fucking around with setdisplayname constantly
	if self.Data:GetData().Durability then
		if self.Data:GetData().Durability == 0 then
			self:SetDisplayName(self:GetDisplayName().." [BROKEN]")
		end
	end

	--Sets the model
	--GetModel references sh_itemstructure, the file for the metamethods for the item object
	self:SetModel(self.Data:GetModel())

	--General entity initialization
	self:PhysicsInit(self.PhysInit or SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		if self:GetLockedDown() then
			phys:EnableMotion(false)
		else
			phys:EnableMotion(true)
		end
		phys:Wake()
		phys:SetMass(5)
	end

	--Can be called in the individual item, for whatever reason
	if self.PostSetData then
		self:PostSetData()
	end
end

--This can be called in the individual item files, where it can initialize local variables for timers and such.
function ENT:SetupLocalVars()
end

--This sets a temporary owner, such that only the temp owner can either move the item or put it in their inventory.
--After the time expires, they are no longer the temp owner and anyone can move/take as normal.
--This is really only used from the inventory dropping
function ENT:SetTemporaryOwnerMain(pl, time)
	self.ForceUpdateTempOwner = CurTime() + 1

	self:SetTemporaryOwner(pl)
	self:SetTemporaryOwnedTime(CurTime() + time)
	--self:SetNWEntity("TemporaryOwner", pl)
	--self:SetNWFloat("TemporaryOwnedTime", CurTime() + time)
end


function ENT:Think()
	local ct = CurTime()

	--If we are being held by someone...
	if self:IsPlayerHolding() then
		local pl = self:GetOwner()
		--And they're not invalid..
		if pl:IsValid() then
			if pl:KeyDown(IN_WALK) then
				--Lock the item down if we're in a property we own and let go of the item
				LockDownItem(pl, self)
				pl.c_Holding = nil
				self:SetOwner(nil)
				pl:DropObject()

				return
			elseif pl:KeyDown(IN_ATTACK) then
				--if not pl:GetActiveWeapon():IsValid() then
				--Throw the item, if for some reason we want to throw it
					pl.c_Holding = nil
					self:SetOwner(nil)
					pl:DropObject()

					self:GetPhysicsObject():SetVelocityInstantaneous(pl:GetAimVector() * 200 * (pl:GetStat(STAT_STRENGTH) / 8))

					--If the player wants drop protection on it, then add them as a temp owner
					if pl:GetInfoNum("noxrp_dropprotection", 1) == 1 then
						self:SetTemporaryOwnerMain(pl, 10)
					end
					return
				--end
			end
		end
	--If we aren't being held by someone but have an owner, remove them
	elseif self:GetOwner():IsValid() then
		--Clear the owner
		local pl = self:GetOwner()
		pl.c_Holding = nil
		self:SetOwner(nil)

		if pl:GetInfoNum("noxrp_dropprotection", 1) == 1 then
			self:SetTemporaryOwnerMain(pl, 10)
		end
	end

	--Timer for temporary owners
	if self:GetTemporaryOwner():IsValid() then
		if self:GetTemporaryOwnedTime() < CurTime() then
			self:SetTemporaryOwnedTime(0)
			self:SetTemporaryOwner(NULL)
		end
	end

	--If we're locked down, then do ThinkLocked
	if self:GetLockedDown() then
		self:ThinkLocked()
	end

	--LocalThink is simply an extention for the item files if they need a think function
	self:LocalThink(ct)

	self:NextThink(ct)
	return true
end

function ENT:Use(pl)
	if not self:GetLockedDown() then
		local cantake = false
		if self:GetTemporaryOwner():IsValid() then
			if self:GetTemporaryOwner() == pl then
				cantake = true
			end
		else
			cantake = true
		end

		if cantake then
			if pl:KeyDown(IN_SPEED) then
				if not self:IsPlayerHolding() then
					self:SetOwner(pl)
					pl.c_Holding = self
					pl:PickupObject(self)

					local hints = pl:GetInfoNum("noxrp_enablehints", 1)

					if hints == 1 then
						pl:SendLua("notification.AddLegacy(\"If you are in a property you own, you can press WALK to lock this item down.\", NOTIFY_HINT, 5 )")
					end
				end
			elseif self:CanPickup(pl) then
				if self.PickupSound then
					self:EmitSound(self.PickupSound)
				end
				if self.DataName then
					local tab = self.Data:GetCopy()

					if self:GetOwner():IsValid() then
						self:SetOwner(nil)
					end

					if self.WorldMine then
						if self.WorldMine:IsValid() then
							self.WorldMine:OnChildPickedup(self)
						end
					end

					if self.OnTaken then
						self:OnTaken(pl)
					end

					pl:InventoryAdd(tab, self)
				end
			end
		else
		--	pl:SendNotification("Someone else temporarily owns this.", 10, Color(255, 150, 150), "buttons/button14.wav", 1)
			pl:SendNotification("You stole it!", 5, Color(255, 100, 100), "buttons/button14.wav")

			if self.DataName then
				local tab = self.Data

				if self:GetOwner():IsValid() then
					self:SetOwner(nil)
				end

				if self.WorldMine then
					if self.WorldMine:IsValid() then
						self.WorldMine:OnChildPickedup(self)
					end
				end

				if self.OnTaken then
					self:OnTaken(pl)
				end

				pl:InventoryAdd(tab, self)
				pl:AddKarma(-30)
			end
		end
	elseif self.OnUseLocked and not pl:KeyDown(IN_SPEED) and not pl:KeyDown(IN_WALK) then
		self:OnUseLocked(pl)
	elseif pl:KeyDown(IN_SPEED) then
		local propid = self.PropertyID
		if PROPERTIES[propid] then
			local prop = PROPERTIES[propid]
			if pl:IsOwner(prop) then
				if self:CanPickup(pl) then
					local tab = self.Data
					if self:GetOwner():IsValid() then
						self:SetOwner(nil)
					end

					pl:InventoryAdd(tab, self)
				end
			elseif self:CanPickup(pl) then
				if self:GetSellPrice() > 0 then
					if pl:HasItem("money", self:GetSellPrice()) then
						pl:SendNotification("You bought a '"..self:GetDisplayName().."'!", 10, Color(150, 255, 150), "buttons/button14.wav", 1)

						local addedto = false
						for _, cash in pairs(ents.FindInBox(prop.VecMin, prop.VecMax)) do
							if cash:GetClass() == "item_cashregister" then
								if cash:GetLockedDown() then
									addedto = true
									--TODO:Add the money to the register
									cash.Data:GetData().Money = cash.Data:GetData().Money + self:GetSellPrice()
									break
								end
							end
						end

						if not addedto then
							for _, v in pairs(player.GetAll()) do
								if v:GetAccountID() == prop.Owner then
									local tab = Item("money")
									tab:SetAmount(self:GetSellPrice())

									v:InventoryAdd(tab)
									v:SendNotification("Someone bought an item for "..tab:GetAmount()..".", 5, Color(150, 150, 255), "buttons/button14.wav", 1)
									break
								end
							end
						end

						local tab = self.Data:GetCopy()
						tab:SetAmount(self:GetItemCount() or 1)

						if self:GetOwner():IsValid() then
							self:SetOwner(nil)
						end

						pl:DestroyItemByName("money", self:GetSellPrice())

						pl:InventoryAdd(tab, self)
					else
						pl:SendNotification("You can't buy this!", 10, Color(255, 150, 150), "buttons/button14.wav", 1)
					end
				end
			end
		end
	end
end

function ENT:OnUseLocked(pl)
end

function ENT:CanLockDown()
	return true
end

function ENT:CanPickup()
	return not self:IsPlayerHolding()
end

function ENT:OnLockedDownItem(pl)
end

function ENT:LocalThink()
end

function ENT:ThinkLocked()
end

function ENT:OnTakeDamage()
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		if not self:GetLockedDown() then
			if not phys:IsMotionEnabled() then
				phys:EnableMotion(true)
				phys:Wake()
			end
		end
	end
end

function ENT:GetVarsToSave()
	local tab = {
		["ItemCount"] = self:GetItemCount(),
		["LockedDown"] = self:GetLockedDown(),
		["PropertyID"] = self.PropertyID,
		["Data"] = self.Data,
		["Temperature"] = self:GetTemperature()
	}

	if self.LocalGetVarsToSave then
		tab.LocalVars = self:LocalGetVarsToSave()
	end

	return tab
end

function ENT:SetVarsToLoad(tab)
	if tab.ItemCount then
		self:SetItemCount(tab.ItemCount)
	end

	if tab.LockedDown then
		self:SetLockedDown(tab.LockedDown)
	end

	if tab.PropertyID then
		self.PropertyID = tab.PropertyID
	end

	if tab.Temperature then
		self:SetTemperature(tab.Temperature)
	end

	if tab.LocalVars then
		self:LocalSetVarsToLoad(tab.LocalVars)
	end

	local item = RecreateItem(tab.Data)

	self:SetData(item)

	if self.PostLoadedData then
		self:PostLoadedData()
	end
end