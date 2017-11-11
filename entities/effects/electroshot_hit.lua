function EFFECT:Init(data)
	local vOffset = data:GetOrigin()

	sound.Play("weapons/airboat/airboat_gun_lastshot2.wav", vOffset, 79, math.Rand(95, 105))

	local emitter = ParticleEmitter(vOffset)
	for i = 1, 6 do
        local particle = emitter:Add("effects/spark", vOffset)
		particle:SetVelocity(VectorRand() * math.Rand(10, 60))
		particle:SetDieTime(math.Rand(0.5, 0.8)) 
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(6)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-5, 5))
		particle:SetAirResistance(200)
	end

	local particle = emitter:Add("effects/yellowflare", vOffset)
	particle:SetVelocity(VectorRand() * math.Rand(0, 10))
	particle:SetDieTime(math.Rand(0.4, 0.6))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(10)
	particle:SetEndSize(40)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-15, 15))
	particle:SetAirResistance(400)
	particle:SetGravity(Vector(0, 0, 10))          
	emitter:Finish()    
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end 
