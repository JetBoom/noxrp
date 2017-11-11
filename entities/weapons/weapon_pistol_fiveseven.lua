SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'Five-Seven' Handgun"
	SWEP.PrintName2 = "Standard Combine Issue"
	
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelFOV = 55
--	SWEP.ViewModelFlip = true
--	SWEP.ViewModelFlip1 = false
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "u"
	
	SWEP.PosY = 15
	SWEP.HUDPosY = 20
	
	SWEP.Ammo3DBone = "v_weapon.FIVESEVEN_PARENT"
	SWEP.Ammo3DPos = Vector(-0.6, -3.1, -1)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.013
	
	SWEP.IronSightsPos = Vector(-5.94, -6, 2.9)
	SWEP.IronSightsAng = Angle(0, 0, 0)
	
	SWEP.SprintAngles = Angle(80, 0, 0)
	SWEP.SprintVector = Vector(0, 8, -25)
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = 0,Forward = 90,MU = -4,MR = -5,MF = 5,Scale = 1}
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_fiveseven"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = Sound("Weapon_FiveSeven.Single")

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN

--SWEP.SkillCategory = SKILL_PISTOLS