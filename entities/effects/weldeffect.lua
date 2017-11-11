
function EFFECT:Init( data )
	local vOffset = data:GetOrigin()
	
	local emitter = ParticleEmitter(vOffset)
	for i=0, 4 do
		local particle = emitter:Add("effects/spark", vOffset)
		if particle then
			particle:SetVelocity(VectorRand() * 50)
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(1)
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-200, 200))
			particle:SetAirResistance(400)
			particle:SetGravity(Vector(0, 0, -100))
		end
	end	

	local particle = emitter:Add("sprites/light_glow02_add", vOffset)
	if particle then
		particle:SetVelocity(Vector(0, 0, 0))
		particle:SetDieTime(math.Rand(0.1, 0.2))
		particle:SetStartSize(math.random(6, 8))
		particle:SetEndSize(0)
	end
	emitter:Finish()
	
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )
	return false
end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()
end
