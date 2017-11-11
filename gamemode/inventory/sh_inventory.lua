local meta = FindMetaTable("Player")
if not meta then return end

MERCH_FLAG_NOMONEY = 0
MERCH_FLAG_TOOHEAVY = 1

MERCH_REASON_TRANSLATE = {}
MERCH_REASON_TRANSLATE[MERCH_FLAG_NOMONEY] = "You do not have enough money for that!"
MERCH_REASON_TRANSLATE[MERCH_FLAG_TOOHEAVY] = "You cannot carry any more!"

function meta:GetCurWeight()
	local totalweight = 0
	for k, v in pairs(self:GetInventory():GetContainer()) do
		local vweight = v:GetWeight() * v:GetAmount()
		totalweight = totalweight + vweight
	end
	return totalweight
end

--remove this shit or swap with ID and make one func
function meta:GetCurWeightItem(item)
	local totalweight = 0
	for k,v in pairs(self:GetInventory():GetContainer()) do
		if v:GetDataName() == item then
			local vweight = v:GetWeight()
			totalweight = totalweight + vweight
		end
	end
	return totalweight
end

function meta:GetCurWeightID(id)
	local totalweight = 0
	for k,v in pairs(self:GetInventory():GetContainer()) do
		if v:GetIDRef() == id then
			local vweight = v:GetWeight()
			totalweight = totalweight + vweight
		end
	end
	return totalweight
end

function meta:GetMaxWeight()
	return GAME_BASEWEIGHT + self:GetStat(STAT_STRENGTH) * GAME_WEIGHTPERSTRENGTH
end

function meta:HasItem(name, amount)
	amount = amount or 1
	return amount <= self:GetItemCount(name)
end

function meta:HasItemID(id, amount)
	amount = amount or 1
	return amount <= self:GetItemCountByID(id)
end

function meta:GetItemCount(name)
	local count = 0

	if self:GetInventory().GetContainer then
		for _, itemtab in pairs(self:GetInventory():GetContainer()) do
			if itemtab:GetDataName() == name then
				count = count + itemtab:GetAmount()
			end
		end

		return count
	end
end

function meta:GetItemCountByID(id)
	for _, itemtab in pairs(self:GetInventory():GetContainer()) do
		if itemtab.IDRef == id then
			return itemtab:GetAmount()
		end
	end

	return 0
end

function meta:GetItemByID(id)
	if self:GetInventory() then
		for _, itemtab in pairs(self:GetInventory():GetContainer()) do
			if itemtab:GetIDRef() == id then
				return itemtab
			end
		end
	else
		self.c_Inventory = {}
	end
	return nil
end

function meta:GetItemByRef(ref)
	for k,v in pairs(self:GetInventory():GetContainer()) do
		if v:GetDataName() == ref then
			return v
		end
	end
	return nil
end

function meta:CanTakeItem(item, amt)
	return (self:GetCurWeight() + item:GetWeight()) <= self:GetMaxWeight()
end

function meta:GetWeaponFromID(id)
	for _, wep in pairs(self:GetWeapons()) do
		if wep.GetItemID then
			if wep:GetItemID() == id then
				return wep
			end
		end
	end

	return nil
end