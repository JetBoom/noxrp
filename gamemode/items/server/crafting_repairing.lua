local ITEM = {}
ITEM.DataName = "crafting_electronics"

function ITEM:OnUseLocked(act)
	if act:IsPlayer() then
		--find items in an area on it, if the global item has durability and this item is less than the max dur, lower the max durability and start the repairing game
	end
end
	
RegisterItem(ITEM)