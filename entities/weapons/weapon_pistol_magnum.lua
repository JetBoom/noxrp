SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = ".357 Revolver"
	SWEP.PrintName2 = "Magnum Handgun"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "e"
	
	SWEP.BoneDeltaAngles = {Up = 0, Right = 0, Forward = 90, MU = -4, MR = -2, MF = 2, Scale = 1}
	
	SWEP.Ammo3DBone = "Python"
	SWEP.Ammo3DPos = Vector(0.1, -0.5, -2)
	SWEP.Ammo3DAng = Angle(210, 0, 0)
	SWEP.Ammo3DScale = 0.013
	
	SWEP.IronSightsPos = Vector(-3, -2, 0.65)
	SWEP.IronSightsAng = Angle(0, 0, -0.2)
	
	SWEP.SprintAngles = Angle(60, 0, 0)
	SWEP.SprintVector = Vector(0, 4, -18)
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_revolver"
SWEP.AmmoItem = "ammobox_revolver"

SWEP.ShootSound = Sound("Weapon_357.Single")
SWEP.ReloadSound = Sound("Weapon_357.Reload")

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Primary.Ammo = "357"

SWEP.HoldType = "revolver"
SWEP.WeaponType = WEAPON_TYPE_GUN

SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.4
SWEP.Primary.ClipSize = 6
--SWEP.Cone = 0.15
SWEP.Cone = 0.01

--SWEP.SkillCategory = SKILL_PISTOLS