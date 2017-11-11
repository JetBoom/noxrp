local meta = FindMetaTable("Player")
if not meta then return end

meta.GetTeamID = meta.Team

function meta:TraceLine(distance, _mask)
	local vStart = self:GetShootPos()
	local filt = ents.FindByClass("projectile_*")
	table.insert(filt, self)
	return util.TraceLine({start = vStart, endpos = vStart + self:GetAimVector() * distance, filter = filt, mask = _mask})
end

function meta:IsKnockedDown()
	if SERVER then
		return self.KnockedDown
	else
		for k,v in pairs(ents.FindByClass("status_knockdown")) do
			if v:GetOwner() == self then
				return v
			end
		end
	end
end

function meta:IsCriminal()
	return self:GetKarma() <= KARMA_CRIMINAL or self.c_CriminalFlag
end

function meta:GetCriminalFlag()
	return self.c_CriminalFlag
end

function meta:InParty()
	return self.c_InParty
end

function meta:IsInParty(pl)
	for _, player in pairs(self:GetParty().Members) do
		if player == pl then
			return true
		end
	end

	if self:GetParty().Leader == pl then return true end

	return false
end

function meta:GetParty()
	if not self.c_Party then
		self.c_Party = {}
		self.c_Party.Members = {}
	end

	return self.c_Party
end

function meta:GetAttackFilter()
	--local tab = team.GetPlayers(self:Team())
	local tab = {}
	table.insert(tab, self)
	return tab
end

function meta:GetStat(stat)
	local base = self.c_Stats[stat].Base

	if not self.c_Stats[stat].Modifiers then
		self.c_Stats[stat].Modifiers = {}
	end

	for k, v in pairs(self.c_Stats[stat].Modifiers) do
		if v.Time >= CurTime() then
			base = base + v.Mod
		else
			if SERVER then
				table.remove(v, k)
				k = k - 1
			end
		end
	end

	return base
end

function meta:GetStatBase(stat)
	return self.c_Stats[stat].Base
end

function meta:GetStats()
	return self.c_Stats
end

function meta:GetTemperature() return self:GetDTInt(0) end
function meta:Karma() return self:GetDTInt(1) end
meta.GetKarma = meta.Karma

function meta:IsSprinting()	return self:GetDTBool(0) end


function meta:GetDiseases()
	return self.c_Diseases
end

function meta:HasDisease(name)
	if not self.c_Diseases then return end

	for _, dis in pairs(self.c_Diseases) do
		if dis.Name == name then
			return dis
		end
	end
end

function meta:GetSkills()
	return self.c_Skills
end

function meta:GetSkill(skill)
	return self.c_Skills[skill]
end

function meta:GetTotalSkill()
	local total = 0
	for k, v in pairs(self.c_Skills) do
		total = total + v
	end

	return total
end

function meta:GetRecipes()
	if not self.c_RecipeList then
		self.c_RecipeList = {}
	end

	return self.c_RecipeList
end

function meta:KnowRecipe(recipe)
	if not self.c_RecipeList then
		self.c_RecipeList = {}
		return false
	end

	for _, rec in pairs(self.c_RecipeList) do
		if rec == recipe then
			return true
		end
	end

	return false
end

function meta:GetAttackers()
	self.c_Attackers = self.c_Attackers or {}
	return self.c_Attackers
end

function meta:TimeSinceLastAttacked()
	local lasttime = 0
	local lastattacker
	for attacker, time in pairs(self:GetAttackers()) do
		if time > lasttime then
			lasttime = time
			lastattacker = attacker
		end
	end

	return lasttime, lastattacker
end

function meta:GetEquipmentSlot(slot)
	self.c_Equipment = self.c_Equipment or {}
	return self.c_Equipment[slot]
end

function meta:GetEquipment()
	return self.c_Equipment or {}
end

function meta:GetDamageReduction(damagetype)
	local resistanceamt = 0

	for slot, id in pairs(self:GetEquipment()) do
		local item = self:GetItemByID(id)
		if item:GetData().Durability then
			if item:GetData().Durability > 0 then
				local gitem = ITEMS[self:GetItemByID(id):GetDataName()]
				for stat, reduction in pairs(gitem.ArmorBonus) do
					if stat == damagetype then
						resistanceamt = resistanceamt + reduction
					end
				end
			end
		end
	end
	return resistanceamt
end

function meta:GetAllDamageReduction()
	local stats = {}

	for slot, id in pairs(self:GetEquipment()) do
		local item = ITEMS[self:GetItemByID(id):GetDataName()]

		for stat, reduction in pairs(item.ArmorBonus) do
			if not stats[stat] then
				stats[stat] = reduction
			else
				stats[stat] = stats[stat] + reduction
			end
		end
	end
	return stats
end

function meta:GetStamina()
	return self.c_Stamina
end

function meta:GetMaxStamina()
	return self.c_MaxStamina
end

function meta:SetCachedStamRegen(amt)
	self.c_CachedStamRegen = amt
end

function meta:GetCachedStamRegen()
	return self.c_CachedStamRegen or BASE_STAMINA_REGENERATION
end

function meta:GetBreathLevel()
	return self.c_BreathLevel
end

function meta:GetInventory()
	if not self.c_Inventory then
		local tab = Item(nil, "container_playerinventory")
			tab.IsContainer = true

		self.c_Inventory = tab
	end

	return self.c_Inventory
end

function meta:GetStaminaRegeneration()
	local base = BASE_STAMINA_REGENERATION

	for slot, id in pairs(self:GetEquipment()) do
		local bodyitem = ITEMS[self:GetItemByID(id):GetDataName()]

		for stat, val in pairs(bodyitem.ArmorBonus) do
			if stat == REDUCTION_STAMINA then
				base = base - base * val
			end
		end
	end
	return base
end

-- TODO: what???
local function RecursiveInventory(tab)
	if not tab then return nil end

	local item = Item(tab.DataName)
		item:SetModel(tab.Data.Model or GetGlobalItem(tab.DataName).Model)
		item:SetAmount(tab.Amount)
		item.IsContainer = tab.IsContainer
		item:SetData(tab.Data)
		item:SetIDRef(tab.IDRef)

	if item.IsContainer or item.IsLiquidContainer then
		for _, recursitem in pairs(tab.Items) do
			local newitem = RecursiveInventory(recursitem)
			table.insert(item.Items, newitem)
		end
	end

	return item
end

--ecreates an item from its table (mostly for converting saved items that are in txt form to the actual item object)
function RecreateItem(item)
	return RecursiveInventory(item)
end

function RecreateInventory(str, class)
	str.Items = str.Items or {}

	local tab = Item(class or "container__base")
		tab.IsContainer = true

	for _, items in pairs(str.Items) do
		local newitem = RecursiveInventory(items)
		if newitem then
			table.insert(tab.Items, newitem)
		end
	end

	return tab
end

function RecreateSimpleInventory(str)
	local tab = {}

	for _, items in pairs(str) do
		local newitem = RecursiveInventory(items)

		table.insert(tab, newitem)
	end

	return tab
end
