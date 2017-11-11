
function EFFECT:Init( data )
	local vOffset = data:GetOrigin()
	local emitter = ParticleEmitter(vOffset)
	
	local particle = emitter:Add("sprites/light_glow02_add", vOffset)
	if particle then
		local size = math.random(36, 42)
		particle:SetDieTime(math.Rand(0.04, 0.06))
		particle:SetStartSize(size)
		particle:SetEndSize(0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetColor(255, 180, 0)
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
