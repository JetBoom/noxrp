include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Think()
end

function ENT:OnRemove()
	local emitter = ParticleEmitter(self:GetPos())
	
	for i = 1, 8 do
		local vec = VectorRand()
		vec.z = math.abs(vec.z)
		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), self:GetPos())
		particle:SetVelocity(vec * 200)
		particle:SetGravity(Vector(0, 0, -200))
		particle:SetDieTime(math.Rand(1, 1.5))
		particle:SetStartAlpha(40)
		particle:SetEndAlpha(0)
		particle:SetStartSize(32)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(128, 178, 128)
		particle:SetCollide(true)
	end
	
	emitter:Finish()
end

function ENT:Draw()
	self:DrawModel()
	
	local emitter = ParticleEmitter(self:GetPos())
	
	for i = 1, 2 do
		local particle = emitter:Add("particles/smokey", self:GetPos() - Vector(0, 0, self.Radius))
		particle:SetGravity(Vector(0, 0, -100))
		particle:SetVelocity(VectorRand() * 20)
		particle:SetDieTime(1)
		particle:SetStartAlpha(40)
		particle:SetEndAlpha(0)
		particle:SetStartSize(32)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(128, 178, 128)
		particle:SetCollide(true)
	end
	
	emitter:Finish()
end
