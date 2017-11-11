SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'UMP' SMG"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.CSMuzzleFlashes = true
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "q"
	
	SWEP.PosX = 0
	SWEP.PosY = 20
	
	SWEP.HUDPosX = -5
	SWEP.HUDPosY = 15
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = -90,Forward = 180,MU = 0,MR = 3,MF = -4,Scale = 1}
	
	SWEP.Ammo3DBone = "v_weapon.ump45_Release"
	SWEP.Ammo3DPos = Vector(-0.7, -3.5, 1.2)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.017
	
	SWEP.IronSightsPos = Vector(-8.8, -11, 4.3)
	SWEP.IronSightsAng = Angle(-1, 0, -0.3)
end

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Item = "smg_ump"
SWEP.AmmoItem = "ammobox_smg"

SWEP.ShootSound = Sound("Weapon_UMP45.Single")
SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.HoldType = "smg"
SWEP.WeaponType = WEAPON_TYPE_GUN