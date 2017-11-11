SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "9mm Pistol"
	SWEP.PrintName2 = "Standard Combine Issue"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.Font = "HL2Icons"
	SWEP.Icon = "d"

	SWEP.PosY = -10
	SWEP.CPosY = 25

	SWEP.Ammo3DBone = "ValveBiped.square"
	SWEP.Ammo3DPos = Vector(0.8, 0, -3)
	SWEP.Ammo3DAng = Angle(210, 0, 0)
	SWEP.Ammo3DScale = 0.013

	SWEP.ViewModelFlip1 = true
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Item = "handgun_9mm"
SWEP.AmmoItem = "ammobox_pistol"

SWEP.ShootSound = Sound("Weapon_Pistol.Single")
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.25)

	if CLIENT then
		self.BaseStats = {}

		self.ParticleEmitter = ParticleEmitter(self:GetPos())
		self:Cons_SetupClientModels()

		local itemref = self:GetIDTag()

		if self.Owner == LocalPlayer() then
			local plitem = self.Owner:GetItemByID(itemref)
			local item = ITEMS[plitem.Name]

			if plitem then
				if plitem.Data then
					self.Primary.Damage = math.GetCleanRound(item.Damage, plitem.Data.Damage or 0)
					self.BaseStats.Damage = math.GetCleanRound(item.Damage, plitem.Data.Damage or 0)

					self.Primary.NumShots = math.GetCleanRound(item.NumShots, plitem.Data.NumShots or 0)
					self.BaseStats.NumShots = math.GetCleanRound(item.NumShots, plitem.Data.NumShots or 0)

					self.Primary.Delay = item.Delay
					self.BaseStats.Delay = item.Delay

					self.Cone = math.GetCleanRound(item.Cone, plitem.Data.Cone or 0)
					self.BaseStats.Cone = math.GetCleanRound(item.Cone, plitem.Data.Cone or 0)

					self.Primary.ClipSize = math.GetCleanRound(item.ClipSize, plitem.Data.ClipSize or 0)
					self.BaseStats.ClipSize = math.GetCleanRound(item.ClipSize, plitem.Data.ClipSize or 0)

					if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
						self.Owner.LoadoutEffect:WeaponInitialize(self)
					end

					self:UpdateEnhancements()
				else
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

					self.Modifications = {}
				end
			end
		end
	end
end

if SERVER then
	function SWEP:StartDualWield()
--		DoSetup( ply, spec )
		self.Owner:GetViewModel(1):SetWeaponModel(self.ViewModel, self)
		self.Owner:DrawViewModel(true, 1)

		self.Hands2 = ents.Create("gmod_hands2")
		if self.Hands2 then
			self.Hands2:DoSetup(self.Owner)
			self.Hands2:AttachToViewmodel(self.Owner:GetViewModel(1))
		end

		self:SetDTEntity(0, self.Hands2)

		local hands = self.Owner:GetHands()
		if hands then
			hands:AttachToViewmodel(self.Owner:GetViewModel(0))
		end

		self.Secondary.ClipSize = self.Primary.ClipSize
		self.Secondary.Ammo = self.Primary.Ammo

		self:SetClip2(12)

		self:CallOnClient("SetupDualWield")
	end
end

function SWEP:PrimaryAttack()
	if self.Owner:KeyDown(IN_RELOAD) then return end
	if self:CanPrimaryAttack() and not self:IsReloading() and not self:GetHolstered() and not self.Owner:IsKnockedDown() then
		if self.Primary.Recoil then
			local amt = self.Primary.Recoil
			if self.Owner:KeyDown(IN_DUCK) then
				amt = amt * 0.5
			end
			self.Owner:ViewPunch(Angle(math.Rand(-amt, amt), math.Rand(-amt, amt), 0))
			self.Owner:SetEyeAngles(self.Owner:EyeAngles() + Angle(math.Rand(-amt, amt), math.Rand(-amt, amt), 0))
		end

		if self:GetDurability() <= 0 then
			self:EmitSound(self.EmptySound)
			return false
		end

		if SERVER then
			self:UpdateDurability(-0.25)
		end

		self.NextLerpTime = CurTime() + 1.5

		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:TakePrimaryAmmo(1)

		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Cone)
		return true
	elseif self:Clip1() == 0 then
		return false
	end
 	return false
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_RELOAD) then return end
	if self:CanSecondaryAttack() and not self:IsReloading() and not self:GetHolstered() and not self.Owner:IsKnockedDown() then
		if self.Primary.Recoil then
			local amt = self.Primary.Recoil
			if self.Owner:KeyDown(IN_DUCK) then
				amt = amt * 0.5
			end
			self.Owner:ViewPunch(Angle(math.Rand(-amt, amt), math.Rand(-amt, amt), 0))
			self.Owner:SetEyeAngles(self.Owner:EyeAngles() + Angle(math.Rand(-amt, amt), math.Rand(-amt, amt), 0))
		end

		if self:GetDurability() <= 0 then
			self:EmitSound(self.EmptySound)
			return false
		end

		if SERVER then
			self:UpdateDurability(-0.25)
		end

		self.NextLerpTime = CurTime() + 1.5

		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:TakeSecondaryAmmo(1)

		self:ShootBullet2(self.Primary.Damage, self.Primary.NumShots, self.Cone)
		return true
	elseif self:Clip1() == 0 then
		return false
	end
 	return false
end

function SWEP:ShootBullet2( damage, num_bullets, aimcone )
	self:SendWeaponAnimation(ACT_VM_PRIMARYATTACK, 1, 1 )
	self.Owner:MuzzleFlash()

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(self.ShootSound)

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
	bullet.Force	= 1
	bullet.Damage	= damage
	bullet.AmmoType = self.Primary.Ammo
	bullet.Attacker = owner
	bullet.Inflictor = self
	bullet.DamageType = self.DamageType
	bullet.Callback = self.BulletCallback

	owner:FireBullets( bullet )
end
--[[
function SWEP:Reload()
	if self.Owner:IsKnockedDown() then return end
	if not self:GetHolstered() then
		if self.Owner:KeyDown(IN_ATTACK) then
			if self:Clip1() < self.Primary.ClipSize then
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					if (CurTime() < self:GetReloadEnd()) then return end

					self:DoReloading2()
				elseif self.Owner:GetItemCount(self.AmmoItem) > 0 then
					if SERVER then
						local item = self.Owner:GetItemByRef(self.AmmoItem)
						self.Owner:UseInventoryItem(item.IDRef)
						self.FromInv = true

						self:CallOnClient("DoReloading")
					end

				end
			end
		elseif self.Owner:KeyDown(IN_ATTACK2) then
			if self:Clip1() < self.Primary.ClipSize then
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					if (CurTime() < self:GetReloadEnd()) then return end

					self:DoReloading()
				elseif self.Owner:GetItemCount(self.AmmoItem) > 0 then
					if SERVER then
						local item = self.Owner:GetItemByRef(self.AmmoItem)
						self.Owner:UseInventoryItem(item.IDRef)
						self.FromInv = true

						self:CallOnClient("DoReloading")
					end

				end
			end
		end
	end
end

function SWEP:DoReloading()
	if self.ReloadSounds then
		for k,v in pairs(self.ReloadSounds) do
				timer.Simple(v[2],function() self.Weapon:EmitSound(v[1]) end)
		end
	else
		self:EmitSound(self.ReloadSound)
	end
	self.Owner:DoReloadEvent()

	if self.GetSilenced then
		if self:GetSilenced() then
			--self:DefaultReload(ACT_VM_RELOAD_SILENCED)
		else
			--self:DefaultReload(ACT_VM_RELOAD)
		end
	else
	--	self:DefaultReload(ACT_VM_RELOAD)
		self:SendWeaponAnimation(ACT_VM_RELOAD, 0, 1 )
	end

	if SERVER then
		if self.FromInv then
			self.FromInv = false
			self:SetReloadEnd(CurTime() + self:SequenceDuration() + 2)
			self.Reloading1 = true
		else
			self:SetReloadEnd(CurTime() + self:SequenceDuration() + 1)
			self.Reloading1 = true
		end

		self.Owner:DrawViewModel(false, 1)
	end
end

function SWEP:DoReloading2()
	if self.ReloadSounds then
		for k,v in pairs(self.ReloadSounds) do
				timer.Simple(v[2],function() self.Weapon:EmitSound(v[1]) end)
		end
	else
		self:EmitSound(self.ReloadSound)
	end
	self.Owner:DoReloadEvent()

	if self.GetSilenced then
		if self:GetSilenced() then
		--	self:DefaultReload(ACT_VM_RELOAD_SILENCED)
		else
		--	self:DefaultReload(ACT_VM_RELOAD)
		end
	else
	--	self:DefaultReload(ACT_VM_RELOAD)
		self:SendWeaponAnimation(ACT_VM_RELOAD, 1, 1 )
	end

	if SERVER then
		if self.FromInv then
			self.FromInv = false
			self:SetReloadEnd(CurTime() + self:SequenceDuration() + 2)
			self.Reloading2 = true
		else
			self:SetReloadEnd(CurTime() + self:SequenceDuration() + 1)
			self.Reloading2 = true
		end

		self.Owner:DrawViewModel(false, 0)
	end
end

if SERVER then
	function SWEP:Think()
		if self.Reloading1 then
			if self:GetReloadEnd() < CurTime() then
				self.Reloading1 = false

				local amt = self.Primary.ClipSize - self:Clip1()

				self:SetClip1(self:Clip1() + amt)
				self.Owner:DrawViewModel(true, 1)
			end
		elseif self.Reloading2 then
			if self:GetReloadEnd() < CurTime() then
				self.Reloading2 = false

				local amt = self.Secondary.ClipSize - self:Clip2()

				self:SetClip2(self:Clip2() + amt)

				self.Owner:DrawViewModel(true, 0)
			end
		end
	end
end]]

function SWEP:SendWeaponAnimation( anim, idx, pbr )

	idx = idx or 0
	pbr = pbr or 1.0

	local owner = self:GetOwner()

	if( owner and owner:IsValid() and owner:IsPlayer() ) then

		local vm = owner:GetViewModel( idx )

		local idealSequence = self:SelectWeightedSequence( anim )
		local nextSequence = self:FindTransitionSequence( self:GetSequence(), idealSequence )

		vm:RemoveEffects( EF_NODRAW )
		vm:SetPlaybackRate( pbr )

		if( nextSequence > 0 ) then
			vm:SendViewModelMatchingSequence( nextSequence )
		else
			vm:SendViewModelMatchingSequence( idealSequence )
		end

		return vm:SequenceDuration( vm:GetSequence() )
	end
end

if CLIENT then
	function SWEP:SetupDualWield()
		self.Secondary.ClipSize = self.Primary.ClipSize
		self.Secondary.Ammo = self.Primary.Ammo
	end

	function SWEP:PostDrawViewModel(vm)
		if self.ShowViewModel == false or (self.LerpAngVM == 1 and self:GetHolstered()) then
			render.SetBlend(1)
		end

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

		local hands2 = self:GetDTEntity(0)
		if ( IsValid( hands2 ) ) then hands2:DrawModel() end


		local pos, ang = self:GetAmmo3DPos(vm)

		if self.Modifications then
			for _, mod in pairs(self.Modifications) do
				local gitem = ITEMS[mod.Name]
				if gitem.DrawViewModelEffects then
					gitem:DrawViewModelEffects(self, vm)
				end
			end
		end

		if pos then
			self:Draw3DAmmo(vm, pos, ang)
		end
	end
end
