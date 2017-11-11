AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ShouldDrawShadow = false

function ENT:PlayerSet(pPlayer, bExists)
	if self:GetDTFloat(0) == 0 then
		self:SetDie(2)
	end
	
	pPlayer:SetDSP(32)
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()
	
	if self:GetDTFloat(0) <= CurTime() then
		self:Remove()
	end

	self:NextThink(ct)
	return true
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	owner[self:GetClass()] = nil
	
	owner:SetDSP(0)
end

function ENT:SetIntensity(amt)
	self:SetDTFloat(1, amt)
end
