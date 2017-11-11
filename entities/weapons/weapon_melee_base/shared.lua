SWEP.Base = "weapon__base"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Automatic = true

SWEP.HoldType = "melee"
SWEP.UseHands = true

SWEP.Item = "crowbar"

SWEP.HitDecal = "Impact.Concrete"

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER

SWEP.DamageType = DMG_SLASH

SWEP.MaterialType = WEAPON_MATERIAL_METAL
SWEP.NextGroundSmash = 0

--SWEP.ForceThirdPerson = true

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "ItemID")

	self:NetworkVar("Float", 0, "Durability")
	self:NetworkVar("Float", 1, "NextSprintLerp")

	self:NetworkVar("Bool", 0, "Holstered")
end

function SWEP:GetBlocking()
	return self:GetDTBool(2)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.25)

	self:SendWeaponAnim(ACT_VM_DEPLOY)

	if CLIENT then
		self:Cons_SetupClientModels()

		if self.Owner == LocalPlayer() then
			local item = self.Owner:GetItemByID(self:GetItemID())

			self.WeaponInfo.Damage = item.Damage
			self.WeaponInfo.Delay = item.Delay
			self.WeaponInfo.Range = item.Range

			if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
				self.Owner.LoadoutEffect:WeaponInitialize(self)
			end
		end
	end
end

function SWEP:SetupItemVariables()
	local itemref = self:GetItemID()
	local item = self.Owner:GetItemByID(itemref)

	if not item then return end

	self.WeaponInfo.Damage = item.Damage
	self.WeaponInfo.Delay = item.Delay
	self.WeaponInfo.Range = item.Range

	if SERVER then
		self:SetDurability(item.Durability or -1)
	end
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
		self:SetNextPrimaryFire(CurTime() + self.WeaponInfo.Delay)
	--	self:SetNextSprintLerp(CurTime() + self.WeaponInfo.Delay + 1)
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		self:Swing()
	end
end

function SWEP:CanPrimaryAttack()
	return self:GetNextPrimaryFire() < CurTime() and not self:GetBlocking() and not self:GetHolstered()
end

function SWEP:SecondaryAttack()
	if self:CanSecondaryAttack() then
		self:SetNextSecondaryFire(CurTime() + 2)
		self:SetNextPrimaryFire(CurTime() + 2)
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		self:SwingSecondary()
	end
end

function SWEP:CanSecondaryAttack()
	return self:GetOwner():GetSkill(SKILL_BLUNTWEAPONS) >= 500 and self.WeaponSkill == SKILL_BLUNTWEAPONS and self:GetNextSecondaryFire() < CurTime()
end

function SWEP:Reload()
	return false
end

function SWEP:CanHolster()
	if CurTime() > self:GetNextPrimaryFire() and not self:GetBlocking() then
		if CLIENT then
			self:HolsterEffect()
		end
		return true
	end
	return false
end

function SWEP:Swing()
	local owner = self.Owner

	local data = {}
	data.start = owner:GetShootPos()
	data.endpos = data.start + owner:GetAimVector() * self.WeaponInfo.Range
	data.mins = Vector(-8, -8, -8)
	data.maxs = Vector(8, 8, 8)
	data.filter = {self, owner}

	owner:LagCompensation(true)

	local trace = util.TraceHull(data)

	owner:LagCompensation(false)

	local ent = trace.Entity

	if self.SwingSound then
		self:EmitSound(self.SwingSound)
	end

	self:OnSwing(trace)

	if trace.Hit then
		self:SendWeaponAnim(self.HitAnim)
		self:OnHit(trace)

		if ent:IsValid() then
			local damage = self.WeaponInfo.Damage
			local plitem = self.Owner:GetItemByID(self:GetItemID())

			if plitem:GetData().Durability > 0 then
				if self.Owner:GetStat(STAT_STRENGTH) >= 10 then
					damage = damage + damage * (self.Owner:GetStat(STAT_STRENGTH) - 10) * 0.01
				elseif self.Owner:GetStat(STAT_STRENGTH) < 10 then
					damage = damage - damage * ((self.Owner:GetStat(STAT_STRENGTH) - 10) * -1) * 0.01
				end
			else
				damage = 1
			end
			self:OnHitEntity(trace, damage)
			self:OnHitEntitySound()
		else
			self:OnHitWorld(trace)
		end
	else
		self:SendWeaponAnim(self.MissAnim)
		self:OnMiss()
	end
end

function SWEP:SwingSecondary()
	local owner = self.Owner

	local data = {}
	data.start = owner:GetShootPos()
	data.endpos = data.start + owner:GetAimVector() * self.WeaponInfo.Range
	data.mins = Vector(-8, -8, -8)
	data.maxs = Vector(8, 8, 8)
	data.filter = {self, owner}

	owner:LagCompensation(true)

	local trace = util.TraceHull(data)

	owner:LagCompensation(false)

	local ent = trace.Entity

	if self.SwingSound then
		self:EmitSound(self.SwingSound)
	end

	self:OnSwing(trace)

	if trace.Hit then
		self:SendWeaponAnim(self.HitAnim)
		self:OnHit(trace)

		if ent:IsValid() then
			local damage = self.WeaponInfo.Damage
			local plitem = self.Owner:GetItemByID(self:GetItemID())

			if plitem:GetData().Durability > 0 then
				if self.Owner:GetStat(STAT_STRENGTH) >= 10 then
					damage = damage + damage * (self.Owner:GetStat(STAT_STRENGTH) - 10) * 0.01
				elseif self.Owner:GetStat(STAT_STRENGTH) < 10 then
					damage = damage - damage * ((self.Owner:GetStat(STAT_STRENGTH) - 10) * -1) * 0.01
				end
			else
				damage = 1
			end

			self:OnHitEntity(trace, damage)
			self:OnHitEntitySound()
		else
			self:OnHitWorld(trace)
		end
	else
		self:SendWeaponAnim(self.MissAnim)
		self:OnMiss()
	end
end

function SWEP:OnSwing(trace)
end

function SWEP:OnHitEntity(trace, damage)
	if SERVER then
		local ent = trace.Entity

		ent:TakeSpecialDamage(damage, self.Owner, self, self.DamageType, trace.HitPos)

		if self.Bash then
			if ent:IsPlayer() then
				ent:SetVelocity(trace.Normal * 600)
			elseif ent:IsNextBot() then
				ent.loco:SetVelocity(trace.Normal * 600)
			end
		end

		if ent:IsPlayer() or ent.CanRaiseSkill then
			self:CallSkillCheck(ent)
		end
	end
end

function SWEP:OnHitEntitySound()
end

function SWEP:OnHitWorld(trace)
	local effecttrace = {}
		effecttrace.start = trace.start
		effecttrace.endpos = trace.endpos
	local tr2 = util.TraceLine(effecttrace)

	util.Decal(self.HitDecal, tr2.HitPos + tr2.HitNormal, tr2.HitPos - tr2.HitNormal)

	if SERVER then
		if self.NextGroundSmash < CurTime() then
			if self:GetOwner():GetSkill(SKILL_BLUNTWEAPONS) >= 400 and self.WeaponSkill == SKILL_BLUNTWEAPONS then
				for _, ent in pairs(ents.FindInSphere(self:GetOwner():GetPos(), 120)) do
					if ent:IsPlayer() then
						if ent:GetGroundEntity() == Entity(0) and ent != self:GetOwner() then
							ent:SetVelocity(Vector(0, 0, 1) * 400)
						end
					end
				end

				self.NextGroundSmash = CurTime() + 2
			end
		end
	end
end

function SWEP:OnHitWorldSound(trace)
end

function SWEP:OnHit(trace)
	local effect = EffectData()
		effect:SetRadius(trace.MatType)
		effect:SetOrigin(trace.HitPos)
		effect:SetNormal(trace.HitNormal)
		effect:SetScale(self.MaterialType)
		effect:SetDamageType(self.DamageType)
	util.Effect("impact_effect", effect)
end

function SWEP:OnHitSound(trace)
end

function SWEP:OnMiss()
end


RegisterLuaAnimation('1h_Blocking', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RR = -34.327665833754,
					RF = -80.556581836632
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RF = -56.889462942742
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RF = -64.829295805481
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = -6.972073719109
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RF = -33.711723647031
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RR = -5.573306362016,
					RU = 79.732036245185
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -14.2360679775,
					RR = 22.307135789365,
					RF = 39.973084536457
				}
			},
			FrameRate = 1
		}
	},
	Type = TYPE_POSTURE,
	TimeToArrive = 0.2
})

RegisterLuaAnimation('1h_idle', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RF = -96
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = -16
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RF = -32
				}
			},
			FrameRate = 1
		}
	},
	Type = TYPE_POSTURE,
	TimeToArrive = 0.1
})