SWEP.Base = "weapon_throwable_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Smoke Grenade"
	SWEP.PrintName2 = "Throwable Detonation Device"
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "P"
	
	SWEP.HUDPosX = -20
	SWEP.HUDPosY = 10
end

SWEP.Projectile = "projectile_smokegrenade"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Item = "smokegrenade"

SWEP.ThrowDelay = 1