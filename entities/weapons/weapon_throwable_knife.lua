if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Throwing Knife"
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "k"
	
	SWEP.PosX = 0
	SWEP.PosY = 0
	
	SWEP.ShowViewModel = false
	
--[[	SWEP.ViewModelBoneMods = {
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -3), angle = Angle(0, 0, -30) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}]]
	
--[[	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -10) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 30, -30) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -20, 10) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -40, 10) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -50, 30) },
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -20, 10) },
	}]]
	
	
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/weapons/w_knife_t.mdl", bone = "v_weapon.Flashbang_Parent", rel = "", pos = Vector(0.6, 5.5, 0), angle = Angle(0, 0, -90), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_throwable_base"
SWEP.Projectile = "projectile_throwingknife"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.ThrowAngle = Angle(0, 90, 90)

SWEP.Item = "throwingknife"
SWEP.CanDrop = false

function SWEP:OnThrownProjectile(ent, pow)
--[[	local dir = self:GetOwner():GetAimVector():Angle()
	
	ent:SetAngles(dir)
	
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocityInstantaneous(self:GetForward() * 1200)
	end
	
	print(ent:GetVelocity())]]
end