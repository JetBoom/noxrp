if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Wood Axe"
	SWEP.PrintName2 = "Light Melee"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.Icon = "c"
	SWEP.Font = "HL2Icons"

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -5.715), angle = Angle(0, -19.871, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, -7.792), angle = Angle(0, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_melee_base"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 15
SWEP.Primary.Delay = 0.85
SWEP.Range = 55

SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_SLASH

SWEP.HitDecal = "Manhackcut"

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.Item = "woodaxe"

if SERVER then
	function SWEP:OnHitEntity(trace)
		local ent = trace.Entity
		if ent:GetClass() == "ent_tree" then
			ent:Cut(self.Owner, trace, 1.3)
		else
			ent:TakeDamage(self.Primary.Damage,self.Owner,self)
			if ent:GetClass() == "func_breakable_surf" then
				ent:Fire("break","",0)
			end
		end
	end
end