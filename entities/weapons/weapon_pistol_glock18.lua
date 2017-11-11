SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Glock 18"
	
	SWEP.CSMuzzleFlashes = true

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "c"
	
	SWEP.PosY = 15
	SWEP.CPosY = 25
	
	SWEP.Ammo3DBone = "v_weapon.Glock_Slide"
	SWEP.Ammo3DPos = Vector(-0.5, 0, -0.7)
	SWEP.Ammo3DAng = Angle(100, -90, 90)
	SWEP.Ammo3DScale = 0.012
	
--	SWEP.Ammo3DBone = "Glock_Slide"
--	SWEP.Ammo3DPos = Vector(-0.45, 0, 0.2)
--	SWEP.Ammo3DAng = Angle(0, 0, 90)
--	SWEP.Ammo3DScale = 0.01
	
	SWEP.SprintAngles = Angle(-10, 0, 0)
	SWEP.SprintVector = Vector(0, 0, 0)
	
	SWEP.IronSightsPos = Vector(-3, -4, 2.5)
	SWEP.IronSightsAng = Angle(0, 0, 0)
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_glock18"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = "Weapons/glock18/glock18-1.wav"

SWEP.ReloadSound = Sound("Weapon_Glock.Reload")
SWEP.DrawSound = {
	{"Weapons/glock18/slideback.wav", 0.2},
	{"Weapons/glock18/sliderelease.wav", 0.6}
}

--SWEP.ReloadSounds = {
--	{"Weapons/glock18/slideback.wav", 0},
--	{"Weapons/glock18/magout.wav", 0.1},
--	{"Weapons/glock18/magin.wav", 1.5},
--	{"Weapons/glock18/sliderelease.wav", 1.8}
--}
Sound("Weapon_Glock.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
--SWEP.ViewModel = "models/weapons/v_cstm_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_cstm_glock18.mdl"

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = true

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN