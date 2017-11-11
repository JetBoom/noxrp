function EFFECT:Init( data )
	local vPos = data:GetOrigin()

	local emitter = ParticleEmitter(vPos)
	
	sound.Play("physics/concrete/rock_impact_hard"..math.random(6)..".wav", vPos)

	for i = 1, 16 do
		local particle = emitter:Add("particles/smokey", vPos + VectorRand() * 4)
			particle:SetVelocity(Vector(math.Rand(-1, 1) * 40, math.Rand(-1, 1) * 40, 50))
			particle:SetDieTime(2)
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(16)
			particle:SetEndSize(32)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(150, 150, 150)
			particle:SetCollide(true)
			particle:SetLighting(true)
			particle:SetAirResistance(20)
			particle:SetGravity(Vector(0, 0, -100))
	end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
