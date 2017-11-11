local ITEM = {}
ITEM.DataName = "liquidcontainer__base"

function ITEM:SetupLocalVars()
	self.NextCool = 0
	self.NextFireDamage = 0
end

function ITEM:PostSetData()
	if not self.Data:GetData().Contents then
		self.Data:GetData().Contents = {}
	else
		self:UpdateContents()
	end
end

--If we want to drink it, then check all the reagents in the container to see how they react
function ITEM:OverrideOnDrink(pl, container)
	if #container:GetContainer() == 0 then
		pl:SendNotification("The container is empty!")
	end

	for _, item in pairs(container:GetContainer()) do
		if item.OnReagentDrink then
			item:OnReagentDrink(pl)
		end
	end

	container:EmptyItems()
	pl:UpdateInventoryItem(container)
end

function ITEM:Touch(ent)
	if self:GetTemperature() > 200 then
		if self.NextFireDamage < CurTime() then
			self.NextFireDamage = CurTime() + 0.5

			self:InflictHeatDamage(ent)
		end
	end
end

function ITEM:InflictHeatDamage(pl)
	local dmg = math.Round(3 * (self:GetTemperature() / 400))
	local dmginfo = DamageInfo()
		dmginfo:SetDamage(dmg)
		dmginfo:SetDamageType(DMG_BURN)
		dmginfo:SetAttacker(self)

	pl:TakeDamageInfo(dmginfo)
end

function ITEM:CanPickup(pl)
	if self:GetTemperature() < 200 then
		return true
	else
		self:InflictHeatDamage(pl)

		pl:SendNotification("It is too hot to put away!", 4, Color(255, 50, 50), nil, 1)
		return false
	end
end

function ITEM:OnTakeDamage(dmg)
	--Get the items in our container
	local contents = self.Data:GetContainer()
	if dmg:IsDamageType(DMG_BURN) then

		self.NextCool = CurTime() + 1

		self:SetTemperature(math.min(self:GetTemperature() + dmg:GetDamage() * 5, 300))
		CheckChemistryRecipe(self, self.Data:GetData().Contents)

		if #contents > 0 then
			self:UpdateContents()
		end
	end
end

function ITEM:SortContents()
	local tab = {}

	--If the item does not have an amount of 0, then save the item
	for _, item in pairs(self.Data:GetContainer()) do
		if item:GetAmount() > 0 then
			local added = false

			--See if we already added it to the tab table, if we have then add the amounts
			for index, tabitem in pairs(tab) do
				if tabitem:GetDataName() == item:GetDataName() then
					tabitem:SetAmount(tabitem:GetAmount() + item:GetAmount())
					added = true

					break
				end
			end

			--If it wasn't already in the tab table, then add it
			if not added then
				table.insert(tab, item)
			end
		end
	end

	table.Empty(self.Data:GetContainer())

	self.Data:SetItems(tab)

	CheckChemistryRecipe(self)
end

function ITEM:LocalThink()
	local contents = self.Data:GetContainer()

	if self.NextCool < CurTime() then
		self.NextCool = CurTime() + 1

		self:SetTemperature(math.max(self:GetTemperature() - 3, TEMPERATURE_BASE_ENTITY))
		self:UpdateContents()
	end

	if self:GetTemperature() > TEMPERATURE_BASE_ENTITY and self:WaterLevel() >= 2 then
		self:SetTemperature(TEMPERATURE_BASE_ENTITY)

		self:EmitSound("ambient/water/water_splash1.wav")
	end

	if not self.WaterTight then
		if self:WaterLevel() >= 2 then
			local havewater = false
			for k, v in pairs(contents) do
				if v:GetDataName() == "water" then
					havewater = true

					--if v:GetAmount() < self.Data:GetData().ContainerVolume then
					--	v:SetAmount(self.Data:GetData().ContainerVolume)
					--end
					break
				end
			end

			if not havewater then
				local tab = Item("water")
					tab:SetAmount(self.ContainerVolume)

				self.Data:AddItem(tab)
			end
		end
	end
end

function ITEM:UpdateContents()
	local updated = false
	for k, v in pairs(self.Data:GetContainer()) do
		local item = v:GetGlobalItem()
		if item.OnHitTemperature then
			local itemnew = item:OnHitTemperature(self:GetTemperature(), v)
			if itemnew then
				v.DataName = itemnew.Name
				if itemnew.Volume then
					v:SetAmount(v:GetAmount() * itemnew.Volume)
				end

				updated = true
			end
		end
	end

	if updated then
		self:SortContents()
	end
end

function ITEM:AcceptInteraction(item)
	return true
end

function ITEM:OnInteractWith(pl, ent2)
	local liq = #self.Data:GetContainer()

	if ent2.IsLiquidContainer then
		if liq > 0 then
			self.Data:TransferLiquids(pl, ent2.Data, self, ent2)
		end
	else
		if ent2.IsReagent then
			self.Data:AddItem(ent2.Data:GetCopy())
			pl:SendNotification("You added the "..ent2.Data:GetItemName().." to the "..self.Data:GetItemName()..".")

			ent2:Remove()
		else
			--Force people to drink things
			if ent2:IsPlayer() then
				pl:ChatPrint("You are trying trying to force "..ent2:Name().." to drink something.")
				ent2:ChatPrint(pl:Nick().." is trying to force you to drink something!")
			elseif ent2:IsNextBot() then
				pl:ChatPrint("You are trying trying to force the "..ent2:GetCleanName().." to drink something.")
			end

			local stat = pl:GiveStatus("forcedrink")
				stat:SetForcing(ent2)
				stat:SetItem(self.Data)
		end
	end
end

function ITEM:OnInteractedWith(pl, ent)
end

function ITEM:TransferLiquid(item)
	self.Data:AddItem(item)
end

function ITEM:OnExamined(pl)
	if #self.Data:GetContainer() > 0 then
		pl:SendNotification("The "..string.lower(self.Data:GetItemName()).." contains: ", 4, Color(255, 255, 255), nil, 1)

		local str = ""
		for k, v in pairs(self.Data:GetContainer()) do
			str = str..v:GetGlobalItem().Name.." ["..v:GetAmount().." Units]"
			if k < #self.Data:GetContainer() then
				str = str..", "
			end
		end
		pl:SendNotification(str, 4, Color(255, 255, 255), nil, 1)
	else
		pl:SendNotification("The "..string.lower(self.Data:GetItemName()).." contains nothing.", 4, Color(255, 255, 255), nil, 1)
	end

	pl:SendNotification("The temperature is about "..string.lower(self:GetTemperature())..".", 4, Color(255, 255, 255), nil, 1)
end

function ITEM:UseWithWorld(pl)
end

RegisterItem(ITEM)