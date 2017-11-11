include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	if self:GetDying() then
		local timetotal = self:GetDieTime()
		local per = math.Clamp((timetotal - CurTime()) / 5, 0, 1)
		
		render.SetBlend(per)
		self:DrawModel()
		render.SetBlend(1)
	else
		self:DrawModel()
	end
end

function ENT:Think()
end