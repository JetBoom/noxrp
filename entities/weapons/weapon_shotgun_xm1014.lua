SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "XM1014 Shotgun"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.CSMuzzleFlashes = true
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "B"
	
	SWEP.PosX = 0
	SWEP.PosY = 20
	
	SWEP.HUDPosX = -5
	SWEP.HUDPosY = 15
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = 0,Forward = 0,MU = 2,MR = 2,MF = -8,Scale = 0.8}
	
	SWEP.Ammo3DBone = "v_weapon.xm1014_Bolt"
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DPos = Vector(-0.52, 0, 0)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-7, -7, 2.65)
	SWEP.IronSightsAng = Angle(0.1, 0, -0.75)
end

SWEP.m_WeaponDeploySpeed = 0.3

SWEP.Slot = 5
SWEP.SlotPos = 0

SWEP.Item = "shotgun_xm1014"
SWEP.AmmoItem = "ammobox_buckshot"

SWEP.ShootSound = Sound("Weapon_XM1014.Single")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.HoldType = "shotgun"
SWEP.WeaponType = WEAPON_TYPE_GUN
SWEP.Skill = SKILL_SHOTGUNS

SWEP.Primary.Ammo = "buckshot"

SWEP.Primary.Damage = 7
SWEP.Primary.ClipSize = 6
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 0.4
SWEP.Cone = 0.05

SWEP.RoundPumpTime = 0.4

SWEP.ReloadTime = 3
SWEP.Reloading = false
SWEP.Anim_PumpTimes = 6

--SWEP.SkillCategory = SKILL_SHOTGUNS

function SWEP:OnFireBullet(fDamage, iBullets, fCone, tFilter)
end

function SWEP:Reload()
	self:GenericShotgunDoReload()
end

function SWEP:Think()
	self:GenericShotgunReloadThink()
end