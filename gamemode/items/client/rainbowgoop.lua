local ITEM = {}
ITEM.DataName = "rainbowgoop"

ITEM.Description = "A small glob of goop. It glows a variety of colors."
ITEM.InventoryCameraPos = Vector(0, 0, 9)
ITEM.ItemPanelMaterial = "models/shiny"

local matGlow = Material("sprites/light_glow02_add")
	
function ITEM:BuildItemPanelColor()
	local r = math.sin(CurTime() * 0.5) * 255
	if r < 0 then
		r = r * -1
	end
		
	local g = math.sin(CurTime() * 0.7) * 255
	if g < 0 then
		g = g * -1
	end
		
	local b = math.sin(CurTime() * 0.9) * 255
	if b < 0 then
		b = b * -1
	end
		
	return Color(r, g, b)
end
	
function ITEM:LocalDraw()
	self.Entity:SetMaterial("models/shiny")

	self:DrawModel()
	render.SetMaterial(matGlow)
		
	local r = math.sin(CurTime() * 0.5) * 255
	if r < 0 then
		r = r * -1
	end
		
	local g = math.sin(CurTime() * 0.7) * 255
	if g < 0 then
		g = g * -1
	end
		
	local b = math.sin(CurTime() * 0.9) * 255
	if b < 0 then
		b = b * -1
	end
		
	local col = Color(r, g, b)
	self:SetColor(Color(col.r, col.g, col.b))
		
	local size = math.sin(RealTime() * 16) * 16 + 24
	render.DrawSprite(self.Entity:GetPos(), size, size, Color(col.r, col.g, col.b))
	--use setcolormodulation instead
end
	
function ITEM:DermaMenuSetup(panel)
	panel.Entity:SetMaterial("models/shiny")
end

RegisterItem(ITEM)