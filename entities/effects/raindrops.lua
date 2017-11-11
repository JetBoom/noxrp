function EFFECT:Init(data)
	local pos = data:GetOrigin()
	self.Origin = pos

	self.Emitter = ParticleEmitter(pos)
	self.Emitter:SetNearClip(24, 32)

	sound.Play("ambient/water/water_spray1.wav", pos, 60)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	for i=1, 2 do
		local randvec = Vector(math.Rand(-1,1)*10,math.Rand(-1,1)*10,100)
		local particle = self.Emitter:Add("effects/spark", self.Origin)
		particle:SetVelocity(randvec)
		particle:SetDieTime(0.8)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(1)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(180, 180, 255)
		particle:SetGravity(Vector(0,0,-600))
	end
end
