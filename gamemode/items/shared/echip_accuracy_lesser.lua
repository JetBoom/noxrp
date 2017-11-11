local ITEM = {}
ITEM.DataName = "echip_acc_less"
ITEM.Model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.Name = "Lesser Accuracy E-Chip"
ITEM.ItemWeight = 1
ITEM.Base = "echip__base"
ITEM.Usable = true
ITEM.DestroyOnUse = true

function ITEM:WeaponStats()
	local tab = {
		{ENHANCEMENT_TYPE_ACCURACY, ENHANCEMENT_MULTIPLY, 0.95}
		}
	return tab
end

RegisterItem(ITEM)