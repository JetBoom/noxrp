local matRefraction	= Material("refract_ring")
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	self.Origin = pos

	util.Decal("Scorch", pos + Vector(0,0,1), pos + Vector(0,0,-1))

	self.BeginSmoke = CurTime() + 0.5
	self.RefractBallDeath = CurTime() + 4
	self.RefractSize = 0
	self.RefractAmount = 1

	local emitter = ParticleEmitter(pos)
	self.Emitter = emitter
	emitter:SetNearClip(40, 50)

	for i=1, 32 do
		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), pos + heading * 128)
		particle:SetVelocity(heading * math.Rand(500, 1200))
		particle:SetDieTime(math.Rand(4, 6))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(256)
		particle:SetEndSize(1024)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(50, 150))
	end
end

function EFFECT:Think()
	if self.BeginSmoke then
		if self.BeginSmoke <= CurTime() then
			local emitter = self.Emitter
			for i=1, 16 do
				local heading = VectorRand()
				heading:Normalize()
				
				local particle = emitter:Add("particle/smokestack", self.Entity:GetPos() + heading * math.Rand(128, 256))
				particle:SetVelocity(VectorRand() * 256)
				particle:SetDieTime(math.Rand(20, 24))
				particle:SetStartAlpha(64)
				particle:SetEndAlpha(0)
				particle:SetStartSize(0)
				particle:SetEndSize(768)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand( -1, 1))
				particle:SetColor(128, 128, 128)
				particle:SetAirResistance(100)
			end

			emitter:Finish()
			self.BeginSmoke = nil
		end
	end
	
	if self.RefractBallDeath <= CurTime() then
		return false
	end

	return true
end

function EFFECT:Render()
	self.RefractSize = self.RefractSize + FrameTime() * 4000
	self.RefractAmount = math.max(self.RefractAmount - FrameTime() * 1.1, 0)
	
	local norm = LocalPlayer():GetAimVector() * -1
	
	matRefraction:SetFloat("$refractamount", self.RefractAmount)
	render.SetMaterial(matRefraction)
	render.UpdateRefractTexture()
	render.DrawQuadEasy(self.Origin, norm, self.RefractSize, self.RefractSize, color_white, 0)
	render.DrawQuadEasy(self.Origin, norm * -1, self.RefractSize, self.RefractSize, color_white, 0)
end
