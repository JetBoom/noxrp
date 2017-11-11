local matRefraction	= Material("refract_ring")
function EFFECT:Init( data )
	self.Origin = data:GetOrigin()
	
	self.RefractBallDeath = CurTime() + 0.4
	self.RefractSize = 0
	self.RefractAmount = 2
	
	util.Decal("SmallScorch", self.Origin + Vector(0, 0, 1), self.Origin + Vector(0, 0, -1))
	
	local emitter = ParticleEmitter(self.Origin)
	
	for i=1, 8 do
		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self.Origin)
		particle:SetVelocity(heading * math.Rand(500, 1200))
		particle:SetDieTime(math.Rand(4, 6))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(6)
		particle:SetEndSize(8)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(20, 50))
		particle:SetGravity(Vector(0, 0, -500))
	end
	
	for i=1, 8 do
		local heading = VectorRand()
			heading.z = math.abs(heading.z)
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self.Origin + heading * 6)
		particle:SetVelocity(Vector(heading.x * math.Rand(200, 400), heading.y * math.Rand(200, 400), heading.z * math.Rand(1200, 1550)))
		particle:SetDieTime(math.Rand(1, 1.5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(30)
		particle:SetEndSize(50)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(400, 600))
	end
	
	for i = 1, 4 do
		local particle = emitter:Add("particle/smokestack", self.Origin + VectorRand() * math.Rand(2, 4))
			particle:SetVelocity(VectorRand() * 200)
			particle:SetDieTime(math.Rand(4, 5.3))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(50)
			particle:SetEndSize(80)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand( -1, 1))
			particle:SetAirResistance(100)
			particle:SetCollide(true)
			particle:SetBounce(0.5)
			particle:SetColor(30, 30, 30)
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	return self.RefractBallDeath > CurTime()
end

function EFFECT:Render()
	if self.RefractBallDeath > CurTime() then
		self.RefractSize = self.RefractSize + FrameTime() * 1000
		self.RefractAmount = math.max(self.RefractAmount - FrameTime() * 3, 0)
		
		local norm = LocalPlayer():GetAimVector() * -1
		
		matRefraction:SetFloat("$refractamount", self.RefractAmount)
		render.SetMaterial(matRefraction)
		render.UpdateRefractTexture()
		render.DrawQuadEasy(self.Origin, norm, self.RefractSize, self.RefractSize, color_white, 0)
		render.DrawQuadEasy(self.Origin, norm * -1, self.RefractSize, self.RefractSize, color_white, 0)
	end
end
