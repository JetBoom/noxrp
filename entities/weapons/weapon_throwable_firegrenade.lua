SWEP.Base = "weapon_throwable_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Incendiary Grenade"
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
end

SWEP.Projectile = "projectile_incendiarymirvgrenade"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Item = "firegrenade"

SWEP.ThrowDelay = 1