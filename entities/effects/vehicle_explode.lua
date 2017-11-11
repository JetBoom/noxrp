local matRefraction	= Material("refract_ring")
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	self.Origin = pos
	local scale = GetConVarNumber("noxrp_effectlevel")

	util.Decal("Scorch", pos + Vector(0,0,1), pos + Vector(0,0,-1))
	local dist = pos:Distance(LocalPlayer():GetPos())
	
	LocalPlayer():EmitSound("npc/combine_gunship/gunship_explode2.wav", math.max(100 - 80 * (dist / 8000), 0))
	--sound.Play("npc/combine_gunship/gunship_explode2.wav", pos, 180, 100, 1)

	self.BeginSmoke = CurTime() + 0.2
	
	self.RefractBallDeath = CurTime() + 4
	self.RefractSize = 0
	self.RefractAmount = 1.5

	local emitter = ParticleEmitter(pos)
	self.Emitter = emitter
	emitter:SetNearClip(40, 50)

	for i=1, 26 do
		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), pos)
		particle:SetVelocity(heading * math.Rand(400, 600))
		particle:SetDieTime(math.Rand(8, 12))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(100)
		particle:SetEndSize(350)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(50, 150))
	end
	
	for i=1, 8 do
		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), pos)
		particle:SetVelocity(heading * math.Rand(1800, 2200))
		particle:SetDieTime(math.Rand(2, 3))
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(350)
		particle:SetEndSize(200)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(10, 20))
		particle:SetGravity(Vector(0, 0, -600))
	end
	
	for i=1, 8 + 6 * scale do
		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), pos + heading * 128)
		particle:SetVelocity(heading * math.Rand(200, 600) + Vector(0, 0, 1500))
		particle:SetDieTime(math.Rand(8, 12))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(120, 160))
		particle:SetEndSize(math.random(250, 300))
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(50, 150))
	end
	
	for i=1, 6 do
		local heading = VectorRand()
		heading:Normalize()
			
		local particle = emitter:Add("particle/smokestack", self.Entity:GetPos() + Vector(0, 0, math.random(-100, 500)))
		particle:SetVelocity(heading * math.Rand(200, 400) + Vector(0, 0, 1000))
		particle:SetDieTime(math.Rand(20, 24))
		particle:SetStartAlpha(220)
		particle:SetEndAlpha(0)
		particle:SetStartSize(100)
		particle:SetEndSize(300)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand( -1, 1))
		particle:SetColor(60, 60, 60)
		particle:SetAirResistance(100)
	end
end

function EFFECT:Think()
	if self.BeginSmoke then
		if self.BeginSmoke <= CurTime() then
		local emitter = self.Emitter
			for i=1, 12 do
				local heading = VectorRand()
				heading:Normalize()
				
				local particle = emitter:Add("particle/smokestack", self.Entity:GetPos() + heading * math.Rand(128, 256))
				particle:SetVelocity(VectorRand() * 256)
				particle:SetDieTime(math.Rand(20, 24))
				particle:SetStartAlpha(130)
				particle:SetEndAlpha(0)
				particle:SetStartSize(200)
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
	self.RefractAmount = math.max(self.RefractAmount - FrameTime() * 1.5, 0)
	
	local norm = LocalPlayer():GetAimVector() * -1
	
	matRefraction:SetFloat("$refractamount", self.RefractAmount)
	render.SetMaterial(matRefraction)
	render.UpdateRefractTexture()
	render.DrawQuadEasy(self.Origin, norm, self.RefractSize, self.RefractSize, color_white, 0)
	render.DrawQuadEasy(self.Origin, norm * -1, self.RefractSize, self.RefractSize, color_white, 0)
end
