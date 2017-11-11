SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Specialized Electric Handgun"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "d"
	
	SWEP.MainPos = Vector(0, 0, -9)
	SWEP.MainBone = "ValveBiped.square"
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 1.5, 2), angle = Angle(0, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.square", rel = "base", pos = Vector(0, -1.5, 3.7), angle = Angle(0, 0, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8, 1, -2.5), angle = Angle(0, 90, 96), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.square", rel = "base", pos = Vector(-1.6, 1.2, 2), angle = Angle(0, 0, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-1, 0, 0), angle = Angle(0, 180, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.Ammo3DBone = "ValveBiped.square"
	SWEP.Ammo3DPos = Vector(0.8, -0.2, 0)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-6.07, -9, 3.2)
	SWEP.IronSightsAng = Angle(0.1, 1, -1.5)
	
	SWEP.SprintAngles = Angle(70, 0, 0)
	SWEP.SprintVector = Vector(0, 4, -26)
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_9mm"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = "weapons/airboat/airboat_gun_energy1.wav"
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN

SWEP.DamageType = DMG_SHOCK
SWEP.BaseBulletClass = "projectile_electroshot"

--SWEP.SkillCategory = SKILL_PISTOLS

