AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:DrawShadow(false)
	self:PhysicsInitSphere(8)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(true)
		phys:Wake()
	end
	
	self:SetMaterial("models/flesh")
end

function ENT:SetDestination(pos)
	local vOff = self:GetPos()
	
	local speed = Vector(0, 0, 0)
		speed.x = (pos.x - vOff.x) / self.TimeToArrive
		speed.y = (pos.y - vOff.y) / self.TimeToArrive
		speed.z = (pos.z - vOff.z) + 600 * self.TimeToArrive
		
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetVelocityInstantaneous(speed)
	end
end

function ENT:Touch(ent)
	local mypos = self:GetPos()
	if ent:IsValid() and self:GetOwner() ~= ent then
		ent:TakeDamage(5)
		if ent:IsPlayer() and ent:Alive() then
			ent:KnockDown(2)
		end
		
		self:Remove()
	end
end

function ENT:Think()
end

function ENT:PhysicsCollide(data, physobj)
	self:DoFleshSpawn()
end

function ENT:DoFleshSpawn()
	local mini = ents.Create("npc_nox_fleshreaver")
	if mini then
		mini:SetPos(self:GetPos())
		mini:Spawn()
		mini:SetTarget(self.Target)
	end
	
	self:Remove()
end

function ENT:OnRemove()
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
	util.Effect("gib", effect)
	
	self:EmitSound("physics/body/body_medium_break2.wav")
end
