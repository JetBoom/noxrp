local ITEM = {}
ITEM.DataName = "gem_ruby"
ITEM.Description = "A small ruby gem."
	
function ITEM:LocalDraw()
	self:SetMaterial("models/shiny")
	self:SetColor(Color(255, 25, 25))
end

RegisterItem(ITEM)