SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Citizen Tech Shotgun"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.Font = "HL2Icons"
	SWEP.Icon = "b"
	SWEP.PosX = 0
	SWEP.PosY = 0

	SWEP.BoneDeltaAngles = {Up = 0,Right = 0,Forward = 0,MU = 2,MR = 2,MF = -8,Scale = 0.8}

	SWEP.Ammo3DBone = "ValveBiped.Gun"
	SWEP.Ammo3DPos = Vector(0.5, -0.4, -6)
	SWEP.Ammo3DScale = 0.017

	SWEP.IronSightsPos = Vector(-3, -6, 4)
	SWEP.IronSightsAng = Angle(-0.3, 0, 0)
end

SWEP.m_WeaponDeploySpeed = 0.3

SWEP.Slot = 5
SWEP.SlotPos = 0

SWEP.Item = "shotgun_citizen"
SWEP.AmmoItem = "ammobox_buckshot"

SWEP.ShootSound = Sound("Weapon_Shotgun.Single")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.HoldType = "shotgun"
SWEP.WeaponType = WEAPON_TYPE_GUN
SWEP.Skill = SKILL_SHOTGUNS

SWEP.Primary.Ammo = "buckshot"

SWEP.Primary.Damage = 7
SWEP.Primary.ClipSize = 6
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 0.4
SWEP.Cone = 0.05

SWEP.PumpTime = 0

SWEP.RoundPumpTime = 0.35

SWEP.ReloadTime = 3
SWEP.Reloading = false
SWEP.Anim_PumpTimes = 6

--SWEP.SkillCategory = SKILL_SHOTGUNS

function SWEP:OnFireBullet( damage, num_bullets, aimcone )
	self:SetNextPrimaryFire(CurTime() + self.RoundPumpTime + self.Primary.Delay)
	self.NeedToPump = true
	self.PumpTime = CurTime() + self.RoundPumpTime
end

function SWEP:Reload()
	if not self:GetHolstered() and self:GetNextPrimaryFire() < CurTime() then
		if self:Clip1() < self.Primary.ClipSize then
			if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
				if (CurTime() < self:GetReloadEnd()) then return end
				self:EmitSound(self.ReloadSound)
				local pumps = math.min(self.Primary.ClipSize - self:Clip1(), self.Owner:GetAmmoCount(self.Primary.Ammo))

				self.Reloading = true
				self.Anim_Pump = CurTime() + 0.6
				self.Anim_Pumped = 0
				self.Anim_ToPump = pumps
				self.Anim_Finish = CurTime() + 0.6 + 0.5 * pumps

				if SERVER then
					self:SetReloadEnd(self.Anim_Finish)
				end

				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

				self.Owner:DoReloadEvent()

				if self:Clip1() == 0 then
					self.NeedToPump = true
				end
			elseif self.Owner:GetItemCount(self.AmmoItem) > 0 then
				if SERVER then
					local item = self.Owner:GetItemByRef(self.AmmoItem)

					local amount = math.ceil(self.Primary.ClipSize / item.AmmoAmount)
					amount = math.min(amount, item:GetAmount())
					for i = 1, amount do
						self.Owner:UseInventoryItem(item)
					end
				end
			end
		end
	end
end

function SWEP:Think()
	if self.Reloading then
		if self.Owner:KeyDown(IN_ATTACK) then self.BreakReload = true end

		if self.Anim_Pumped < self.Anim_ToPump and self.Anim_Pump <= CurTime() then
			if self.BreakReload then
				self.BreakReload = nil
				self.Anim_Pump = nil
				self.Anim_Pumped = nil
				self.Anim_Finish = nil

				self.Reloading = false
				if SERVER then
					self:SetReloadEnd(CurTime() + 0.5)
				end
			else
				self.Anim_Pump = CurTime() + 0.5
				self.Anim_Pumped = self.Anim_Pumped + 1
				self:SendWeaponAnim(ACT_VM_RELOAD)

				self:SetClip1(self:Clip1() + 1)

				self.Owner:RemoveAmmo(1, self.Primary.Ammo)

				self:EmitSound("weapons/shotgun/shotgun_reload"..math.random(1, 3)..".wav")
			end
		elseif (self.Anim_Pumped >= self.Anim_ToPump and self.Anim_Finish <= CurTime()) then
			self.Anim_Pump = nil
			self.Anim_Pumped = nil
			self.Anim_Finish = nil

			self.Reloading = false

			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		end
	else
		if self.NeedToPump then
			if self.PumpTime < CurTime() then
				self.NeedToPump = false

				self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
				self:EmitSound("weapons/shotgun/shotgun_cock.wav")
			end
		end


		if self:GetIronSights() and not self.Owner:KeyDown(IN_ATTACK2) and self.Owner:GetInfoNum("noxrp_stickyironsights", 0) == 0  then
			self:SetIronSights2(false)
		end
	end
end