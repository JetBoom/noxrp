function EFFECT:Init(data)
	local ent = data:GetEntity()
	
	if ent:IsValid() then
		
		local emitter = ParticleEmitter(ent:GetPos())
		
		local bottom = ent:GetPos()
		for i=0, 15 do
			local particle = emitter:Add("effects/fire_cloud1", bottom)
				particle:SetVelocity(Vector(math.Rand(-1, 1) * 100, math.Rand(-1, 1) * 100, 0))
				particle:SetDieTime(0.3)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(2)
				particle:SetEndSize(2)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255, 220, 100)
				particle:SetCollide(true)
				particle:SetGravity(Vector(0, 0, 100))
				particle:SetAirResistance(400)
		end
		
		emitter:Finish()
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
