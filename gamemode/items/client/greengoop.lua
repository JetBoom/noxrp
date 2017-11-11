local ITEM = {}
ITEM.DataName = "greengoop"

ITEM.Description = "A small glob of green goop."
ITEM.ItemPanelMaterial = "models/shiny"
ITEM.InventoryCameraPos = Vector(0, 0, 9)
	
function ITEM:BuildItemPanelColor()
	return Color(0, 255, 25)
end
	
local matGlow = Material("sprites/light_glow02_add")
function ITEM:LocalDraw()
	self:SetMaterial("models/shiny")

	self:SetColor(Color(0, 255, 25))
	self:DrawModel()
	render.SetMaterial(matGlow)
	local size = math.sin(RealTime() * 16) * 16 + 16
	render.DrawSprite(self:GetPos(), size, size, Color(0, 255, 25))
end
	
function ITEM:DermaMenuSetup(panel)
	panel.Entity:SetMaterial("models/shiny")

	panel:SetColor(Color(0, 255, 25))
end

RegisterItem(ITEM)