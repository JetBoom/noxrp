function EFFECT:Init(data)
	local vOffset = data:GetOrigin()

	sound.Play("physics/metal/metal_sheet_impact_bullet1.wav", vOffset, 79, math.Rand(95, 105))

	local emitter = ParticleEmitter(vOffset)
	for i=1, 12 do
        local particle = emitter:Add("effects/spark", vOffset)
		particle:SetVelocity(VectorRand() * math.Rand(0, 1400))
		particle:SetDieTime(math.Rand(0.1, 0.5)) 
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(20)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-5, 5))
		particle:SetAirResistance(400)
		particle:SetGravity(Vector(0, 0, -10))
	end

	local particle = emitter:Add("effects/yellowflare", vOffset)
	particle:SetVelocity(VectorRand() * math.Rand(0, 10))
	particle:SetDieTime(math.Rand(0.1, 0.2))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(40)
	particle:SetEndSize(100)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-15, 15))
	particle:SetAirResistance(400)
	particle:SetGravity(Vector(0, 0, 10))          

	local particle1 = emitter:Add("effects/select_ring", vOffset)
	particle1:SetDieTime(math.Rand(0.1, 0.3))
	particle1:SetStartAlpha(200)
	particle1:SetEndAlpha(0)
	particle1:SetStartSize(30)
	particle1:SetEndSize(100)
	particle1:SetRoll(math.Rand(0, 360))
	particle1:SetRollDelta(math.Rand(-15, 15))
	particle1:SetColor(255, 255, 255)

	emitter:Finish()    
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end 
