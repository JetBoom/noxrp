SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "M3 Super 90"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.CSMuzzleFlashes = true
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "k"
	
	SWEP.PosX = 0
	SWEP.PosY = 20
	
	SWEP.HUDPosX = -5
	SWEP.HUDPosY = 15
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = 0,Forward = 0,MU = 2,MR = 2,MF = -8,Scale = 0.8}
	
	SWEP.Ammo3DBone = "v_weapon.M3_CHAMBER"
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DPos = Vector(0.1, -0.6, 1)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-7, -7, 2.65)
	SWEP.IronSightsAng = Angle(0.1, 0, -0.75)
end

SWEP.m_WeaponDeploySpeed = 0.5

SWEP.Slot = 5
SWEP.SlotPos = 0

SWEP.Item = "shotgun_m3super"
SWEP.AmmoItem = "ammobox_buckshot"

SWEP.ShootSound = Sound("Weapon_M3.Single")
SWEP.ReloadSound = Sound("Weapon_M3.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.HoldType = "shotgun"
SWEP.WeaponType = WEAPON_TYPE_GUN
SWEP.Skill = SKILL_SHOTGUNS

SWEP.Primary.Ammo = "buckshot"

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