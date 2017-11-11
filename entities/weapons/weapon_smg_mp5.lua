SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'MP5' SMG"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.CSMuzzleFlashes = true
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "x"
	
	SWEP.PosX = 0
	SWEP.PosY = 20
	
	SWEP.HUDPosX = -5
	SWEP.HUDPosY = 15
	
	SWEP.QSelectY = 10
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = -90,Forward = 180,MU = 0,MR = 3,MF = -4,Scale = 1}
	
	SWEP.Ammo3DBone = "v_weapon.MP5_Parent"
	SWEP.Ammo3DPos = Vector(-0.78, -4.3, -9)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-2, -6, 2.5)
	SWEP.IronSightsAng = Angle(0, 0, 0)
end

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Item = "smg_mp5"
SWEP.AmmoItem = "ammobox_smg"

SWEP.ShootSound = Sound("Weapon_MP5Navy.Single")
SWEP.ReloadSound = Sound("Weapon_MP5Navy.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.HoldType = "smg"
SWEP.WeaponType = WEAPON_TYPE_GUN