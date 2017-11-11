include("shared.lua")

function ENT:Initialize()
	self.AmbientSound = CreateSound(self, "weapons/flaregun/burn.wav")
	self.Created = CurTime()
	self.Death = CurTime() + 5
end

local acid = Material("noxrp/acid001")
local acidglow = Material("sprites/light_glow02_add")
function ENT:Think()
	local pos = self:GetPos()
	local mins = Vector(-10, -100, -10)
	local maxs = mins * -1
	
	local grounddir = VectorRand()
		grounddir.z = 0
		
	local particlesize = 1
	if (CurTime() + 2) > self.Death then
		particlesize = math.max((self.Death - CurTime()) / 2, 0)
	end
	
	self.AmbientSound:PlayEx(0.4 * particlesize, 110)
	
	local emitter = ParticleEmitter(self:GetPos())
	
	local particle = emitter:Add("effects/fire_cloud"..math.random(2), self:GetPos() + grounddir * math.Rand(-1, 1) * 20)
		particle:SetColor(0, 200, 0)
		particle:SetDieTime(math.Rand(0.8, 1.2))
		particle:SetGravity(Vector(0, 0, -500))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(8, 12) * particlesize)
		particle:SetEndSize(math.random(10, 14) * particlesize)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-20, 20))
		particle:SetCollide(true)
		particle:SetVelocity(Vector(math.Rand(-1, 1) * 10, math.Rand(-1, 1) * 10, math.Rand(0.5, 1) * 200))
		
	local particle = emitter:Add("effects/fire_cloud"..math.random(2), self:GetPos() + grounddir * math.Rand(-1, 1) * 20)
		particle:SetColor(0, 200, 0)
		particle:SetDieTime(math.Rand(0.8, 1.2))
		particle:SetGravity(Vector(0, 0, -500))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(2, 3) * particlesize)
		particle:SetEndSize(math.random(4, 5) * particlesize)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-20, 20))
		particle:SetCollide(true)
		particle:SetVelocity(Vector(math.Rand(-1, 1) * 80, math.Rand(-1, 1) * 80, math.Rand(0, 1) * 300))
	
	for i = 1, 2 do
		grounddir = VectorRand()
			grounddir.z = 0
		
		local dir = VectorRand()
			dir.z = math.abs(dir.z)
			
		local particle = emitter:Add("effects/fire_cloud"..math.random(2), self:GetPos() + grounddir * math.Rand(-1, 1) * 20)
			particle:SetColor(0, 200, 0)
			particle:SetDieTime(math.Rand(0.8, 1.2))
			particle:SetGravity(Vector(0, 0, -50))
			particle:SetStartAlpha(200)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(2, 4) * particlesize)
			particle:SetEndSize(math.random(10, 14) * particlesize)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-20, 20))
			particle:SetCollide(true)
			particle:SetVelocity(dir * 50)
	end
	
	emitter:Finish()
	
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
	
	//render.SetMaterial(acid)
	//render.DrawQuadEasy(self:GetPos() + self:GetUp() * 1, Vector(0, 0, 1), (50 + 20 * xsize) * particlesize, (50 + 20 * ysize) * particlesize, Color(100, 200, 50, 200), 0)
	//render.DrawQuadEasy(self:GetPos() + self:GetUp() * 1, Vector(0, 0, 1), (50 + 20 * ysize) * particlesize, (50 + 20 * xsize) * particlesize, Color(100, 200, 50, 200), 0)
	
	render.SetMaterial(acidglow)
	render.DrawQuadEasy(self:GetPos() + self:GetUp() * 1, EyePos() - (self:GetPos() + self:GetUp() * 5), (300 + 5 * xsize) * particlesize, (300 + 5 * ysize) * particlesize, Color(100, 200, 50, 200), 0)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end
