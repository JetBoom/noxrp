AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	self.NextBleed = 0
	
	if self.DieTime == 0 then
		self:SetDie(10)
	end
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()

	if self.NextBleed < ct then
		if owner:IsPlayer() then 
			owner:ViewPunch( Angle(math.Rand(-3, 3), math.Rand(-3, 3), 0) )
		end
		
		self.NextBleed = ct + 2
		owner:TakeDamage(2)
	end

	if self.DieTime <= CurTime() then
		self:Remove()
	end
	
	self:NextThink(ct)
	return true
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	owner[self:GetClass()] = nil
end
