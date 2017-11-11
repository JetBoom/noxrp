AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ShouldDrawShadow = false

function ENT:PlayerSet(pPlayer, bExists)
	self.NextCough = 0
	
	if self:GetDie() == 0 then
		self:SetDie(5)
	end
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()
	
	if self.NextCough < ct then
		if owner:IsPlayer() then 
			owner:ViewPunch(Angle(math.Rand(1, 5), math.Rand(-1, 1), 0))
		end
		
		self.NextCough = ct + 2
		owner:EmitSound("ambient/voices/cough1.wav", 100, math.random(90, 110))
	end
	
	if self:GetDie() <= CurTime() then
		self:Remove()
	end

	self:NextThink(ct)
	return true
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	owner[self:GetClass()] = nil
end
