local ITEM = {}
ITEM.DataName = "food__base"

ITEM.HealthRecovery = 5

function ITEM:OnEaten(pl, item)
	pl:SetHealth(math.Clamp(pl:Health() + self.HealthRecovery, 1, pl:GetMaxHealth()))
	return true
end

RegisterItem(ITEM)