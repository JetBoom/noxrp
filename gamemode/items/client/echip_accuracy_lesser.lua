local ITEM = {}
ITEM.DataName = "echip_acc_less"

function ITEM:WeaponStats()
	local tab = {
		{ENHANCEMENT_TYPE_ACCURACY, ENHANCEMENT_MULTIPLY, 0.95}
		}
	return tab
end

ITEM.Description = "A small chip that improves accuracy of a gun."
	
ITEM.AmmoLetter = "LA"

RegisterItem(ITEM)