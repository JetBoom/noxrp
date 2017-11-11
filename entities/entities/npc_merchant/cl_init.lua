include("shared.lua")

function ENT:Initialize()
	self:SetSequence(self:LookupSequence("idle_all_01"))
end

function ENT:Think()
	if self:GetSequence() != self:LookupSequence("idle_all_01") then
		self:SetSequence(self:LookupSequence("idle_all_01"))
	end
end

function ENT:Draw()
	self:DrawModel()
	
	local ang = EyeAngles()
	cam.Start3D2D(self:GetPos() + Vector(0, 0, 80), Angle(180, ang.y + 90, -90), 0.05)
		draw.RoundedBox(8, -300, -50, 600, 100, Color(0, 0, 0, 200))
		draw.SimpleText(self:GetDTString(0), "hidden48", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
