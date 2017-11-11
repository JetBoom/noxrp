include("shared.lua")

function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetModelScale(1.5, 0)
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
	
	self.Created = CurTime()
	
	self.Trails = {}
	
	self.NextEffect = 0
end

function ENT:Think()
	for i = 1, 4 do
		self.Trails[i] = self:GetPos() + 4 * VectorRand():GetNormal()
	end
end

function ENT:OnRemove()
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
	local col = self:GetColor()
	colBeam.r = col.r
	colBeam.g = col.g
	colBeam.b = col.b
	colBeam.a = col.a
end

function ENT:EmitParticles()
	local dist = self:GetPos():Distance(EyePos())
	if dist < 400 then
		local pos = self:GetPos()
		local dir = self:GetForward()
		local vel = self:GetVelocity()
	
		local emitter = ParticleEmitter(pos)
		emitter:SetNearClip(16, 24)
		emitter:SetPos(pos)
		
		
		if self.NextEffect < CurTime() then
			self.NextEffect = CurTime() + 0.04
			local particle = emitter:Add("sprites/glow04_noz", pos)
				particle:SetDieTime(math.Rand(0.3, 0.5)) 
				particle:SetStartAlpha(150)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(4, 5))
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 359))
				particle:SetColor(0, 255, 255)
			
			local particle = emitter:Add("effects/spark", pos)
				particle:SetDieTime(math.Rand(0.4, 0.8))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)
				particle:SetStartSize(math.Rand(2, 4))
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-20, 20))
				particle:SetColor(0, 255, 255)
				particle:SetAirResistance(10)
		end
			
		emitter:Finish()
	end
end

function ENT:DrawGlow()
	local pos = self:GetPos()
	
	render.SetMaterial(matGlow)
	local siz = math.Rand(16, 24)
	render.DrawSprite(pos, siz, siz, Color(0, 255, 255))
end

function ENT:Draw()
	local vel = self:GetVelocity()
	self:SetupAngles(vel)

	self:DrawModel()

	self:DoColors()

	vel:Normalize()
	local start = self:GetPos()
	local endpos = start - vel * 200
	render.SetMaterial(matBeam)
	render.DrawBeam(start, endpos, 4, 1, 0, colBeam)
	render.DrawBeam(start, endpos, 2, 1, 0, colBeam)
	render.DrawBeam(start, endpos, 1, 1, 0, Color(255, 255, 200))
	
	for _, pos in pairs(self.Trails) do
		render.DrawBeam(start, pos, 4, 1, 0, colBeam)
	end

	self:DrawGlow()

	self:EmitParticles()
end
