function EFFECT:Init(data)
	local pos = data:GetOrigin()
	
	self.LifeTime = CurTime() + 3
	
	self:SetModel("models/props_junk/rock001a.mdl")
	self.Velocity = VectorRand() * 600
	self.AirResistance = 50
	self.Gravity = Vector(0, 0, -600)
end

function EFFECT:Think()
	if self.LifeTime < CurTime() then
		return false
	else
		return true
	end
end

function EFFECT:Render()
	self:SetPos(self:GetPos() + (self.Velocity / self.AirResistance) * FrameTime() + (self.Gravity / self.AirResistance) * FrameTime())

	self:DrawModel()
end
