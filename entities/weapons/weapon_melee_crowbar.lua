if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Crowbar"
	SWEP.PrintName2 = "Light Melee"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.Icon = "c"
	SWEP.Font = "HL2Icons"
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_melee_base"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 15
SWEP.Range = 50

SWEP.HoldType = "melee"
SWEP.WeaponSkill = SKILL_BLUNTWEAPONS
SWEP.DamageType = DMG_CLUB

SWEP.Item = "crowbar"
SWEP.WeaponType = WEAPON_TYPE_MELEE

if SERVER then
	function SWEP:OnHitEntity(trace, damage)
		local ent = trace.Entity
		if ent:GetClass() == "ent_tree" then
			ent:Cut(self.Owner, trace)
		elseif ent:GetClass() == "ent_mine" then
			ent:Mine(self.Owner, trace)
		else
			if ent:GetClass() == "func_breakable_surf" then
				ent:Fire("break","",0)
			end
		end
		
		ent:TakeSpecialDamage(damage, self.Owner, self, self.DamageType, trace.HitPos)
			
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(trace.Normal * 2)
		end
		
		if ent:IsPlayer() or ent.CanRaiseSkill then
			self:CallSkillCheck(ent)
		end
	end
end