local ITEM = {}
ITEM.DataName = "metal_copper"
ITEM.Description = "A chunk of copper ore. Conducts electricity very well."
	
function ITEM:BuildItemPanelColor()
	return Color(160, 100, 50)
end
	
function ITEM:Initialize()
	self:SetColor(Color(160, 100, 50))
		--self:SetMaterial("models/shiny")
end
	
function ITEM:LocalDraw()
	self:SetColor(Color(160, 100, 50))
end

RegisterItem(ITEM)