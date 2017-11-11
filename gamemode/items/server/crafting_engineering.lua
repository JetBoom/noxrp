local ITEM = {}
ITEM.DataName = "crafting_engineering"

function ITEM:OnUseLocked(pl)
	if pl:IsPlayer() then
		pl:SendLua("OpenFilteredCrafting("..CRAFTING_ENGINEERING..")")
	end
end
	
function ITEM:OnCraftingCompleted(pl)
	self:EmitSound("ambient/levels/labs/machine_stop1.wav")
end

RegisterItem(ITEM)