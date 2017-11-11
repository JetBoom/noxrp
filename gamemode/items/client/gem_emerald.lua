local ITEM = {}
ITEM.DataName = "gem_emerald"
ITEM.Description = "A small emerald gem."

function ITEM:LocalDraw()
	self:SetMaterial("models/shiny")
	self:SetColor(Color(25, 255, 25))
end
	
function ITEM:DermaMenuSetup(panel)
	panel.Entity:SetMaterial("models/shiny")
	panel:SetColor(Color(25, 255, 25))
end

RegisterItem(ITEM)