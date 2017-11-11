include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(true)
	self.Created = CurTime()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 32)
	
	local vOffset = self:GetPos()
	
	for i = 1, math.random(4, 6) do
		local vec = VectorRand()
		local particle = self.Emitter:Add("effects/fire_cloud"..math.random(1, 2), vOffset)
			particle:SetDieTime(1)
			particle:SetStartAlpha(180)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(12, 14))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(260, 360))
			particle:SetAirResistance(100)
			particle:SetVelocity(vec * 100)
			particle:SetGravity(vec * -200)
			particle:SetCollide(true)
	end
	
	self.Damage = 0
	self.FireWalls = 0
	self.NextFireWall = 0
end

function ENT:Draw()
	local vOffset = self:GetPos()
	local emitter = self.Emitter
	local dir = self:GetVelocity():GetNormalized()
	
	emitter:SetPos(vOffset)
	
	if self.Damage ~= 0 then
		if self.FireWalls < math.floor(self.Damage / 5) then
			if self.NextFireWall < CurTime() then
				self.FireWalls = self.FireWalls + 1
				self.NextFireWall = CurTime() + 0.1
				
				for i = 1, 4 do
					local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), vOffset + self:GetForward() * i * 10)
						particle:SetDieTime(2)
						particle:SetStartAlpha(220)
						particle:SetEndAlpha(0)
						particle:SetStartSize(math.Rand(6, 8))
						particle:SetEndSize(2)
						particle:SetRoll(math.Rand(0, 360))
						particle:SetRollDelta(math.Rand(-1, 1))
						particle:SetGravity(Vector(0, 0, -500))
				end
			end
		end
	end
	
	for i = 1, 2 do
		local particle = emitter:Add("effects/fire_embers"..math.random(1,3), vOffset)
			particle:SetDieTime(0.3)
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(6, 8))
			particle:SetEndSize(2)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
	end
	
	for i = 1, math.random(2, 3) do
		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), vOffset + self:GetRight() * math.cos(CurTime() * 10) * 5 + self:GetUp() * math.sin(CurTime() * 10) * 5)
			particle:SetDieTime(0.3)
			particle:SetStartAlpha(180)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(2, 4))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(260, 360))
			particle:SetColor(255,255,255)
			particle:SetAirResistance(100)
			particle:SetVelocity(dir * -1 + VectorRand() * 10)
			particle:SetCollide(true)
	end
	
	for i = 1, math.random(2, 3) do
		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), vOffset - self:GetRight() * math.cos(CurTime() * 10) * 5 - self:GetUp() * math.sin(CurTime() * 10) * 5)
			particle:SetDieTime(0.3)
			particle:SetStartAlpha(180)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(2, 4))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(260, 360))
			particle:SetColor(255,255,255)
			particle:SetAirResistance(100)
			particle:SetVelocity(dir * -1 + VectorRand() * 10)
			particle:SetCollide(true)
	end
end

function ENT:Think()
	if self.Damage ~= self:GetDamage() and self:GetDamage() ~= 0 then
		self.Damage = self:GetDamage()
	end
	
	local dl = GetConVar("noxrp_enabledlight"):GetBool()
	
	if not dl then return end
	local dlight = DynamicLight(self:EntIndex())
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = 255
		dlight.g = 100
		dlight.b = 0
		dlight.Brightness = 1
		dlight.Decay = 128
		dlight.Size = 200
		dlight.DieTime = CurTime() + 1
	end
end

function ENT:OnRemove()
end
