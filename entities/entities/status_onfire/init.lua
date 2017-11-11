AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ShouldDrawShadow = false

function ENT:PlayerSet(pPlayer, bExists)
	self.NextBurn = 0
	
	if self:GetDTFloat(0) == 0 then
		self:SetDie(3)
	end
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()
	
	if self.NextBurn < ct then
		if owner:IsPlayer() then 
			owner:ViewPunch(Angle(math.Rand(-3, 3), math.Rand(-3, 3), 0))
		end
		
		self.NextBurn = ct + 0.5
		
		local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(1)
			dmginfo:SetDamageType(DMG_BURN)
			dmginfo:SetDamagePosition(self:GetPos())
		owner:TakeDamageInfo(dmginfo)
		
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 90)) do
			if (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) and not v:GetStatus("onfire") and v ~= owner then
				v:GiveStatus("onfire", self:GetDTFloat(0) - CurTime())
			end
		end
	end
	
	if self:WaterLevel() >= 2 then
		self:Remove()
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
end
