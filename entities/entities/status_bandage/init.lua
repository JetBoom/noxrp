AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	self.NextHeal = 0
	
	if self:GetDTFloat(0) == 0 then
		self:SetDie(10)
	end
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()
	
	if self.NextHeal < CurTime() then
		owner:SetHealth(math.min(owner:Health() + 1, owner:GetMaxHealth()))
		
		self.NextHeal = CurTime() + 0.8
	end
	
	if self:GetDTFloat(0) <= CurTime() then
		self:Remove()
	end

	self:NextThink(ct)
	return true
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	owner[self:GetClass()] = nil
	
	local bleed = owner:GetStatus("bleeding")
	if bleed then
		bleed:Remove()
	end
end
