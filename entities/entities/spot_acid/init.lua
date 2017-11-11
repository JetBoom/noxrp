AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_c4_planted.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self:DrawShadow(false)

	self.Death = CurTime() + 5
	self.NextHurt = 0
end

function ENT:Think()
	local pos = self:GetPos()
	local mins = self:GetRight() * -10 + self:GetForward() * -100 + self:GetUp() * -10
	local maxs = mins * -1
	
	for _, ent in pairs(ents.FindInBox(pos + mins, pos + maxs)) do
		if (ent:IsPlayer() or ent.IsNextBot) then
			ent:TakeDamage(1, self:GetOwner())
		end
	end
	
	if self.NextHurt < CurTime() then
		self.NextHurt = CurTime() + 0.2
	end
	
	if CurTime() >= self.Death then
		self:Remove()
	end
	
	self:NextThink(CurTime() + 0.25)
	return true
end


function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
