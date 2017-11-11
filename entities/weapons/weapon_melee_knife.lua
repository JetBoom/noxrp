SWEP.Base = "weapon_melee_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Knife"
	SWEP.PrintName2 = "Light Melee"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.Icon = "j"
	SWEP.Font = "csKillIcons"
	
	SWEP.PosX = 0
	SWEP.PosY = 20
	
	SWEP.QSelectY = 10
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 15
SWEP.Primary.Delay = 0.6
SWEP.Range = 52

SWEP.HoldType = "knife"
SWEP.DamageType = DMG_SLASH
SWEP.WeaponSkill = SKILL_MELEEWEAPONS

SWEP.Item = "knife"
SWEP.WeaponType = WEAPON_TYPE_MELEE

SWEP.HitAnim = ACT_VM_PRIMARYATTACK

if SERVER then
	function SWEP:OnHitEntity(trace, damage)
		local ent = trace.Entity
		ent:TakeSpecialDamage(damage, self.Owner, self, self.DamageType, trace.HitPos)
		
		local skill = self.Owner:GetSkill(SKILL_BLADEWEAPONS)
		
		if skill >= 100 then
			if math.random(math.max((1000 - skill) * 0.01, 1)) == 1 then
				if ent.CanBleed or ent:IsPlayer() then
					ent:GiveStatus("bleeding")
				end
			end
		end
		
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(trace.Normal * 5)
		end
		
		if ent:IsPlayer() or ent.CanRaiseSkill then
			self:CallSkillCheck(ent)
		end
	end
end