if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Explosive Grenade"
	SWEP.PrintName2 = "Throwable Detonation Device"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "h"
	
	SWEP.HUDPosX = -5
	SWEP.HUDPosY = 10
end

SWEP.Base = "weapon_throwable_base"
SWEP.Projectile = "projectile_grenade"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Item = "explosivegrenade"

SWEP.ThrowDelay = 1