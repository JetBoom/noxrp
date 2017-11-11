function EFFECT:Init(data)
	local pos = data:GetOrigin()

	sound.Play("weapons/explode3.wav", pos, 90, math.Rand(95, 105))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)
		for i=1, math.random(5, 10) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand() * 128)
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(32)
			particle:SetEndSize(4)
			particle:SetColor(60, 20, 20)
			particle:SetRoll(math.Rand(0, 360))
		end
		for i=1, math.random(62, 84) do
			local particle = emitter:Add("effects/fire_cloud1", pos)
			particle:SetVelocity(VectorRand():GetNormal() * math.Rand(64, 360))
			particle:SetDieTime(math.Rand(1, 1.8))
			particle:SetStartAlpha(240)
			particle:SetEndAlpha(20)
			particle:SetStartSize(math.Rand(14, 24))
			particle:SetEndSize(2)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetCollide(true)
			particle:SetGravity(Vector(0,0,-100))
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
