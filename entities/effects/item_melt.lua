function EFFECT:Init(data)
	local vPos = data:GetOrigin()
	
	local emitter = ParticleEmitter(vPos)

	for i=1, math.random(12, 14) do
		local particle = emitter:Add("particles/balloon_bit", vPos + VectorRand():GetNormal() * 8)
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(3, 5))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(100)
					
		local Size = math.Rand(8, 12)
			particle:SetStartSize(Size)
			particle:SetEndSize(Size * 0.25)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetGravity(Vector(0, 0, -50))
			particle:SetColor(20, 20, 20)
			particle:SetCollide(true)
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
