SWEP.Base = "weapon__base"

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.ShootSound = Sound("Weapon_Pistol.NPC_Single")
SWEP.ShootSound_Silenced = Sound("Weapon_Pistol.NPC_Single")
SWEP.ShootAnim_Silenced = ACT_VM_PRIMARYATTACK_SILENCED

SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Tracer = "AR2Tracer"
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Recoil = 1
SWEP.Primary.Burst = false
SWEP.Primary.BurstDelay = 0.1
SWEP.Primary.BurstAmount = 0
SWEP.Primary.Tracer = "Tracer"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.5

SWEP.Silencer = false

SWEP.IsBurstFiring = false
SWEP.BurstAmount = 0
SWEP.NextBurstFire = 0

SWEP.HoldType = "pistol"

SWEP.UseHands = true

SWEP.BulletSpeed = 3900
SWEP.BaseBulletClass = "projectile_asbullet"

SWEP.CanUseIronSights = true
SWEP.HolsterSound = true

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "ItemID")

	self:NetworkVar("Float", 0, "ReloadEnd")
	self:NetworkVar("Float", 1, "Durability")
	self:NetworkVar("Float", 2, "NextSprintLerp")

	self:NetworkVar("Bool", 0, "Holstered")
	self:NetworkVar("Bool", 1, "IronSights")
end

function SWEP:SetupItemVariables()
	local itemref = self:GetItemID()
	local item = self.Owner:GetItemByID(itemref)

	self.BaseStats = {}

	if item then
		self.Primary.Damage = item.Damage
		self.BaseStats.Damage = item.Damage

		self.Primary.NumShots = item.NumShots
		self.BaseStats.NumShots = item.NumShots

		self.Primary.Delay = item.Delay
		self.BaseStats.Delay = item.Delay

		self.Cone = item.Cone
		self.BaseStats.Cone = item.Cone

		self.Primary.ClipSize = item.ClipSize
		self.BaseStats.ClipSize = item.ClipSize

		if SERVER then
			self:SetDurability(item:GetData().Durability or -1)
		end

		self:UpdateEnhancements()
	end
end

function SWEP:UpdateEnhancements()
	local item = self:GetOwner():GetItemByID(self:GetItemID())

	if item then
		self.Modifications = item:GetData().Slots or {}

		local newstats = table.Copy(self.BaseStats)

		self.BulletSpeed = 2900
		self.BulletClass = self.BaseBulletClass

		for k, v in pairs(self.Modifications) do
			local gitem = ITEMS[v.Name]
			if gitem.WeaponStats then
				local tab = gitem:WeaponStats()

				for _, stat in pairs(tab) do
					local var, pos

					if stat[1] == ENHANCEMENT_TYPE_BULLETS then
						var = self.BaseStats.NumShots
						pos = "NumShots"
					elseif stat[1] == ENHANCEMENT_TYPE_ACCURACY then
						var = self.BaseStats.Cone
						pos = "Cone"
					elseif stat[1] == ENHANCEMENT_TYPE_DAMAGE then
						var = self.BaseStats.Damage
						pos = "Damage"
					elseif stat[1] == ENHANCEMENT_TYPE_CLIPSIZE then
						var = self.BaseStats.ClipSize
						pos = "ClipSize"
					else
						var = self.BaseStats.Delay
						pos = "Delay"
					end

					if stat[2] == ENHANCEMENT_ADD then
						var = var + stat[3]
					elseif stat[2] == ENHANCEMENT_SUBTRACT then
						var = var - stat[3]
					elseif stat[2] == ENHANCEMENT_MULTIPLY then
						if pos == "ClipSize" or pos == "NumShots" then
							var = math.max(var * stat[3], 1)
						else
							var = var * stat[3]
						end
					else
						var = var / stat[3]
					end

					newstats[pos] = var
				end
			end

			if gitem.OnWeaponUpdate then
				gitem:OnWeaponUpdate(self)
			end
		end

		self.Primary.Damage = newstats.Damage
		self.Primary.NumShots = newstats.NumShots
		self.Primary.Delay = newstats.Delay
		self.Cone = newstats.Cone

		local preclip1 = self:Clip1()
		self.Primary.ClipSize = math.Round(newstats.ClipSize)

		if preclip1 > self.Primary.ClipSize then
			self:GetOwner():GiveAmmo(preclip1 - self.Primary.ClipSize, self.Primary.Ammo)
			self:SetClip1(self.Primary.ClipSize)
		end

		if SERVER then
			self:CallOnClient("UpdateEnhancements", "")
			//self:CallOnClient("ForceSetBaseStats", tostring(self.BaseStats.Damage).." "..tostring(self.BaseStats.NumShots).." "..tostring(self.BaseStats.Delay).." "..tostring(self.BaseStats.Cone).." "..tostring(self.BaseStats.ClipSize))
		end
	end
end

function SWEP:HasEnhancement(name)
	for _, chip in pairs(self.Modifications) do
		if chip.Name == name then
			return true
		end
	end
end

function SWEP:Deploy()
	if self.DrawSound then
		for k,v in pairs(self.DrawSound) do
			timer.Simple(v[2], function() self.Weapon:EmitSound(v[1]) end)
		end
	end

	if self.GetSilenced then
		if self:GetSilenced() then
			self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
		else
			self:SendWeaponAnim(ACT_VM_DRAW)
		end
	else
		self:SendWeaponAnim(ACT_VM_DRAW)
	end

	if self.PostDeploy then
		self:PostDeploy()
	end

	return true
end

function SWEP:Holster()
	return self:CanHolster()
end

function SWEP:CanHolster()
	local ifhol = (CurTime() > self:GetNextPrimaryFire())
	if ifhol then
		if CLIENT then
			self:HolsterEffect()
		end
		return true
	end
	return false
end

function SWEP:PrimaryAttack()
	self:PrimaryAttack2()
end

function SWEP:PrimaryAttack2()
	if self:CanPrimaryAttack() and not self:IsReloading() and not self:GetHolstered() then
		if self.Primary.Recoil then
			local amt = self.Primary.Recoil
			if self.Owner:KeyDown(IN_DUCK) then
				amt = amt * 0.5
			end
		--	self.Owner:ViewPunch(Angle(math.Rand(-amt, amt), math.Rand(-amt, amt), 0))
		--	self.Owner:SetEyeAngles(self.Owner:EyeAngles() + Angle(math.Rand(-0.5, -0.2), math.Rand(-0.2, 0.2), 0))
		end

		if self:GetDurability() <= 0 then
			self:EmitSound(self.EmptySound)
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			return false
		end

		if SERVER then
			--self:UpdateDurability(-0.25)
			local scale = 1 / self.Primary.ClipSize
			self:UpdateDurability(scale * -1)
		end

		if self.Primary.Burst then
			self.IsBurstFiring = true
			self.BurstAmount = 0
			self:SetNextPrimaryFire(CurTime() + self.Primary.BurstDelay * self.Primary.BurstAmount + 0.2)
			self:SetNextSprintLerp(CurTime() + self.Primary.BurstDelay * self.Primary.BurstAmount + 1.2)
		else
			self:TakePrimaryAmmo(1)
			local filter = {}
				filter = self.Owner:GetAttackFilter()

				if self.Owner:GetVehicle():IsValid() then
					table.insert(filter, self.Owner:GetVehicle())

					if self.Owner:GetVehicle().GetDriverSeat then
						if self.Owner:GetVehicle():GetDriverSeat():IsValid() then
							table.insert(filter, self.Owner:GetVehicle():GetDriverSeat())
						end
					end
				end

			local cone = self.Cone
			if self.GetZoomLevel then
				if self:GetZoomLevel() > 0 then
					self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 1.5)
					self:SetNextSprintLerp(CurTime() + self.Primary.Delay * 1.5 + 1)
					cone = cone * 0.7
				else
					self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
					self:SetNextSprintLerp(CurTime() + self.Primary.Delay + 1)
				end
			else
				if self:GetIronSights() then
					self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 1.5)
					self:SetNextSprintLerp(CurTime() + self.Primary.Delay * 1.5 + 1)
					cone = cone * 0.8
				else
					self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
					self:SetNextSprintLerp(CurTime() + self.Primary.Delay + 1)
				end
			end
			local item = self.Owner:GetItemByID(self:GetItemID())
			item:GetData().Clip1 = self:Clip1()
			self:OnFireBullet(self.Primary.Damage, self.Primary.NumShots, cone, filter)
			self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, cone, filter)
		end
		return true
	else
		if self:Clip1() == 0 then
			return false
		end
	end
 	return false
end

function SWEP:OnFireBullet(fDamage, iBullets, fCone, tFilter)
end

function SWEP:SecondaryAttack()
	if not self:IsReloading() and not self.Owner:IsSprinting() and not self:GetHolstered() and self.CanUseIronSights and self:GetNextPrimaryFire() < CurTime() then
		self:ToggleIronSights()

		return true
	else
		return false
	end
end

function SWEP:ToggleIronSights()
	self:SetIronSights(not self:GetIronSights())
	if self:GetIronSights() then
		self:CallOnClient("StartIronSights")
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired") * 0.8, 0.3)
		end
		self.Weapon:EmitSound("weapons/generic/ironsight_on.wav", 50, 100)
	else
		self:CallOnClient("StopIronSights")
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.3)
		end
		self.Weapon:EmitSound("weapons/generic/ironsight_off.wav", 50, 100)
	end
end

function SWEP:SetIronSights2(bool)
	self:SetIronSights(bool)
	if self:GetIronSights() then
		self:CallOnClient("StartIronSights")
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired") * 0.8, 0.3)
		end
		self.Weapon:EmitSound("weapons/generic/ironsight_on.wav", 50, 100)
	else
		self:CallOnClient("StopIronSights")
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.3)
		end
		self.Weapon:EmitSound("weapons/generic/ironsight_off.wav", 50, 100)
	end
end

function SWEP:Think()
	if self.IsBurstFiring then
		if self.NextBurstFire < CurTime() then
			if self:Clip1() <= 0 then
				self.IsBurstFiring = false
				return
			end

			self.NextBurstFire = CurTime() + self.Primary.BurstDelay
			self.BurstAmount = self.BurstAmount + 1

			if self.BurstAmount >= self.Primary.BurstAmount then
				self.IsBurstFiring = false
			end

			if self.Primary.Recoil then
				local amt = self.Primary.Recoil
				if self.Owner:KeyDown(IN_DUCK) then
					amt = amt * 0.5
				end
			--	self.Owner:ViewPunch(Angle(math.Rand(-amt, amt), math.Rand(-amt, amt), 0))
			end

			if self:GetDurability() <= 0 then
				self:EmitSound(self.EmptySound)
				return false
			end

			if SERVER then
				self:UpdateDurability(-0.25)
			end

			self:TakePrimaryAmmo(1)

			self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Cone)
		end
	end

	if self.Owner:IsSprinting() and self:GetIronSights() then
		self:SetIronSights(false)
		self:CallOnClient("StopIronSights")
	elseif self:GetIronSights() and not self.Owner:KeyDown(IN_ATTACK2) and self.Owner:GetInfoNum("noxrp_stickyironsights", 0) == 0 then
		self:SetIronSights2(false)
	end
end

function SWEP:PlayFireSound()
	self:EmitSound(self.ShootSound)
end
--[[
function SWEP:ShootBullet( damage, num_bullets, aimcone )
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:PlayFireSound()

	local owner = self.Owner

	if self:GetDurability() < 20 then
		damage = damage * math.max(self:GetDurability() / 20, 0.4)
	end

	for k, v in pairs(self.Modifications) do
		local gitem = ITEMS[v.Name]
		if gitem.ShootBullet then
			gitem:ShootBullet(self, damage, num_bullets, aimcone)
			return
		end
	end

	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= owner:GetShootPos()
	bullet.Dir 		= owner:GetAimVector()
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )
	bullet.Tracer	= 1
	bullet.TracerName = self.Primary.Tracer
	bullet.Force	= 5
	bullet.Damage	= damage
	bullet.AmmoType = self.Primary.Ammo
	bullet.Attacker = owner
	bullet.Inflictor = self
	bullet.DamageType = self.DamageType
	bullet.Callback = self.BulletCallback

	owner:FireBullets( bullet )
end]]

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	--if SERVER then
		local attach = self:GetOwner():GetViewModel():GetAttachment(1)
		if attach then
			local effectdata = EffectData()
				effectdata:SetOrigin(attach.Pos)
				local ang = attach.Ang
				ang:RotateAroundAxis(ang:Right(), 0)

				effectdata:SetNormal(ang:Forward())
			util.Effect("bullet_fire", effectdata, true, true)
		end
	--end
end

function SWEP:DoImpactEffect(tr, nDamageType)
	local effect = EffectData()
		effect:SetRadius(tr.MatType)
		effect:SetOrigin(tr.HitPos)
		effect:SetNormal(tr.HitNormal)
	util.Effect("impact_effect",effect)
end

function SWEP:Reload()
	if not self:GetHolstered() then
		if self:Clip1() < self.Primary.ClipSize then
			if self:GetIronSights() then self:SetIronSights2(false) end
			if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
				if (CurTime() < self:GetReloadEnd()) then return end

				self:DoReloading()
			elseif self.Owner:GetItemCount(self.AmmoItem) > 0 then
				if SERVER then
					local item = self.Owner:GetItemByRef(self.AmmoItem)

					local amount = math.ceil(self.Primary.ClipSize / item.AmmoAmount)
					amount = math.min(amount, item:GetAmount())
					for i = 1, amount do
						self.Owner:UseInventoryItem(item)
					end

					self:SetReloadEnd(CurTime() + 0.1)

					if self.OnReload then
						self:OnReload()
					end

					--self:CallOnClient("DoReloading")
				end
			end
		end
	end
end

function SWEP:DoReloading()
	if self.ReloadSounds then
		for k,v in pairs(self.ReloadSounds) do
				timer.Simple(v[2], function() self.Weapon:EmitSound(v[1]) end)
		end
	else
		self:EmitSound(self.ReloadSound)
	end
	self.Owner:DoReloadEvent()

	if self.GetSilenced then
		if self:GetSilenced() then
			self:DefaultReload(ACT_VM_RELOAD_SILENCED)
		else
			self:DefaultReload(ACT_VM_RELOAD)
		end
	else
		self:DefaultReload(ACT_VM_RELOAD)
	end

	if SERVER then
		self:SetReloadEnd(CurTime() + self:SequenceDuration())
		self:SetNextSprintLerp(CurTime() + self:SequenceDuration() + 1)
	end
end

function SWEP:GenericShotgunDoReload()
	if not self:GetHolstered() and self:GetNextPrimaryFire() < CurTime() then
		if self:Clip1() < self.Primary.ClipSize then
			if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then

				//If we're still reloading, don't try to reload again
				if (CurTime() < self:GetReloadEnd()) then return end

				self:EmitSound(self.ReloadSound)
				local pumps = math.min(self.Primary.ClipSize - self:Clip1(), self.Owner:GetAmmoCount(self.Primary.Ammo))

				self.Reloading = true
				self.Anim_Pump = CurTime() + 0.4
				self.Anim_Pumped = 0
				self.Anim_ToPump = pumps
				self.Anim_Finish = CurTime() + 0.4 + 0.6 * pumps

				if SERVER then
					self:SetReloadEnd(self.Anim_Finish + 1)
				end

				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
				self.Owner:DoReloadEvent()
			elseif self.Owner:GetItemCount(self.AmmoItem) > 0 then
				if SERVER then
					local item = self.Owner:GetItemByRef(self.AmmoItem)

					local amount = math.ceil(self.Primary.ClipSize / item.AmmoAmount)
					amount = math.min(amount, item:GetAmount())
					for i = 1, amount do
						self.Owner:UseInventoryItem(item)
					end

					self:SetReloadEnd(CurTime() + 0.1)
				end
			end
		end
	end
end

function SWEP:GenericShotgunReloadThink()
	if self.Reloading then
		if self.Owner:KeyDown(IN_ATTACK) then self.BreakReload = true end

		if self.Anim_Pumped < self.Anim_ToPump and self.Anim_Pump <= CurTime() then
			if self.BreakReload then
				self.BreakReload = nil
				self.Anim_Pump = nil
				self.Anim_Pumped = nil
				self.Anim_Finish = nil

				self.Reloading = false

				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				if SERVER then
					self:SetReloadEnd(CurTime() + 0.5)
				end
			else
				self.Anim_Pump = CurTime() + 0.6
				self.Anim_Pumped = self.Anim_Pumped + 1
				self:SendWeaponAnim(ACT_VM_RELOAD)

				self:SetClip1(self:Clip1() + 1)

				self.Owner:RemoveAmmo(1, self.Primary.Ammo)

				self:EmitSound("Weapon_XM1014.InsertShell")
			end
		elseif (self.Anim_Pumped >= self.Anim_ToPump and self.Anim_Finish <= CurTime()) then
			self.Anim_Pump = nil
			self.Anim_Pumped = nil
			self.Anim_Finish = nil

			self.Reloading = false

			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		end
	end

	if self.Owner:IsSprinting() and self:GetIronSights() then
		self:SetIronSights(false)
		self:CallOnClient("StopIronSights")
	elseif self:GetIronSights() and not self.Owner:KeyDown(IN_ATTACK2) and self.Owner:GetInfoNum("noxrp_stickyironsights", 0) == 0 then
		self:SetIronSights2(false)
	end
end
