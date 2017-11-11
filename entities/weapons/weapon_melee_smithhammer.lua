if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Smithing Hammer"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	
	SWEP.Icon = "c"
	SWEP.Font = "HL2Icons"

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10, -8) }
	}
	
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_docks/channelmarker_gib01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, -6.753), angle = Angle(180, 0, 0), size = Vector(0.15, 0.15, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_c17/SuitCase001a.mdl", bone = "ValveBiped.Bip01", rel = "base", pos = Vector(0, 0, 7.791), angle = Angle(0, 10, 0), size = Vector(0.4, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/GutterMetal01a", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_docks/channelmarker_gib01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.5, -4.676), angle = Angle(0, 0, 0), size = Vector(0.15, 0.15, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_c17/SuitCase001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, -8), angle = Angle(0, 90, 0), size = Vector(0.4, 0.25, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_pipes/GutterMetal01a", skin = 0, bodygroup = {} }
	}
	
	--models/nayrbarr/Hammer/hammer.mdl
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_melee_base"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 0.6
SWEP.Range = 45

SWEP.HoldType = "melee"
SWEP.Skill = SKILL_BLUNTWEAPONS
SWEP.DamageType = DMG_CLUB

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.Item = "smithhammer"