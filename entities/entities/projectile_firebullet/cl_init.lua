include("shared.lua")

function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetModelScale(1.5, 0)
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
	
	self.NextFire = 0
end

function ENT:Think()
	local dl = GetConVar("noxrp_enabledlight"):GetBool()
	
	if dl then
		local dlight = DynamicLight(self:EntIndex())
		if ( dlight ) then
			dlight.Pos = self:GetPos()
			dlight.r = 255
			dlight.g = 100
			dlight.b = 0
			dlight.Brightness = 0.1
			dlight.Decay = 128
			dlight.Size = 80
			dlight.DieTime = CurTime() + 1
		end
	end
end

function ENT:OnRemove()
	local dl = GetConVar("noxrp_enabledlight"):GetBool()
	
	if dl then
		local dlight = DynamicLight(self:EntIndex())
		if ( dlight ) then
			dlight.Pos = self:GetPos()
			dlight.r = 255
			dlight.g = 100
			dlight.b = 0
			dlight.Brightness = 0.1
			dlight.Decay = 128
			dlight.Size = 80
			dlight.DieTime = CurTime() + 1
		end
	end
end

function ENT:SetupAngles(vel)
	if vel ~= vector_origin then
		self:SetAngles(vel:Angle())
	end
end

local matBeam = Material("effects/spark")
local matGlow = Material("sprites/glow04_noz")
local colBeam = Color(255, 255, 255)
local color_white = Color(255, 255, 255)

function ENT:DoColors()
	colBeam.r = 255
	colBeam.g = 200
	colBeam.b = 0
	colBeam.a = 255
end

function ENT:EmitParticles()
	local dist = self:GetPos():Distance(EyePos())
	
	if dist < 400 then
		local emitter = ParticleEmitter(self:GetPos())
		emitter:SetNearClip(8, 12)
	
		local particle = emitter:Add("sprites/glow04_noz", self:GetPos() + VectorRand():GetNormalized() * math.Rand(-2, 2))
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(1)
			particle:SetRoll(math.Rand(0, 360))
		local r, g, b, a = self:GetColor()
			particle:SetColor(r, g, b)
			
		if self.NextFire < CurTime() then
			self.NextFire = CurTime() + 0.05
			local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self:GetPos() + VectorRand():GetNormalized() * math.Rand(-2, 2))
				particle:SetDieTime(0.5)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(2)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetColor(255, 255, 255)
		end
		
		emitter:Finish()
	end
end

function ENT:DrawGlow()
	local pos = self:GetPos()
	render.SetMaterial(matGlow)
	render.DrawSprite(pos, 6, 6, colBeam)
	render.DrawSprite(pos, 3, 3, color_white)
end

function ENT:Draw()
	local vel = self:GetVelocity()
	self:SetupAngles(vel)

	self:DrawModel()

	self:DoColors()

	vel:Normalize()
	local start = self:GetPos()
	local endpos = start - vel * 100
	render.SetMaterial(matBeam)
	render.DrawBeam(start, endpos, 4, 1, 0, colBeam)
	render.DrawBeam(start, endpos, 2, 1, 0, colBeam)
	render.DrawBeam(start, endpos, 1, 1, 0, color_white)

	self:DrawGlow()

	self:EmitParticles()
end
