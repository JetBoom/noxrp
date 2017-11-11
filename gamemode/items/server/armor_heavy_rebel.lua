local ITEM = {}
ITEM.DataName = "armor_heavy_rebel"

function ITEM:OnEquip(pl)
	pl:SetModel(self:GetPlayerModel())
	if pl:GetHands():IsValid() then
		GAMEMODE:PlayerSetHandsModel( pl, pl:GetHands() )
	end
		
	return pl:GetModel()
end
	
function ITEM:OnUnEquip(pl)
	pl:SetModel(pl.c_MainModel)
	if pl:GetHands():IsValid() then
		GAMEMODE:PlayerSetHandsModel( pl, pl:GetHands() )
	end
end

RegisterItem(ITEM)