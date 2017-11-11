local ITEM = {}
ITEM.DataName = "jewel_emerald"

ITEM.Description = "A small emerald that mutates weapon properties."

function ITEM:Draw()
	self:SetMaterial("models/shiny")
	self:SetColor(Color(25, 255, 25))
	self:DrawModel()
end

RegisterItem(ITEM)