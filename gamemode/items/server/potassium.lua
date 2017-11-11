local ITEM = {}
ITEM.DataName = "potassium"

function ITEM:OnBreatheIn(pl)
	pl:TakeDamage(1)
end

function ITEM:OnReagentDrink(pl)
	local effect = EffectData()
		effect:SetOrigin(pl:GetPos())
	util.Effect("Explosion", effect)

	pl:TakeDamage(self:GetAmount() * 5)

	return true
end

RegisterItem(ITEM)