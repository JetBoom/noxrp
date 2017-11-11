AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

SWEP.BlockingStaminaTakeIdle = 1
SWEP.BlockingStaminaTakeIdleTime = 0.3

SWEP.BlockingStaminaPerDamage = 0.5

SWEP.NextStaminaTake = 0

SWEP.NextBlockTime = 0
SWEP.WeaponSkill = SKILL_BLADEWEAPONS

function SWEP:SetBlocking(bool)
	self:SetDTBool(2, bool)
end

function SWEP:Think()
	if self:GetHolstered() then return end
	if self.CanBlock and self:GetNextPrimaryFire() < CurTime() and self.NextBlockTime < CurTime() then
		if self.Owner:KeyDown(IN_RELOAD) and not self:GetBlocking() then
			self:StartBlocking()
		elseif not self.Owner:KeyDown(IN_RELOAD) and self:GetBlocking() then
			self:StopBlocking()
			self.NextBlockTime = CurTime() + 0.3
		end
		
		if self:GetBlocking() and self.NextStaminaTake < CurTime() then
			self.NextStaminaTake = CurTime() + self.BlockingStaminaTakeIdleTime
			
			if self.Owner:GetStamina() <= 0 then
				self:StopBlocking()
				self.NextBlockTime = CurTime() + 2
			end
		end
	end
end

function SWEP:StartBlocking()
	self:SetBlocking(true)
	self.Owner:EmitSound("npc/combine_soldier/gear1.wav")

	self.Owner:SetLuaAnimation("1h_Blocking")
end

function SWEP:StopBlocking()
	self:SetBlocking(false)
	self:SetNextPrimaryFire(CurTime() + 0.5)
			
	self.Owner:EmitSound("npc/combine_soldier/gear2.wav")
	
	self.Owner:StopLuaAnimation("1h_Blocking")
end

function SWEP:OnRemove()
	self.Owner:StopLuaAnimation("1h_Blocking")
end

function SWEP:CanBlockHit(attacker, damagetype, dmginfo, damage)
	if not dmginfo and not damage then return end
	
	local owner = self.Owner
	local dir = owner:GetForward()
	local oppdir = (attacker:GetPos() - owner:GetPos()):GetNormalized()
	
	local dot = dir:Dot(oppdir)
	
	local can = false
	
	if dot > 0.8 then
		if not damagetype and dmginfo then
			can = (not dmginfo:IsDamageType(DMG_BULLET))
		else
			can = (damagetype ~= DMG_BULLET)
		end
	end
	
	if can then
		if dmginfo then
			if owner:GetStamina() >= (self.BlockingStaminaPerDamage * dmginfo:GetDamage()) then
				return true
			else
				return false
			end
		else
			if owner:GetStamina() >= (self.BlockingStaminaPerDamage * damage) then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

function SWEP:OnHitWhileBlocked(attacker, inflictor, dmginfo)
	local owner = self.Owner
	if self:CanBlockHit(attacker, nil, dmginfo) then
		owner:AddStamina(self.BlockingStaminaPerDamage * -1 * dmginfo:GetDamage())
		owner:SendStamina()
			
		local dir = (attacker:GetPos() - owner:GetPos()):GetNormalized()
			
		attacker:SetVelocity(Vector(0, 0, 100) + dir * 50)
		owner:SetVelocity(Vector(0, 0, 100) - dir * 50)
		
		local pos
		
		if not dmginfo:GetDamagePosition() or dmginfo:GetDamagePosition() == Vector(0, 0, 0) then
			pos = owner:GetShootPos() + dir * 40
		else
			pos = dmginfo:GetDamagePosition()
		end
			
		local effect = EffectData()
			effect:SetOrigin(pos)
		util.Effect("meleeclash", effect, true, true)
		
		if inflictor:IsWeapon() then
			inflictor:SetNextPrimaryAttack(CurTime() + 0.5)
		end
		
		dmginfo:ScaleDamage(0.25)
	end
end

function SWEP:CallSkillCheck(ent)
	if math.random(self.Owner:GetSkillChance(self.WeaponSkill)) == 1 then
		self.Owner:AddSkill(self.WeaponSkill, 1)
	end
end