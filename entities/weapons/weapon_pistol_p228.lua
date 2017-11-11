SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "SIG P228"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "d"
	
	SWEP.PosY = 0
	SWEP.CPosY = 25
	
	SWEP.Ammo3DBone = "v_weapon.p228_Slide"
	SWEP.Ammo3DPos = Vector(-0.2, -0.3, 0)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-5.91, -4, 2.93)
	SWEP.IronSightsAng = Angle(-0.4, 0, 0.4)
	
	SWEP.SprintAngles = Angle(-20, 0, 0)
	SWEP.SprintVector = Vector(0, 4, 4)
	
	SWEP.Testing = true
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_p228"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = Sound("Weapon_Pistol.Single")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN