local ITEM = {}
ITEM.DataName = "tea"
ITEM.Name = "Tea"
ITEM.IsLiquid = true

function ITEM:OnReagentDrink(pl)
	pl:SetHealth(math.min(pl:Health() + 4 * self:GetAmount(), pl:GetMaxHealth()))
	--pl:AddTemporaryHealth(5)
end

RegisterItem(ITEM)