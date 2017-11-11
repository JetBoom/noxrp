include("shared.lua")

function ENT:Initialize()
	self.Created = CurTime()
end
	
function ENT:OnRemove()
end
	
function ENT:Draw()
	self:DrawModel()
	local ang = self:GetAngles()
	local pos = self:GetPos()
	local len = 400
	local hei = 40
	
	local hacktime = self:GetHackTime()
	
	local per = hacktime - CurTime()
	local totaltime = hacktime - self.Created
	local totl = per / totaltime
	
	cam.Start3D2D(pos + ang:Forward() * 5, ang + Angle(0, 90, 90), 0.02)
		surface.SetDrawColor(10, 10, 10, 255)
		surface.DrawRect(len * -0.5, hei * -0.5, len, hei)
		
		surface.SetDrawColor(0, 100, 255, 255)
		surface.DrawRect(len * -0.5 + 2, hei * -0.5 + 2, len * totl - 4, hei - 4)
		draw.SimpleText(math.Round(per, 2), "hidden18", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end