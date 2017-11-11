SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'Harbinger' Grenade Launcher"
	SWEP.PrintName2 = ""

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "i"
	SWEP.PosX = -10
	SWEP.PosY = 0
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = 0,Forward = 0,MU = 2,MR = 2,MF = -8,Scale = 0.8}
	
	SWEP.SprintAngles = Angle(-15, 0, 10)
	SWEP.SprintVector = Vector(5, 0, 0)
	
	SWEP.Ammo3DBone = "base"
	SWEP.Ammo3DPos = Vector(3, -1, 5)
	SWEP.Ammo3DAng = Angle(180, 0, 0)
	SWEP.Ammo3DScale = 0.03
end

SWEP.Item = "heavy_grenadelauncher"
SWEP.AmmoItem = "ammobox_missile"

SWEP.Slot = 5
SWEP.SlotPos = 0
SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG_Round"
SWEP.ShootSound = Sound("Weapon_RPG.Single")
SWEP.ReloadSound = Sound("Weapon_RPG.LaserOn")

SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 1
SWEP.HoldType = "rpg"

SWEP.UseHands = true

if SERVER then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() and not self:IsReloading() and not self:GetHolstered() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			
			self:EmitSound(Sound("npc/env_headcrabcanister/launch.wav"))
			
			self:SetClip1(self:Clip1() - 1)
			
			local aimvec = self.Owner:GetAimVector()
			local randang = Angle(math.Rand(-5, 5), math.Rand(-5, 5), 0)
							
			local proj = ents.Create("projectile_incendiarymirvgrenade_mini")
				proj:SetPos(self.Owner:GetShootPos() + aimvec * 100)
				proj:SetAngles(aimvec:Angle() + randang)
				proj:Spawn()
				proj:SetOwner(self.Owner)
				proj.Inflictor = self
				proj.Attacker = self.Owner
							
			local phys = proj:GetPhysicsObject()
			if phys:IsValid() then
				local fwd = proj:GetForward()
				phys:SetVelocityInstantaneous(fwd * 1000)
			end
		end
	end
end

if CLIENT then
end



