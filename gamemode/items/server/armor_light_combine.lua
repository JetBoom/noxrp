local ITEM = {}
ITEM.DataName = "armor_light_combine"

function ITEM:OnEquip(pl)
	local mdl = self:GetPlayerModel(pl)
	pl:SetModel(mdl)
		
	if pl:GetHands():IsValid() then
		GAMEMODE:PlayerSetHandsModel( pl, pl:GetHands() )
	end
end
	
function ITEM:OnUnEquip(pl)
	pl:SetModel(pl.c_MainModel)
		
	if pl:GetHands():IsValid() then
		GAMEMODE:PlayerSetHandsModel( pl, pl:GetHands() )
	end
end

RegisterItem(ITEM)