local ITEM = {}
ITEM.DataName = "messagepost_small"

ITEM.Description = "A small post that displays messages."
ITEM.Pos3 = Vector(5, 0, 25)

function ITEM:Draw()
	self:DrawModel()
	
	self:LocalDraw()
	
	if not self:GetLockedDown() then
		self:DrawOverheadName()
	end
end
	
function ITEM:LocalDraw()
	if self:GetPos():Distance(LocalPlayer():GetPos()) > 300 then return end
		
	local pos = self:GetPos() + self:GetForward() * self.Pos3.x + self:GetRight() * self.Pos3.y + self:GetUp() * self.Pos3.z
	local origin = self:GetAngles()
	origin:RotateAroundAxis(self:GetUp(), 90)
	origin:RotateAroundAxis(self:GetRight(), -90)
		
	cam.Start3D2D(pos, origin, 0.08)
		surface.SetFont("hidden48")
		
		local tw, th = surface.GetTextSize(self:GetDisplayMessage())
			
		draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 - 5, tw + 10, th + 10, Color(20, 20, 20, 180))
		draw.SimpleText(self:GetDisplayMessage(), "hidden48", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

RegisterItem(ITEM)