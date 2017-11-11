local ITEM = {}
ITEM.DataName = "gem_sapphire"

ITEM.Description = "A small sapphire gem."
	
function ITEM:LocalDraw()
	self:SetMaterial("models/shiny")
	self:SetColor(Color(25, 25, 255))
end
	
function ITEM:DermaMenuSetup(panel)
	panel.Entity:SetMaterial("models/shiny")
	panel:SetColor(Color(25, 25, 255))
end

RegisterItem(ITEM)