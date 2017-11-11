SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "AK47"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "b"
	SWEP.HUDPosY = 15
	
	SWEP.BoneDeltaAngles = {Up = 0, Right = -90, Forward = 0, MU = 4, MR = 4, MF = -3, Scale = 0.9}
	
	SWEP.Ammo3DBone = "v_weapon.AK47_Parent"
	SWEP.Ammo3DPos = Vector(-0.7, -6, -1)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-3, -10, 1.65)
	SWEP.IronSightsAng = Angle(3, 0, 0)
end

SWEP.Slot = 6
SWEP.SlotPos = 0

SWEP.Item = "rifle_ak47"
SWEP.AmmoItem = "ammobox_smg"

SWEP.ShootSound = Sound("Weapon_AK47.Single")
SWEP.ReloadSound = Sound("Weapon_AK47.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.HoldType = "ar2"
SWEP.WeaponType = WEAPON_TYPE_GUN