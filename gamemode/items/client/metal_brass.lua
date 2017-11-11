local ITEM = {}
ITEM.DataName = "metal_brass"

ITEM.Description = "You can make bullets and other things with this."
	
function ITEM:BuildItemPanelColor()
	return Color(200, 160, 100)
end
	
function ITEM:Initialize()
	self:SetColor(Color(200, 160, 100))
	self:SetMaterial("models/shiny")
end

RegisterItem(ITEM)