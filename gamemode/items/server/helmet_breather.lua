local ITEM = {}
ITEM.DataName = "helmet_breather"

function ITEM:OnEquip(pl)
	pl:GiveStatus("helmet_breather")
end
	
function ITEM:OnUnEquip(pl)
	pl:RemoveStatus("helmet_breather", nil, true)
end

RegisterItem(ITEM)