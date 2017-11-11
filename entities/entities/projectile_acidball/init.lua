AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:DrawShadow(false)
	self:PhysicsInitSphere(6)
	self:SetModelScale(0.4, 0)
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:Wake()
	end
	
	self.LifeTime = CurTime() + 1
	
	self:SetMaterial("models/flesh")
	self:SetColor(Color(0, 255, 0))
	
	self.IgnoreEnts = {}
end

function ENT:Launch(dir, speed)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetVelocityInstantaneous(dir * speed)
	end
end

function ENT:Explode()
	for _, ent in pairs(ents.FindInSphere(self:GetPos(), 60)) do	
		table.insert(self.IgnoreEnts, ent)
		ent:TakeDamage(9)
	end
	
	table.insert(self.IgnoreEnts, self)
	local tr = util.TraceLine({start = self:GetPos(), endpos = self:GetPos() - Vector(0, 0, 100), filter = self.IgnoreEnts})
	
	if tr.HitWorld then
		local pool = ents.Create("spot_acid")
		if pool:IsValid() then
			pool:SetPos(tr.HitPos)
			pool:Spawn()
		end
	end
	
	self:Remove()
end

function ENT:Touch(ent)
	table.insert(self.IgnoreEnts, ent)
	self:Explode()
end

function ENT:Think()
	if self.LifeTime < CurTime() then
		self:Explode()
	end
end

function ENT:PhysicsCollide(data, physobj)
	self:Remove()
end

function ENT:OnRemove()
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
	util.Effect("gib", effect)
	
	self:EmitSound("physics/body/body_medium_break2.wav")
end
