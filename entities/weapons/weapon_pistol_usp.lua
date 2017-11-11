SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "USP Handgun"
	SWEP.PrintName2 = "9mm Silenced Pistol"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.CSMuzzleFlashes = true
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "u"
	
	SWEP.HUDPosX = 0
	SWEP.HUDPosY = 15
	
	SWEP.BoneDeltaAngles = {Up = 0,Right = 0,Forward = 90,MU = -4,MR = -6,MF = 7,Scale = 1}
	
	SWEP.Ammo3DBone = "v_weapon.USP_Slide"
	SWEP.Ammo3DPos = Vector(-0.7, 0.15, 0.5)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.012
	
	SWEP.IronSightsPos = Vector(-3, -10, 2)
	SWEP.IronSightsAng = Angle(2, 0, 0)
	
	SWEP.SprintAngles = Angle(-10, 0, 0)
	SWEP.SprintVector = Vector(0, 0, 0)
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_usp"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = Sound("Weapon_USP.Single")
SWEP.ShootSound_Silenced = Sound("Weapon_USP.SilencedShot")

SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN

SWEP.Primary.Damage = 8
SWEP.Primary.ClipSize = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.19
SWEP.Cone = 0.011

--SWEP.SkillCategory = SKILL_PISTOLS

function SWEP:GetSilenced()
	return self:GetDTBool(2)
end

function SWEP:SetSilenced(bool)
	self:SetDTBool(2, bool)
end

function SWEP:PlayFireSound()
	if self:GetSilenced() then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
		self:EmitSound(self.ShootSound_Silenced)
	else
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:EmitSound(self.ShootSound)
	end
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_WALK) then
		if self:CanSecondaryAttack() and self.Owner:HasItem("silencer") then
			local bool = self:GetSilenced()
			if SERVER then self:SetSilenced(not bool) end
			self:SetNextSecondaryAttack(CurTime() + 2)
			self:SetNextPrimaryAttack(CurTime() + 2)
			if not bool then
				self:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
				self:CallOnClient("UpdateSprintModSilenced")
			else
				self:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
				self:CallOnClient("UpdateSprintModUnSilenced")
			end
		end
	elseif not self:IsReloading() and not self.Owner:IsSprinting() and not self:GetHolstered() and self.CanUseIronSights and self:GetNextPrimaryFire() < CurTime() then
		self:ToggleIronSights()
	end
end

function SWEP:CanSecondaryAttack()
	return self:GetNextSecondaryFire() < CurTime() and self:GetReloadEnd() < CurTime()
end

if CLIENT then
	function SWEP:UpdateSprintModSilenced()
		self.SprintAngles = Angle(-10, 0, 0)
		self.SprintVector = Vector(0, 0, 0)
	end
	
	function SWEP:UpdateSprintModUnSilenced()
		self.SprintAngles = Angle(-10, 0, 0)
		self.SprintVector = Vector(0, 0, 0)
	end
	
	function SWEP:GetAmmoCounterColor()
		local line1, line2, icon = Color(255, 255, 255, 255), Color(255, 255, 255, 255), Color(255, 255, 255, 255)
		
		if self:Clip1() <= 0 then
			line1 = Color(255, 100, 100, 255)
		elseif self:Clip1() <= (self.Primary.ClipSize * 0.3) then
			line1 = Color(255, 255, 0, 255)
		end

		if self:GetOwner():GetAmmoCount(self.Primary.Ammo) == 0 then
			line2 = Color(255, 100, 100, 255)
		elseif self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= (self.Primary.ClipSize * 2) then
			line2 = Color(255, 255, 100, 255)
		end

		if self:GetSilenced() then
			icon = Color(50, 100, 255, 255)
		elseif self:GetDurability() <= 30 then
			local times = 80 * math.sin(CurTime() * 4)
			if self:GetDurability() == 0 then
				icon = Color(255, 50, 50, 175 + times)
			else
				icon = Color(255, 255, 180, 175 + times)
			end
		end
		
		return line1, line2, icon
	end
end