function EFFECT:Init( data )
	local vPos = data:GetOrigin()
	local vDir = data:GetNormal()
	local vScale = data:GetScale()

	local emitter = ParticleEmitter(vPos)

	for i=1, 8 do
		local particle = emitter:Add("effects/splash2", vPos)
			particle:SetVelocity(Vector(math.Rand(-1,1) * 20,math.Rand(-1,1) * 20, 20))
			particle:SetDieTime(2)
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2 * vScale)
			particle:SetEndSize(24)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(100)
			particle:SetColor(255, 255, 255)
			particle:SetCollide(true)
	end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
