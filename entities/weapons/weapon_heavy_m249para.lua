SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'Para' LMG"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "z"
	SWEP.PosX = 0
	SWEP.PosY = 10
	
	SWEP.HUDPosY = 10
	
	SWEP.QSelectY = 10
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = 0,Forward = 0,MU = 2,MR = 2,MF = -8,Scale = 0.8}
	
	SWEP.Ammo3DBone = "v_weapon.m249"
	SWEP.Ammo3DPos = Vector(0.9, -1, 4)
	SWEP.Ammo3DAng = Angle(180, 0, 0)
	SWEP.Ammo3DScale = 0.015
	
	SWEP.IronSightsPos = Vector(-5.94, -2, 2.3)
	SWEP.IronSightsAng = Angle(0, 0, 0)
end

SWEP.Item = "heavy_m249para"
SWEP.AmmoItem = "ammobox_smg"

SWEP.ShootSound = Sound("Weapon_M249.Single")
SWEP.ReloadSound = nil

SWEP.Slot = 5
SWEP.SlotPos = 0
SWEP.ClassName = "weapon_heavy_m249para"
SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.HoldType = "ar2"

SWEP.UseHands = true

function SWEP:OnFireBullet(fDamage, iBullets, fCone, tFilter)
	if self:GetOwner():GetStat(STAT_STRENGTH) < 12 then
		local vel = self:GetOwner():GetAimVector()
		vel.z = 0
		
		self:GetOwner():SetVelocity(vel * -30)
	end
end

