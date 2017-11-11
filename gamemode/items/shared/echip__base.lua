local ITEM = {}
ITEM.DataName = "echip__base"
ITEM.ItemWeight = 1
ITEM.Category = ITEM_CAT_ECHIP
ITEM.IsBase = true
ITEM.IsEChip = true

function ITEM:CanApplyToWeapon(wep)
	return true
end

RegisterItem(ITEM)