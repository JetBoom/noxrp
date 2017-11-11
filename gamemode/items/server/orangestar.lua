local ITEM = {}
ITEM.DataName = "orangestar"

function ITEM:OnDrink(pl)
	pl:SetHealth(math.min(pl:Health() + 3, pl:GetMaxHealth()))
	pl:SetColor(Color(255, 150, 0))
		
	timer.Create("OrangeStar_"..pl:UniqueID(), 5, 1, function() pl:SetColor(Color(255, 255, 255)) end)
		
	return true
end
RegisterItem(ITEM)