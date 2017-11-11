if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Stunbaton"
	SWEP.PrintName2 = "Light Melee"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.Icon = "c"
	SWEP.Font = "HL2Icons"
	
	SWEP.ViewModelBoneMods = {
		["Dummy14"] = { scale = Vector(1, 1, 1.957), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}


	//VIEWMODEL CODE


	SWEP.VElements = {
		["lrodclawattach"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_02.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(0.518, -6.753, 47.272), angle = Angle(-43.248, 52.597, -106.364), size = Vector(0.367, 0.3, 0.5), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodclawattach+"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_02.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(1.557, 2.596, 47.272), angle = Angle(-45.584, -54.936, 52.597), size = Vector(0.367, 0.3, 0.5), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrod1"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(4.675, -1, 25.454), angle = Angle(0, 90, 0), size = Vector(1.21, 1.21, 1.21), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodball"] = { type = "Model", model = "models/effects/combineball.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(2.596, -1, 34.805), angle = Angle(0, 0, 0), size = Vector(0.5, 0.3, 0.3), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrod2"] = { type = "Model", model = "models/Items/battery.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(4, -0.801, 16), angle = Angle(0, 180, 0), size = Vector(0.885, 0.885, 0.885), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodclaw+"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(3.635, 3.635, 42.077), angle = Angle(-50.26, 87.662, -33.896), size = Vector(0.367, 0.367, 0.367), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodclaw"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "Bip01 R Hand", rel = "", pos = Vector(3.635, -6.753, 43.117), angle = Angle(-29.222, -68.961, -33.896), size = Vector(0.367, 0.367, 0.367), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}


	// WORLD MODEL



	SWEP.WElements = {
		["lrodclawattach"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.5, 1.35, -20.261), angle = Angle(59.61, 113.376, 61.948), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodclaw+"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 5, -18), angle = Angle(162.468, -139.092, 101.688), size = Vector(0.25, 0.237, 0.25), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrod1"] = { type = "Model", model = "models/items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.714, 2.596, -11.948), angle = Angle(15.194, -5.844, 174.156), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodball"] = { type = "Model", model = "models/effects/combineball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.5, 3, -16.105), angle = Angle(0, 0, 0), size = Vector(0.172, 0.172, 0.172), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodclawattach+"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "lrodclaw+", pos = Vector(-2.5, -1.201, -0.5), angle = Angle(22.208, -57.273, 29.221), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrod2"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 3, -12.988), angle = Angle(-22.209, -178.831, 5.843), size = Vector(0.432, 0.432, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lrodclaw"] = { type = "Model", model = "models/Gibs/helicopter_brokenpiece_03.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.869, 1.557, -18), angle = Angle(162.468, 24.545, 167.143), size = Vector(0.25, 0.237, 0.25), color = Color(255, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_melee_base"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 8
SWEP.Range = 50

SWEP.HoldType = "melee"
SWEP.SkillCategory = SKILL_BLUNTWEAPONS
SWEP.DamageType = DMG_CRUSH

SWEP.Item = "stunbaton"
SWEP.WeaponType = WEAPON_TYPE_MELEE

if SERVER then
	function SWEP:OnHitEntity(trace)
		local ent = trace.Entity

		ent:TakeDamage(self.Primary.Damage,self.Owner,self)
	end
end