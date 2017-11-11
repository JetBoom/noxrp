local ITEM = {}
ITEM.DataName = "healthkit"

function ITEM:ItemUse(pl)
	if pl:Health() < pl:GetMaxHealth() then
		pl:SetHealth(math.min(pl:Health() + 25, pl:GetMaxHealth()))
		pl:EmitSound("items/medshot4.wav")
		return true
	end
	return false
end

RegisterItem(ITEM)