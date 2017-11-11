include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 32)

	self.AmbientSound = CreateSound(self, "ambient/explosions/exp2.wav")
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
	self.AmbientSound:PlayEx(1, 50)
end

function ENT:OnRemove()
	--self.Emitter:Finish()
	self.AmbientSound:Stop()
end

function ENT:Draw()
	self:DrawModel()
	for i = 1, 5 do
		local particle = self.Emitter:Add("particles/smokey", self:GetPos() - Vector(0, 0, self.Radius))
		particle:SetVelocity(self:GetVelocity() + VectorRand() * 100)
		particle:SetDieTime(1)
		particle:SetStartAlpha(40)
		particle:SetEndAlpha(0)
		particle:SetStartSize(32)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(194, 178, 128)
		particle:SetCollide(true)
	end
end
