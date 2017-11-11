local ITEM = {}
ITEM.DataName = "redgoop"

ITEM.Description = "A small glob of red goop. Highly volitile."
ITEM.ItemPanelMaterial = "models/shiny"
ITEM.CameraPos = Vector(0, 0, 9)

local matGlow = Material("sprites/light_glow02_add")

function ITEM:BuildItemPanelColor()
	return Color(255, 25, 0)
end
	
function ITEM:LocalDraw()
	self:SetMaterial("models/shiny")
	
	local r,g,b,a = self:GetColor()
	self:SetColor(Color(255, 25, 0))
	self:DrawModel()
	
	render.SetMaterial(matGlow)
	local size = math.sin(RealTime() * 16) * 14 + 14
	render.DrawSprite(self:GetPos(), size, size, Color(255, 25, 0))
end

RegisterItem(ITEM)