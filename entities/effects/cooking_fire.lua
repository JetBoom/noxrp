function EFFECT:Init(data)
	local pos = data:GetOrigin()
	
	local emitter = ParticleEmitter(pos)
	
	for i=1, 4 do
		local vec = VectorRand()
		vec:Normalize()
		
		local particle = emitter:Add("effects/fire_cloud1", pos)
			particle:SetVelocity(Vector(0, 0, math.random(10, 20)))
			particle:SetDieTime(0.3)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(2)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(255, 220, 100)
			particle:SetCollide(true)
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
