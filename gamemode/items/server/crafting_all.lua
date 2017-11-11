local ITEM = {}
ITEM.DataName = "crafting_all"

function ITEM:OnUseLocked(act)
	if act:IsPlayer() then
		act:SendLua("OpenFilteredCrafting()")
	end
end

RegisterItem(ITEM)