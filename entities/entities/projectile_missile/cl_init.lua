include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(true)
	self.Created = CurTime()

	self.MoveSound = CreateSound(self, "weapons/rpg/rocket1.wav")
	
	local emitter = ParticleEmitter(self:GetPos())
	
	local vOffset = self:GetPos()
	for i=1, 10 do
		local particle = emitter:Add("particle/smokestack", vOffset)
		particle:SetDieTime(2)
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(2)
		particle:SetEndSize(math.Rand(32, 48))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(0,0,0,255)
		particle:SetVelocity(Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1))*50)
	end
	
	emitter:Finish()
end

function ENT:Draw()
	self:DrawModel()
	self:DrawOffScreen()
end

function ENT:DrawOffScreen()
	local vOffset = self:GetPos()
	
	local emitter = ParticleEmitter(self:GetPos())
	emitter:SetNearClip(24, 32)
	
	local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), vOffset)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(12, 16))
		particle:SetEndSize(8)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
	
	local particle = emitter:Add("effects/fire_embers"..math.random(1,3), vOffset)
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(14, 20))
		particle:SetEndSize(8)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))

	local vel = self:GetVelocity()

	local particle = emitter:Add("sprites/light_glow02_add", vOffset + VectorRand():GetNormal() * 10)
		particle:SetVelocity(vel * -0.1 + VectorRand() * 8)
		particle:SetDieTime(1.25)
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(20)
		particle:SetStartSize(math.Rand(12, 16))
		particle:SetEndSize(2)
		particle:SetColor(self:GetColor())
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
	
	local particle = emitter:Add("particle/smokestack", vOffset)
		particle:SetDieTime(0.6)
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(60)
		particle:SetStartSize(math.Rand(14, 20))
		particle:SetEndSize(2)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(0, 0, 0, 255)
		particle:SetVelocity(Vector(math.Rand(-1, 1),math.Rand(-1, 1),math.Rand(-1, 1)) * 30)
	
	emitter:Finish()
end

function ENT:Think()
	self.MoveSound:Play()
end

function ENT:OnRemove()
	self.MoveSound:Stop()
end
