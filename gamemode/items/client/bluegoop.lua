local ITEM = {}
ITEM.DataName = "bluegoop"

ITEM.Description = "A small glob of blue goop. It feels cold to the touch."
ITEM.InventoryCameraPos = Vector(0, 0, 9)

local matGlow = Material("sprites/light_glow02_add")
function ITEM:LocalDraw()
	self:SetMaterial("models/shiny")
		
	self:SetColor(Color(0, 100, 255))
	self:DrawModel()
		
	render.SetMaterial(matGlow)
	local size = math.sin(RealTime() * 16) * 16 + 16
	render.DrawSprite(self:GetPos(), size, size, Color(0, 100, 255))
end
	
function ITEM:DermaMenuSetup(panel)
	panel.Entity:SetMaterial("models/shiny")

	panel:SetColor(Color(0, 100, 255))
end

RegisterItem(ITEM)