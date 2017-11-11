util.AddNetworkString("sendLockDown")

PROPERTIES = PROPERTIES or {}

local function CCCreateProperty(player, command, arguments)
	if not player:IsSuperAdmin() then return end

	if not player.CreateSignPos_Prop then
		if command == "noxrp_createproperty_selfpos" then
		else
			player.CreateSignPos_Prop = player:TraceLine(999).HitPos + Vector(0,0,43)
		end
		player.CreateSignAng_Prop = player:GetAngles().y
		player:PrintMessage(HUD_PRINTCONSOLE, "SignPos made. Awaiting VecMin.")
		return
	end
	if not player.CreateVecMin_Prop then
		if command == "noxrp_createproperty_selfpos" then
			player.CreateVecMin_Prop = player:GetPos()
		else
			player.CreateVecMin_Prop = player:TraceLine(999).HitPos
		end
		player:PrintMessage(HUD_PRINTCONSOLE, "VecMin made. Awaiting VecMax.")
		return
	end
	if not player.CreateVecMax_Prop then
		if command == "noxrp_createproperty_selfpos" then
			player.CreateVecMax_Prop = player:GetPos()
		else
			player.CreateVecMax_Prop = player:TraceLine(999).HitPos
		end
		player:PrintMessage(HUD_PRINTCONSOLE, "VecMax made. Creating new property...")
	end

	local vec1, vec2 = player.CreateVecMin_Prop, player.CreateVecMax_Prop

	local prop = {}
	prop.ID = #PROPERTIES + 1
	prop.Owner = "Nobody"
	prop.DecayTime = 0
	prop.Name = "An unnamed property"
	prop.VecMin = vec1
	prop.VecMax = vec2
	prop.SignPos = player.CreateSignPos_Prop
	prop.SignAng = Angle(0, player.CreateSignAng_Prop + 180, 0)
	prop.Price = 900000
	prop.Friends = {}
	prop.Coowners = {}
	local sqr = prop.VecMax - prop.VecMin
	sqr.x = math.abs(sqr.x)
	sqr.y = math.abs(sqr.y)
	prop.MaxLockDowns = math.ceil(math.Clamp(PROPERTY_LOCKDOWNSPERSQUAREUNITS * sqr.x * sqr.y, PROPERTY_MINLOCKDOWNS, PROPERTY_MAXLOCKDOWNS))

	local ent = ents.Create("property_stone")
	if ent:IsValid() then
		ent:SetPos(prop.SignPos)
		ent:SetAngles(prop.SignAng)
		ent:Spawn()
		ent:SetInfo(prop)
		prop.PropertyStone = ent
		PROPERTIES[prop.ID] = prop
	end

	for _, ent in pairs(ents.FindInBox(prop.VecMin, prop.VecMax)) do
		if string.sub(ent:GetClass(), 1, 12) == "prop_physics" and not ent.LockedDown then
			ent:Remove()
		elseif string.find(ent:GetClass(), "door") then
			ent.Property = prop
		end
	end

	player.CreateSignPos_Prop = nil
	player.CreateVecMin_Prop = nil
	player.CreateVecMax_Prop = nil
	player:PrintMessage(HUD_PRINTCONSOLE, "Done!")

	noxrp.SaveMapFile()
end
concommand.Add("noxrp_createproperty", CCCreateProperty)
concommand.Add("noxrp_createproperty_selfpos", CCCreateProperty)

function CCEditPropertyPrice(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	local price = tonumber(args[1])
	local tr = pl:GetEyeTrace(200)

	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "property_stone" then
			local prop = tr.Entity.Property

			prop.Price = price
			tr.Entity:SetPrice(price)
		end
	end
end
concommand.Add("noxrp_editproperty_price", CCEditPropertyPrice)

function CCRemoveProperty(pl)
	if not pl:IsSuperAdmin() then return end
	local tr = pl:GetEyeTrace(200)

	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "property_stone" then
			for index, property in pairs(PROPERTIES) do
				if property.PropertyStone == tr.Entity then
					tr.Entity:Remove()

					table.remove(PROPERTIES, index)
					break
				end
			end
		end
	end
end
concommand.Add("noxrp_removeproperty", CCRemoveProperty)

function LockDownItem(pl, lockent)
	if not pl:Alive() then return end

	local hitent = lockent or nil

	if not hitent then
		local tr = pl:TraceLine(500)
		hitent = tr.Entity
	end

	if hitent and hitent:IsValid() then
		if hitent.LockedDown then return pl:PrintMessage(HUD_PRINTTALK, "That is already locked down.") end
		if hitent:IsPlayer() or hitent:IsNPC() or hitent:IsWorld() then return pl:PrintMessage(HUD_PRINTTALK, "You can't lock that down!") end
		local phys = hitent:GetPhysicsObject()
		local class = hitent:GetClass()
		if not (phys:IsValid() and phys:IsMoveable()) then return pl:PrintMessage(HUD_PRINTTALK, "You can't lock that down!") end
		if class ~= "prop_physics" and class ~= "prop_physics_multiplayer" and not string.find(class, "item_") then return pl:PrintMessage(HUD_PRINTTALK, "You can't lock that down!") end
		if not hitent:CanLockDown() then return pl:PrintMessage(HUD_PRINTTALK, "You can't lock that down there!") end

		local lockdowns = 0
		local breakout = false
		local maxlocks = 0
		local prop
		for _, tab in pairs(PROPERTIES) do
			lockdowns = 0
			if pl:IsOwner(tab) then
				for __, ent in pairs(ents.FindInBox(tab.VecMin, tab.VecMax)) do
					local locked = false
					if ent.GetLockedDown then
						if ent:GetLockedDown() then
							locked = true
						end
					elseif ent.LockedDown then
						locked = true
					end

					if locked then
						lockdowns = lockdowns + 1
						if lockdowns >= tab.MaxLockDowns then return pl:PrintMessage(HUD_PRINTTALK, "You have reached the maximum allowed lockdowns for this property!") end
					end

					if ent == hitent then
						prop = tab
						maxlocks = tab.MaxLockDowns
						breakout = true
					end
				end
			end
			if breakout then break end
		end

		if prop then
			phys:EnableMotion(false)
			phys:Sleep()
			hitent.PropertyID = prop.ID
			pl:PrintMessage(HUD_PRINTTALK, "Locked down! Using ".. lockdowns + 1 .."/"..maxlocks.." lockdowns in this property.")
			if hitent:GetOwner() then
				hitent:SetOwner(nil)
			end
			hitent:SetLockedDown(true)

			hitent:OnLockedDownItem(pl)
		else
			pl:PrintMessage(HUD_PRINTTALK, "You can only lock down things in your own property.")
		end
	else
		pl:PrintMessage(HUD_PRINTTALK, "There's either nothing there or you can't lock that down.")
	end
end

function PropertyLockDoor(pl)
	local tr = pl:TraceLine(500)
	local hitent = tr.Entity

	if string.find(hitent:GetClass(), "door") then
		if hitent.Locked then
			hitent.Locked = false
			hitent:Fire("Unlock", "", 0)
		else
			hitent.Locked = true
			hitent:Fire("Lock", "", 0)
		end
	end
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:GetProperty(id)
	for k, v in pairs(PROPERTIES) do
		if v.Owner == self:GetAccountID() then
			return v
		end
	end
end

function meta:IsOwner(property)
	return property.Owner == self:GetAccountID()
end

function meta:IsFriend(property)
	for _, friend in pairs(property.Friends) do
		if friend == self:GetAccountID() then return true end
	end
	return false
end

function meta:IsCoowner(property)
	for _, coowner in pairs(property.Coowners) do
		if coowner == self:GetAccountID() then return true end
	end
	return false
end

function LockDoor(pl)
	local ent = pl:GetEyeTrace().Entity
	if not (ent and ent:IsValid() and ent:GetPos():Distance(pl:GetShootPos()) < 110) then return end

	if string.find(ent:GetClass(), "door") and ent.Property then
		if ent.Property.PropertyStone:GetPropertyOwner() == pl:GetAccountID() then
			if pl:KeyDown(IN_ATTACK2) then
				ent.NextLock = ent.NextLock or CurTime()
				if CurTime() < ent.NextLock then return false end
				if ent.Locked then
					ent:Fire("unlock", "", 0)
					ent:EmitSound("doors/door_latch3.wav", 75, 100)
					pl:SendNotification("Unlocked.")
				else
					ent:Fire("close", "", 0)
					ent:Fire("lock", "", 0.05)
					ent:EmitSound("doors/default_locked.wav", 75, 100)
					pl:SendNotification("Locked.")
				end
				ent.NextLock = CurTime() + 0.75
				ent.Locked = not ent.Locked
			else
				ent:Fire("toggle", "", 0)
				ent.Property.PropertyStone:UseProperty(pl, true)
			end
			return false
		end
	end
	return true
end
concommand.Add("lockthisdoor", LockDoor)

concommand.Add("noxrp_renameproperty", function(pl, cmd, args)
	local newname = tostring(args[1])

	if newname ~= "nil" and newname ~= "" then
		newname = string.Left(newname, 30)
		local tr = pl:GetEyeTrace(200)
		if tr.Entity:IsValid() then
			if tr.Entity:GetClass() == "property_stone" then
				if pl:IsOwner(tr.Entity.Property) then
					tr.Entity:SetPropertyName(newname)
					tr.Entity.Property.Name = newname
				end
			end
		end
	end
end)

concommand.Add("noxrp_setsellitem", function(pl, cmd, args)
	local price = tonumber(args[1])

	if price ~= nil and price > 0 and price < 10000000 then
		local tr = pl:GetEyeTrace(200)
		local ent = tr.Entity
		if ent and ent:IsValid() then
			if string.find(ent:GetClass(), "item_") then
				if ent:GetLockedDown() then
					for _, prop in pairs(PROPERTIES) do
						if pl:IsOwner(prop) then
							if prop.PropertyID == ent.ID then
								ent:SetSellPrice(price)
								break
							end
						end
					end
				end
			end
		end
	end
end)

concommand.Add("noxrp_sellproperty", function(pl)
	local trent = pl:GetEyeTrace(200).Entity

	if not (trent and trent:IsValid() and trent:GetClass() == "property_stone" and pl:IsOwner(trent)) then
		return
	end

	local prop = trent.Property
	prop.Owner = "Nobody"
	prop.DecayTime = 0
	prop.Name = "An unnamed property"
	trent:SetInfo(prop)

	if prop.Price then
		pl:AddMoney(math.ceil(prop.Price / 2))
	end

	for _, ent in pairs(ents.FindInBox(prop.VecMin, prop.VecMax)) do
		if ent.LockedDown then
			ent.LockedDown = nil
			ent.Property = nil
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(true)
				phys:Wake()
			end

			if ent:IsDoor() then
				ent:Fire("Unlock", "", 0)
			end
		end
	end
end)

/*
function CheckPropertyManagement(pl)
--	local tr = pl:GetEyeTrace(200)
	--if tr.Entity:IsPlayer() then
		local prop = pl:GetProperty()

		if prop then
			if #prop.Coowners == 0 then
				pl:SendNotification("There are no co-owners.")
			else
				pl:SendNotification("The following are co-owners: ")

				local str = ""
				local removes = {}
				for index, id in pairs(prop.Coowners) do
					local name = GetLastUsedNameFromSteamID(id)
					if name ~= nil then
						str = str..name
						if index < #prop.Coowners then
							str = str..", "
						end
					else
						table.insert(removes, id)
					end
				end

				pl:SendNotification(str)
			end

			if #prop.Friends == 0 then
				pl:SendNotification("There are no friends.")
			else
				pl:SendNotification("The following are friends: ")

				local str = ""
				for index, id in pairs(prop.Friends) do
					local name = GetLastUsedNameFromSteamID(id)
					str = str..name
					if index < #prop.Friends then
						str = str..", "
					end
				end

				pl:SendNotification(str)
			end
		end
	--end
end
concommand.Add("noxrp_checkproperty", CheckPropertyManagement)*/

function AddFriend(pl)
	local tr = pl:GetEyeTrace(200)

	if tr.Entity:IsPlayer() then
		local prop = pl:GetProperty()

		if prop then
			local already = false
			for _, id in pairs(prop.Friends) do
				if id == tr.Entity:GetAccountID() then
					already = true
					break
				end
			end

			if already then
				pl:SendNotification("They are already a friend!")
			else
				pl:SendNotification("They are now a friend.")
				tr.Entity:SendNotification("You are now a friend of "..prop.Name..".")
				table.insert(prop.Friends, tr.Entity:GetAccountID())
			end
		end
	end
end
AddNoXRPChatCommand("/addfriend", AddFriend)

function AddCoowner(pl)
	local tr = pl:GetEyeTrace(200)

	if tr.Entity:IsPlayer() then
		local prop = pl:GetProperty()

		if prop then
			if tr.Entity:IsCoowner(prop) then
				pl:SendNotification("They are already a co-owner!")
			else
				pl:SendNotification("They are now a co-owner.", 10, Color(50, 255, 50), "buttons/button14.wav", 1)
				tr.Entity:SendNotification("You are now a co-owner of "..prop.Name..".", 10, Color(50, 255, 50), "buttons/button14.wav", 1)

				table.insert(prop.Coowners, tr.Entity:GetAccountID())
			end
		end
	end
end
AddNoXRPChatCommand("/addcoowner", AddCoowner)