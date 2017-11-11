SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Desert Eagle"
	SWEP.PrintName2 = "Heavy .44 Handgun"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.CSMuzzleFlashes = true
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "f"
	
	SWEP.PosY = 20
	
	SWEP.HUDPosY = 15
	
	SWEP.Ammo3DBone = "v_weapon.Deagle_Slide"
	SWEP.Ammo3DPos = Vector(-0.6, 0, -1)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.013
	
	SWEP.IronSightsPos = Vector(-2, -6, 2.1)
	SWEP.IronSightsAng = Angle(0, 0, 0)
	
	SWEP.SprintAngles = Angle(-10, 0, 0)
	SWEP.SprintVector = Vector(0, -2, 0)
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_deagle"
SWEP.AmmoItem = "ammobox_revolver"

SWEP.ShootSound = Sound("Weapon_Deagle.Single")
SWEP.ReloadSound = Sound("Weapon_Deagle.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.Primary.Ammo = "357"

SWEP.HoldType = "revolver"
SWEP.WeaponType = WEAPON_TYPE_GUN