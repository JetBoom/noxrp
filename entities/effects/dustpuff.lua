function EFFECT:Init( data )
	local vPos = data:GetOrigin()
	local per = data:GetNormal()

	local emitter = ParticleEmitter(vPos)

	for i=1, 2 do
		local particle = emitter:Add("particles/smokey", vPos + Vector(math.Rand(-1, 1) * 20,math.Rand(-1, 1) * 20, 0))
			particle:SetVelocity(Vector(math.Rand(-1, 1) * 200,math.Rand(-1, 1) * 200, 0))
			particle:SetDieTime(2)
			particle:SetStartAlpha(50 - 50 * per.z)
			particle:SetEndAlpha(0)
			particle:SetStartSize(80)
			particle:SetEndSize(80)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(150, 150, 150)
			particle:SetCollide(true)
			particle:SetLighting(true)
	end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
