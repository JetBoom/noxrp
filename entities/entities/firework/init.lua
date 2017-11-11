AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_NONE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:Wake()
		phys:SetVelocityInstantaneous(Vector(math.Rand(-1,1)*400,math.Rand(-1,1)*400,1000))
	end

	self.Death = CurTime() + math.Rand(2,3)
end

function ENT:Think()
	if CurTime() >= self.Death then
		local pos = self:GetPos()
		local effect = EffectData()
			effect:SetOrigin(pos)
		util.Effect("firework_explode", effect)

		self:Remove()
	end
end

function ENT:KeyValue(key, value)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
