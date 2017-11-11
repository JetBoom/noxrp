SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Military Issue M4A1"
	SWEP.PrintName2 = "7.62 Assault Rifle"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.CSMuzzleFlashes = true

	SWEP.Font = "csKillIcons"
	SWEP.Icon = "w"

	SWEP.PosX = 0
	SWEP.HUDPosY = 15

	SWEP.BoneDeltaAngles = {Up = 0, Right = -90,Forward = 0,MU = -6,MR = 4,MF = -3,Scale = 0.9}

	SWEP.Ammo3DBone = "v_weapon.m4_Parent"
	SWEP.Ammo3DPos = Vector(0.9, -6.7, 0.4)
	SWEP.Ammo3DAng = Angle(0, -5, 0)
	SWEP.Ammo3DScale = 0.01

	SWEP.IronSightsPos = Vector(-3, 0, 1)
	SWEP.IronSightsAng = Angle(2, 0, 0)
end

SWEP.Slot = 6
SWEP.SlotPos = 0

SWEP.Item = "rifle_m4a1"
SWEP.AmmoItem = "ammobox_smg"

SWEP.ShootSound = Sound("Weapon_M4A1.Single")
SWEP.ShootSound_Silenced = Sound("Weapon_M4A1.Silenced")
SWEP.ReloadSound = Sound("Weapon_M4A1.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.HoldType = "smg"
SWEP.WeaponType = WEAPON_TYPE_GUN
SWEP.Skill = SKILL_RIFLES

SWEP.Primary.Damage = 14
SWEP.Primary.ClipSize = 24
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12
SWEP.Cone = 0.012

--SWEP.SkillCategory = SKILL_ASSAULTRIFLES

--SWEP.CanUseIronSights = false

function SWEP:GetSilenced()
	return self:GetDTBool(3)
end

function SWEP:SetSilenced(bool)
	self:SetDTBool(3, bool)
end

function SWEP:PlayFireSound()
	if self:GetSilenced() then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
		self:EmitSound(self.ShootSound_Silenced)
	else
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:EmitSound(self.ShootSound)
	end
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_WALK) then
		if self:CanSecondaryAttack() and self.Owner:HasItem("silencer") then
			local bool = self:GetSilenced()
			if SERVER then self:SetSilenced(not bool) end
			self:SetNextSecondaryAttack(CurTime() + 2)
			self:SetNextPrimaryAttack(CurTime() + 2)
			if not bool then
				self:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
				self:CallOnClient("UpdateAnglesSilenced")
			else
				self:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
				self:CallOnClient("UpdateAnglesUnSilenced")
			end
		end
	elseif not self:IsReloading() and not self.Owner:IsSprinting() and not self:GetHolstered() and self.CanUseIronSights and not self.Owner:IsKnockedDown() and self:GetNextPrimaryFire() < CurTime() then
		self:ToggleIronSights()
	end
end

function SWEP:CanSecondaryAttack()
	return self:GetNextSecondaryFire() < CurTime() and self:GetReloadEnd() < CurTime()
end

if CLIENT then
	function SWEP:UpdateAnglesSilenced()
		self.IronSightsPos = Vector(-3, 0, 2)
	end

	function SWEP:UpdateAnglesUnSilenced()
		self.IronSightsPos = Vector(-3, 0, 2)
	end
end