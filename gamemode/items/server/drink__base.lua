local ITEM = {}
ITEM.DataName = "drink__base"

ITEM.HealthRecovery = 5

function ITEM:OnDrink(pl, item)
	pl:SetHealth(math.min(pl:Health() + self.HealthRecovery, pl:GetMaxHealth()))
	return true
end

RegisterItem(ITEM)