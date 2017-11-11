function EFFECT:Init( data )
	local vPos = data:GetOrigin()
	local vDir = data:GetNormal()
	local scale = data:GetScale()

	local emitter = ParticleEmitter(vPos)

	for i=1, 3 * scale do
		local particle = emitter:Add("effects/splash2", vPos)
			particle:SetVelocity(vDir * 20 + Vector(math.Rand(-1,1) * 500, math.Rand(-1,1) * 500, 100))
			particle:SetDieTime(1 * scale)
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(0)
			particle:SetStartSize(scale * 0.1)
			particle:SetEndSize(scale * 0.1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(Vector(0,0, -400))
			particle:SetColor(255, 255, 255)
			particle:SetCollide(true)
			particle:SetRoll(math.random(0, 360))
		--	particle:SetLighting(true)
	end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
