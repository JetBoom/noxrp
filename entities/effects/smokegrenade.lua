local matRefraction	= Material("refract_ring")
function EFFECT:Init( data )
	self.Origin = data:GetOrigin()
	if data:GetStart() then
		local vec = data:GetStart()
		self.Color = Color(vec.x * 255, vec.y * 255, vec.z * 255)
	else
		self.Color = Color(50, 50, 50)
	end
	
	self.RefractBallDeath = CurTime() + 0.4
	self.RefractSize = 0
	self.RefractAmount = 2
	
	self.DieTime = CurTime() + 20
	
	self.StartSmoke = CurTime() + 0
	self.NextSmoke = CurTime() + 0
	self.TotalSmokes = 0
	
	local emitter = ParticleEmitter(self.Origin)
	
	for i = 1, 8 do
		local particle = emitter:Add("particle/smokestack", self.Origin + VectorRand() * math.Rand(2, 4))
			particle:SetVelocity(VectorRand() * 600)
			particle:SetDieTime(math.Rand(0.4, 0.6))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(40)
			particle:SetEndSize(40)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand( -1, 1))
			if self.Color then
				particle:SetColor(self.Color.r, self.Color.g, self.Color.b)
			else
				particle:SetColor(50, 50, 50)
			end
			particle:SetAirResistance(80)
			particle:SetCollide(true)
			particle:SetBounce(0.8)
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	if self.StartSmoke < CurTime() then
		if self.TotalSmokes < 10 then
			if self.NextSmoke < CurTime() then
				self.TotalSmokes = self.TotalSmokes + 1
				
				local emitter = ParticleEmitter(self.Origin)
				
				for i = 1, 2 do
					local particle = emitter:Add("particle/smokestack", self.Origin + VectorRand() * math.Rand(2, 4))
						particle:SetVelocity(VectorRand() * 400)
						particle:SetDieTime(math.Rand(14, 16))
						particle:SetStartAlpha(180)
						particle:SetEndAlpha(0)
						particle:SetStartSize(40)
						particle:SetEndSize(200)
						particle:SetRoll(math.Rand(0, 360))
						particle:SetRollDelta(math.Rand( -1, 1))
					if self.Color then
						particle:SetColor(self.Color.r, self.Color.g, self.Color.b)
					else
						particle:SetColor(30, 30, 30)
					end
						particle:SetAirResistance(200)
						particle:SetCollide(true)
						particle:SetBounce(0.5)
				end
				
				for i = 1, 2 do
					local particle = emitter:Add("particle/smokestack", self.Origin + VectorRand() * math.Rand(2, 4))
						particle:SetVelocity(VectorRand() * 400)
						particle:SetDieTime(math.Rand(14, 16))
						particle:SetStartAlpha(180)
						particle:SetEndAlpha(0)
						particle:SetStartSize(40)
						particle:SetEndSize(200)
						particle:SetRoll(math.Rand(0, 360))
						particle:SetRollDelta(math.Rand( -1, 1))
						if self.Color then
							particle:SetColor(self.Color.r, self.Color.g, self.Color.b)
						else
							particle:SetColor(50, 50, 50)
						end
						particle:SetAirResistance(200)
						particle:SetCollide(true)
						particle:SetBounce(0.5)
				end
				
				emitter:Finish()
			end
		end
	end
	
	return self.DieTime > CurTime()
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
