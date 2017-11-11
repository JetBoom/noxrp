local ITEM = {}
ITEM.DataName = "crafting_gunsmithing"

function ITEM:OnUseLocked(act)
	if act:IsPlayer() then
		act:SendLua("OpenFilteredCrafting("..CRAFTING_GUNSMITHING..")")
	end
end

RegisterItem(ITEM)