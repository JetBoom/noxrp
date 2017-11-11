include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self.Emitter = ParticleEmitter(self:GetPos())
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

function ENT:Think()
end

function ENT:Draw()
	self.Entity:DrawModel()
	local emitter = self.Emitter
	local pos = self:GetPos()
	emitter:SetPos(pos)

	local smoke = emitter:Add("particles/smokey", pos)
		smoke:SetDieTime(1)
		smoke:SetStartAlpha(220)
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(2)
		smoke:SetEndSize(math.Rand(1,1.3))
		smoke:SetRoll(math.Rand(0, 360))
		smoke:SetRollDelta(math.Rand(-5, 5))
		smoke:SetColor(0, 0, 0)
		smoke:SetGravity(Vector(0,0,-400))
		smoke:SetColor(150,150,150)
		
	local smoke = emitter:Add("effects/yellowflare", pos)
		smoke:SetDieTime(1)
		smoke:SetStartAlpha(220)
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(1)
		smoke:SetEndSize(math.Rand(0,0.3))
		smoke:SetRoll(math.Rand(0, 360))
		smoke:SetRollDelta(math.Rand(-5, 5))
		smoke:SetColor(0, 0, 0)
		smoke:SetGravity(Vector(0,0,-400))
		smoke:SetColor(255,255,255)
end
