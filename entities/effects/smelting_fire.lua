function EFFECT:Init(data)
	local pos = data:GetOrigin()
	
	local emitter = ParticleEmitter(pos)
	
	for i = 1, 4 do
		local particle = emitter:Add("effects/fire_cloud1", pos)
			particle:SetVelocity(Vector(math.Rand(-0.8, 0.8) * 50, math.Rand(-0.8, 0.8) * 50, 50))
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(16)
			particle:SetEndSize(8)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(255, math.random(100, 220), 100)
			particle:SetCollide(true)
	end
	
	for i = 1, 8 do
		local particle = emitter:Add("effects/fire_cloud1", pos)
			particle:SetVelocity(Vector(math.Rand(-1, 1) * 100, math.Rand(-1, 1) * 100, 100))
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(4)
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(255, 220, 100)
			particle:SetCollide(true)
			particle:SetGravity(Vector(0, 0, -600))
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
