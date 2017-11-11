local ITEM = {}
ITEM.DataName = "tomato"

ITEM.Description = "A small tomato. Maybe you can cook with it."
ITEM.CameraPos = Vector(0, 0, 9)
	
function ITEM:DermaMenuSetup(panel)
	panel:SetColor(Color(0, 255, 25))
end
	
function ITEM:Initialize()
	self:SetColor(Color(255, 0, 0))
end

RegisterItem(ITEM)