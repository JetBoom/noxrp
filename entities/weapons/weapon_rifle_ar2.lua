SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Combine Issue AR2"
	SWEP.PrintName2 = "9mm Assault Rifle"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "l"
	
	SWEP.BoneDeltaAngles = {Up = 0, Right = -90, Forward = 0, MU = 4, MR = 4, MF = -3, Scale = 0.9}
	
	SWEP.Ammo3DBone = "Vent"
	SWEP.Ammo3DPos = Vector(0.05, 1.3, -12)
	SWEP.Ammo3DScale = 0.015
end

SWEP.Slot = 6
SWEP.SlotPos = 0

SWEP.Item = "rifle_ar2"
SWEP.AmmoItem = "ammobox_smg"

SWEP.ShootSound = Sound("Weapon_AR2.Single")
SWEP.ReloadSound = Sound("Weapon_AR2.Reload")

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.HoldType = "ar2"
SWEP.Skill = SKILL_RIFLES
SWEP.WeaponType = WEAPON_TYPE_GUN

SWEP.CanUseIronSights = false