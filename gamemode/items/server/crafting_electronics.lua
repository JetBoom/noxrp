local ITEM = {}
ITEM.DataName = "crafting_electronics"

function ITEM:OnUseLocked(act)
	if act:IsPlayer() then
		act:SendLua("OpenFilteredCrafting("..CRAFTING_ELECTRONICS..")")
	end
end

RegisterItem(ITEM)