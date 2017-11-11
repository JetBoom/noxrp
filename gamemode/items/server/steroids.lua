local ITEM = {}
ITEM.DataName = "steroids"

function ITEM:OnReagentDrink(pl)
	pl:SendNotification("You feel stronger.")
	pl:AddStat(STAT_STRENGTH, 10)
	return true
end

RegisterItem(ITEM)