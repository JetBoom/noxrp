SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Combine Issue SMG"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "a"
	
	SWEP.BoneDeltaAngles = {Up = 0, Right = -90, Forward = 180, MU = 0, MR = 3, MF = -2, Scale = 1}
	
	SWEP.Ammo3DBone = "ValveBiped.base"
	SWEP.Ammo3DPos = Vector(0.9, -0.6, -2)
	SWEP.Ammo3DScale = 0.012
	SWEP.Ammo3DAng = Angle(190, 0, 0)
	
	SWEP.IronSightsPos = Vector(-3, -6, 2)
	SWEP.IronSightsAng = Angle(0, 0, 0)
end

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Item = "smg_9mm"
SWEP.AmmoItem = "ammobox_smg"

SWEP.ShootSound = Sound("Weapon_SMG1.Single")
SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Primary.Ammo = "smg1"

SWEP.HoldType = "smg"
SWEP.WeaponType = WEAPON_TYPE_GUN

SWEP.Primary.Automatic = true

--SWEP.SkillCategory = SKILL_SMGS