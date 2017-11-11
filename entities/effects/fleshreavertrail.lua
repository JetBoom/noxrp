function EFFECT:Init( data )
	self.Entity = data:GetEntity()
end

function EFFECT:Think()
	if self.Entity:IsValid() then
		local pos = self.Entity:GetPos()
		self:SetPos(pos)
		local emitter = ParticleEmitter(pos)

		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos + Vector(0, 0, 10))
			particle:SetVelocity(VectorRand() * 100)
			particle:SetDieTime(math.Rand(0.4, 0.6))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(20)
			particle:SetEndSize(30)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand( -1, 1))
			particle:SetColor(255, 100, 100)
			particle:SetAirResistance(50)
			particle:SetCollide(true)
			particle:SetBounce(0.5)
			particle:SetGravity(Vector(0, 0, -500))
		
		emitter:Finish()
	end
	
	return self.Entity:IsValid()
end

function EFFECT:Render()
end
