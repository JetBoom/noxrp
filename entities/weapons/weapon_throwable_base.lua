SWEP.Base = "weapon__base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Throwable Base"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "k"
	
	SWEP.PosX = -5
	SWEP.PosY = 0
	
	SWEP.BoneDeltaAngles = {Up = 180, Right = 0, Forward = 0, MU = -4, MR = 3, MF = -8, Scale = 1}
	
	SWEP.SprintAngles = Angle(-10, 0, 0)
	SWEP.SprintVector = Vector(0, 0, 0)
	
	SWEP.NoHolsterModel = false
end

SWEP.Slot = 8
SWEP.SlotPos = 0

SWEP.Projectile = "projectile_smokegrenade"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"

SWEP.ThrowSound = Sound("WeaponFrag.Throw")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 15

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.HoldType = "grenade"
SWEP.UseHands = true

SWEP.PowerProjectileSpeed = 100
SWEP.PowerPerStrength = 50
SWEP.BaseProjectileSpeed = 200
SWEP.BaseSpeedPerStrength = 30

SWEP.Item = "explosivegrenade"

SWEP.Thrown = false
SWEP.WeaponType = WEAPON_TYPE_THROW
SWEP.CanDrop = true
SWEP.CanThrow = true
SWEP.NextThrow = 0

SWEP.ThrowAngle = Angle(0, 0, 0)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1)
	
	
	if CLIENT then
		self.ItemCount = self.Owner:GetItemCount(self.Item)
		self:Cons_SetupClientModels()
	end
	
	if SERVER then
		self:SetNWFloat("NextSprintLerp", 0)
	end
end

function SWEP:SetNextSprintLerp(time)
	self:SetNWFloat("NextSprintLerp", time)
end

function SWEP:GetNextSprintLerp()
	return self:GetNWFloat("NextSprintLerp")
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:GetReloadEnd()
	return 0
end

if SERVER then
	function SWEP:CanPrimaryAttack()
		local hasitem = self.Owner:HasItem(self.Item)
		return not self.Thrown and not self.ThrowDelayTime and hasitem
	end
	
	function SWEP:SecondaryAttack()
		if self.CanDrop then
			self:DropProjectile()
		end
	end
	
	function SWEP:Holster()
		return true
	end
	
	function SWEP:ThrowProjectile()
		local owner = self.Owner
		local ent = ents.Create(self.Projectile)
		local pow = self:GetThrowPower()
		self.CanThrow = false
		self.CanDrop = false
		self.NextThrow = CurTime() + 1
		
		local str = owner:GetStat(STAT_STRENGTH)
		
		local powspeed
		local basespeed
		if str <= 8 then
			powspeed = self.PowerProjectileSpeed + self.PowerPerStrength * str
			basespeed = self.BaseProjectileSpeed + self.BaseSpeedPerStrength * str
		else
			powspeed = self.PowerProjectileSpeed + self.PowerPerStrength * 8 + 15 * (str - 8)
			basespeed = self.BaseProjectileSpeed + self.BaseSpeedPerStrength * 8 + 10 * (str - 8)
		end
		
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos() + owner:GetAimVector() * 20)
			ent:SetAngles(owner:EyeAngles() + self.ThrowAngle)
			ent:SetOwner(owner)
			ent:Spawn()
			ent:EmitSound(self.ThrowSound)
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 4)
				phys:SetVelocityInstantaneous(owner:GetAimVector() * (basespeed + pow * powspeed))
			end
			self.Owner:DestroyItemByName(self.Item, 1)
		end
		
		self:SetThrowPower(0)
		self.DeleteTime = CurTime() + 1.5
		self.Thrown = true
		
		if self.OnThrownProjectile then
			self:OnThrownProjectile(ent, pow)
		end
		
		self:CallOnClient("UpdateAmmoCounter")
	end
	
	function SWEP:DropProjectile()
		self.CanThrow = false
		self.CanDrop = false
		self.NextThrow = CurTime() + 1
		
		local owner = self.Owner
		local ent = ents.Create(self.Projectile)
		if ent:IsValid() then
			local pow = self:GetThrowPower()
			ent:SetPos(owner:GetShootPos())
			ent:SetOwner(owner)
			ent:Spawn()
			ent:EmitSound(self.ThrowSound)
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 1)
				phys:SetVelocityInstantaneous(owner:GetAimVector() * 10)
			end
			self.Owner:DestroyItemByName(self.Item, 1)
		end
		self:SetThrowPower(0)
		self.DeleteTime = CurTime() + 1.5
		self.Thrown = true
		
		self:CallOnClient("UpdateAmmoCounter")
	end
	
	function SWEP:SetThrowPower(amt)
		self:SetDTFloat(0, math.Clamp(amt, 0, 1))
	end
	
	function SWEP:AddThrowPower(amt)
		self:SetDTFloat(0, math.Clamp(self:GetThrowPower() + amt, 0, 1))
	end
end

function SWEP:Think()
	local amt = self.Owner:GetItemCount(self.Item)
	local owner = self.Owner
	
	if self.Thrown then
		if amt <= 0 then
			self:Remove()
		elseif self.DeleteTime < CurTime() then
			self.DeleteTime = 0
			self.Thrown = false
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	elseif self.CanThrow then
		if self.ThrowDelay and self.ThrowDelayTime then
			if self.ThrowDelayTime < CurTime() then
				self.ThrowDelayTime = nil
				if SERVER then
					self:ThrowProjectile()
				end
				
				owner:SetAnimation(PLAYER_ATTACK1)
				self:SendWeaponAnim(ACT_VM_THROW)
			end
		elseif self.Owner:KeyDown(IN_ATTACK) then
			if SERVER then self:AddThrowPower(0.01) end
			if self:GetThrowPower() >= 100 then
				if self.ThrowDelay then
					self.ThrowDelayTime = CurTime() + self.ThrowDelay
					self:SendWeaponAnim(ACT_VM_PULLPIN)
				else
					if SERVER then 
						self:ThrowProjectile()
					end
					owner:SetAnimation(PLAYER_ATTACK1)
					self:EmitSound(self.ThrowSound)
					owner:DoAttackEvent()
					self:SendWeaponAnim(ACT_VM_THROW)
				end
			end
		elseif not self.Owner:KeyDown(IN_ATTACK) then
			if self:GetThrowPower() > 0 then
				if self.ThrowDelay then
					self.ThrowDelayTime = CurTime() + self.ThrowDelay
					self:SendWeaponAnim(ACT_VM_PULLPIN)
				else
					if SERVER then 
						self:ThrowProjectile()
					end
					owner:SetAnimation(PLAYER_ATTACK1)
					self:EmitSound(self.ThrowSound)
					owner:DoAttackEvent()
					self:SendWeaponAnim(ACT_VM_THROW)
				end
			end
		end
	else
		if self.NextThrow < CurTime() then
			self.CanThrow = true
			self.CanDrop = true
		end
	end
end

function SWEP:GetThrowPower()
	return self:GetDTFloat(0)
end

function SWEP:Reload()
	return false
end

if CLIENT then
	function SWEP:UpdateAmmoCounter()
		self.ItemCount = self.Owner:GetItemCount(self.Item)
	end
	
	function SWEP:DrawHUD()
		if not self:GetHolstered() then
		--	self:DrawCursor()
			self:DrawStock()
			
			if self:GetThrowPower() > 0 then
				self:DrawThrowMeter()
			end
		end
	end
	
	function SWEP:DrawStock()
		local w = ScrW()
		local h = ScrH()
		
		draw.SlantedRectHorizOffset(w - 250, h - 130, 250, 30, 15, Color(30, 30, 30, 210), Color(20, 20, 20, 255), 2, 2)
		draw.SimpleText(self.PrintName, "hidden18", w - 125, h - 125, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		
		draw.SlantedRectHorizOffset(w - 170, h - 100, 170, 30, 15, Color(30, 30, 30, 210), Color(20, 20, 20, 255), 2, 2)
		draw.SimpleText("Stock:", "hidden18", w - 150, h - 95, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		draw.SimpleText(self.ItemCount, "hidden18", w - 60, h - 95, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end
	
	function SWEP:DrawThrowMeter()
		local w = ScrW()
		local h = ScrH()
			
		local throwposx = w - 200
		local throwposy = h - 60
			
		local throwpow = self:GetThrowPower()
			
		draw.SlantedRectHorizOffset(throwposx, throwposy, 180, 30, 15, Color(30, 30, 30, 210), Color(20, 20, 20, 255), 2, 2)
		draw.SimpleText("Power", "hidden12", throwposx + 18, throwposy + 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
			
		draw.SlantedRectHoriz(throwposx + 20, throwposy + 16, 140, 10, 5, Color(0, 0, 0, 255), Color(0, 0, 0, 255))
		draw.SlantedRectHoriz(throwposx + 21, throwposy + 17, 140 * throwpow, 8, 5, Color(0, 100, 255, 255), Color(0, 0, 0, 255))
	end
end
