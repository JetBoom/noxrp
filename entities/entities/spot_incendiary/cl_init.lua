include("shared.lua")

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "ambient/fire/fire_med_loop1.wav")
	
	self.Created = CurTime()
	self.Death = CurTime() + 10
	self.NextParticle = CurTime()
end

local glow = Material("sprites/light_glow02_add")
function ENT:Think()
	local particlesize = 1
	if (CurTime() + 2) > self.Death then
		particlesize = math.max((self.Death - CurTime()) / 2, 0)
	end
	
	self.AmbientSound:PlayEx(0.4 * particlesize, 110)
	
	if self.NextParticle < CurTime() then
		self.NextParticle = CurTime() + 0.01
		local emitter = ParticleEmitter(self:GetPos())
		
		local grounddir = VectorRand()
			grounddir.z = 0
		
		local particle = emitter:Add("effects/fire_cloud"..math.random(2), self:GetPos() + grounddir * math.Rand(-1, 1) * 20)
			particle:SetDieTime(math.Rand(0.8, 1.2))
			particle:SetGravity(Vector(0, 0, -500))
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(8, 12) * particlesize)
			particle:SetEndSize(math.Rand(10, 14) * particlesize)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-20, 20))
			particle:SetCollide(true)
			particle:SetVelocity(Vector(math.Rand(-1, 1) * 10, math.Rand(-1, 1) * 10, math.Rand(0.5, 1) * 300))
			
		local particle = emitter:Add("effects/fire_cloud"..math.random(2), self:GetPos() + grounddir * math.Rand(-1, 1) * 20)
			particle:SetDieTime(math.Rand(0.8, 1.2))
			particle:SetGravity(Vector(0, 0, -500))
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(2, 3) * particlesize)
			particle:SetEndSize(math.Rand(4, 5) * particlesize)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-20, 20))
			particle:SetCollide(true)
			particle:SetVelocity(Vector(math.Rand(-1, 1) * 80, math.Rand(-1, 1) * 80, math.Rand(0, 1) * 400))
		
		for i = 1, 2 do
			grounddir = VectorRand()
				grounddir.z = 0
			
			local dir = VectorRand()
				dir.z = math.abs(dir.z)
				
			local particle = emitter:Add("effects/fire_cloud"..math.random(2), self:GetPos() + grounddir * math.Rand(-1, 1) * 20)
				particle:SetDieTime(math.Rand(0.8, 1.2))
				particle:SetGravity(Vector(0, 0, -50))
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(2, 4) * particlesize)
				particle:SetEndSize(math.Rand(10, 14) * particlesize)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-20, 20))
				particle:SetCollide(true)
				particle:SetVelocity(dir * 50)
		end
		
		emitter:Finish()
	end
	local dl = GetConVar("noxrp_enabledlight"):GetBool()
	
	if dl then
		local dlight = DynamicLight(self:EntIndex())
		if ( dlight ) then
			dlight.Pos = self:GetPos()
			dlight.r = 255
			dlight.g = 100
			dlight.b = 0
			dlight.Brightness = 0.5
			dlight.Decay = 128
			dlight.Size = 200
			dlight.DieTime = CurTime() + 1
		end
	end
end

function ENT:Draw()
	local particlesize = 1
	if (CurTime() + 2) > self.Death then
		particlesize = math.max((self.Death - CurTime()) / 2, 0)
	end
	
	local xsize = math.cos(CurTime() * 6)
	local ysize = math.sin(CurTime() * 6)
	
	render.SetMaterial(glow)
	render.DrawQuadEasy(self:GetPos() + self:GetUp() * 5, EyePos() - (self:GetPos() + self:GetUp() * 5), (300 + 10 * xsize) * particlesize, (300 + 10 * ysize) * particlesize, Color(255, 200, 50, 255), 0)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end
