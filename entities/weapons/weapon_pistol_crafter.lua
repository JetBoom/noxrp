SWEP.Base = "weapon__base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Crafter"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "d"
end

SWEP.Slot = 10
SWEP.SlotPos = 0

SWEP.Item = "handgun_9mm"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = "weapons/airboat/airboat_gun_energy1.wav"
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN
SWEP.Primary.ClipSize = 100

SWEP.Primary.Delay = 0.2
SWEP.Primary.Automatic = true

--SWEP.SkillCategory = SKILL_PISTOLS

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.25)
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() < CurTime() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
				
		if SERVER then
			self:DoCraft()
		end
	end
end

function SWEP:CanHolster()
	return false
end

function SWEP:DoCraft()
	local owner = self.Owner
	local data = {}
		data.start = owner:GetShootPos()
		data.endpos = data.start + owner:GetAimVector() * 200
		data.filter = {self, owner}
				
	local tr = util.TraceLine(data)
	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "crafting_part" then
			tr.Entity:OnHitWithCrafter(owner, self)
		end
	end
end
