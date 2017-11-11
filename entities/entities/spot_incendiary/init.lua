AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_c4_planted.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self:DrawShadow(false)

	self.Death = CurTime() + 10
end

function ENT:Think()
	local pos = self:GetPos()
	
	for _, ent in pairs(ents.FindInSphere(self:GetPos(), 40)) do
		if (ent:IsPlayer() or ent:IsNextBot()) then
			ent:GiveStatus("onfire", 3)
		else
			ent:Ignite(3)
		end
	end
	
	if CurTime() >= self.Death then
		self:Remove()
	end
	
	self:NextThink(CurTime() + 0.1)
	return true
end


function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
