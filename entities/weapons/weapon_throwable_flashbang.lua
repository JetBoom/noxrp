SWEP.Base = "weapon_throwable_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Flashbang"
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "P"
	
	SWEP.HUDPosX = -20
	SWEP.HUDPosY = 10
end

SWEP.Projectile = "projectile_flashbang"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"

SWEP.Item = "flashbang"

SWEP.ThrowDelay = 1