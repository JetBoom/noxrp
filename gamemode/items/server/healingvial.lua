local ITEM = {}
ITEM.DataName = "healingvial"

function ITEM:ItemUse(pl)
	if pl:Health() < pl:GetMaxHealth() then
		pl:SetHealth(math.min(pl:Health() + 10, pl:GetMaxHealth()))
		pl:EmitSound("items/medshot4.wav")
		return true
	end
		
	return false
end

RegisterItem(ITEM)