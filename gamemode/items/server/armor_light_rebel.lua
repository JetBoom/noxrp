local ITEM = {}
ITEM.DataName = "armor_light_rebel"

function ITEM:OnEquip(pl)
	if string.find(pl:GetModel(), "group1") then
		pl:SetModel(self:GetPlayerModel(pl))
	else
		pl:SetModel(self:GetPlayerModel(pl, "models/player/group01/male_01.mdl"))
	end
	
	pl:GetHands():SetBodygroup(1, 1)
end
	
function ITEM:OnUnEquip(pl)
	pl:SetModel(pl.c_MainModel)
	pl:GetHands():SetBodygroup(1, 0)
end

RegisterItem(ITEM)