SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "9mm Pistol"
	SWEP.PrintName2 = "Standard Combine Issue"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "d"
	
	SWEP.PosY = 0
	//SWEP.CPosY = 25
	
	SWEP.Ammo3DBone = "ValveBiped.square"
	SWEP.Ammo3DPos = Vector(0.8, 0, -3)
	SWEP.Ammo3DAng = Angle(180, 0, 0)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-3, 0, 4)
	SWEP.IronSightsAng = Angle(0, 0, 0)
	
	SWEP.SprintAngles = Angle(-10, 0, 0)
	SWEP.SprintVector = Vector(0, 0, 0)
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_9mm"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = Sound("Weapon_Pistol.Single")
--SWEP.ShootSound = "Weapons/beretta92fs/fire.wav"
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN