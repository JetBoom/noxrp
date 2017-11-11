AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(true)
	self.DieTime = CurTime() + 30
	self:SetModel("models/weapons/W_missile_closed.mdl")
	
	self.UpdateAngles = 0
	
	self:PhysicsInitSphere(5)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0.00001)
		phys:Wake()
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysData = data
	self:NextThink(CurTime())
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:FixAngles(angle)
	self:SetAngles(angle)
	self:GetPhysicsObject():SetVelocityInstantaneous(self:GetVelocity())
end

function ENT:Think()
	if self.DieTime < CurTime() then
		self:Remove()
	end
	
	if self:WaterLevel() > 0 then
		self:Explode()
	end
	
	if self.PhysData then
		local data = self.PhysData
		self.PhysData = nil
		
		self:Explode()
	end
end

function ENT:Explode()
	local effectdata = EffectData()
		effectdata:SetStart(self:GetPos())
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
			
	util.BlastDamage(self.Inflictor or self, self.Attacker or self, self:GetPos(), 250, 120)
	self:Remove()
end