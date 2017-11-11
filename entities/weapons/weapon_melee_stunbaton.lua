if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Stunbaton"
	SWEP.PrintName2 = "Light Melee"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.Icon = "!"
	SWEP.Font = "dmKillIcons"
	
	SWEP.PosY = 2
	
	SWEP.VMGlow = 0
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_melee_base"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 8
SWEP.Range = 45

SWEP.HoldType = "melee"
SWEP.DamageType = DMG_CLUB

SWEP.Item = "stunbaton"
SWEP.WeaponType = WEAPON_TYPE_MELEE
SWEP.Electrified = false

if SERVER then
	function SWEP:OnHitEntity(trace, damage)
		local ent = trace.Entity

		if self.Electrified then
			ent:TakeSpecialDamage(damage, self.Owner, self, DMG_SHOCK, trace.HitPos)
			
			if ent:IsPlayer() then
				ent:GiveStatus("knockdown", 2)
			end
			
			local destroyedall = self.Owner:DestroyItemByName("battery", 1)
			if destroyedall then
				self.Electrified = false
				self:CallOnClient("StopElectrified")
			end
		else
			ent:TakeSpecialDamage(damage, self.Owner, self, self.DamageType, trace.HitPos)
		end
		
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		end
	end
end

function SWEP:SecondaryAttack()
	if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
		self:SetNextPrimaryFire(CurTime() + 1)
		
		self:ToggleElectric()
	end
end

function SWEP:ToggleElectric()
	local bat = self.Owner:GetItemByRef("battery")
	if bat then
		self:EmitSound("ambient/energy/zap1.wav")

		if SERVER then
			self.Electrified = not self.Electrified
			
			if self.Electrified then
				self:CallOnClient("StartElectrified")
			else
				self:CallOnClient("StopElectrified")
			end
		end
	end
end

if CLIENT then
	function SWEP:StartElectrified()
		self.Electrified = true
		local emitter = ParticleEmitter(self:GetPos())
		
		local att = self:GetAttachment(1)
		if att then
			for i = 1, 8 do
				local particle = emitter:Add("effects/spark", att.Pos + VectorRand():GetNormal() * 2)
					particle:SetDieTime(math.Rand(0.2, 0.3))
					particle:SetVelocity(VectorRand() * 50)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(255)
					particle:SetStartSize(math.Rand(2, 4))
					particle:SetEndSize(0)
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-20, 20))
					particle:SetColor(255, 255, 255)
					particle:SetAirResistance(200)
					particle:SetGravity(Vector(0, 0, -50))
			end
		end
		
		self:DoVMSpark(emitter)
		
		emitter:Finish()
	end
	
	function SWEP:StopElectrified()
		self.Electrified = false
		
		local emitter = ParticleEmitter(self:GetPos())
		
		local att = self:GetAttachment(1)
		if att then
			for i = 1, 8 do
				local particle = emitter:Add("effects/spark", att.Pos + VectorRand():GetNormal() * 2)
					particle:SetDieTime(math.Rand(0.2, 0.3))
					particle:SetVelocity(VectorRand() * 50)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(255)
					particle:SetStartSize(math.Rand(2, 4))
					particle:SetEndSize(0)
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-20, 20))
					particle:SetColor(255, 255, 255)
					particle:SetAirResistance(200)
					particle:SetGravity(Vector(0, 0, -50))
			end
		end
		
		self:DoVMSpark(emitter)
		
		emitter:Finish()
	end
	
	function SWEP:DoVMSpark(emitter)
		if not self.Owner:GetViewModel():GetNoDraw() then
			local bonepos, boneang = self.Owner:GetViewModel():GetBonePosition(23)
			if bonepos then
				local pos = bonepos + boneang:Up() * -15 + boneang:Right() * -5 + boneang:Forward() * 0
					
				for i = 1, 8 do
					local particle = emitter:Add("effects/spark", pos)
						particle:SetDieTime(math.Rand(0.2, 0.3))
						particle:SetVelocity(VectorRand() * 50)
						particle:SetStartAlpha(255)
						particle:SetEndAlpha(255)
						particle:SetStartSize(math.Rand(4, 6))
						particle:SetEndSize(0)
						particle:SetRoll(math.Rand(0, 360))
						particle:SetRollDelta(math.Rand(-20, 20))
						particle:SetColor(255, 255, 255)
						particle:SetAirResistance(200)
						particle:SetGravity(Vector(0, 0, -50))
				end
			end
		end
	end
	
	local matGlow = Material("sprites/glow04_noz")
	function SWEP:DrawWorldModel()
		if not self:GetHolstered() then
			self:Cons_DrawWorldModel()
		end
		
		if self.Electrified then
			local att = self:GetAttachment(1)
			if att then
				render.SetMaterial(matGlow)
				local siz = math.Rand(8, 10)
				render.DrawSprite(att.Pos, siz, siz, Color(255, 255, 255))
			end
		end
	end
	
	function SWEP:ViewModelDrawn(vm)
		self:Cons_ViewModelDrawn()
		
		if self.Electrified then
			self.VMGlow = math.Approach(self.VMGlow, 1, FrameTime() * 10)
		elseif self.VMGlow then
			self.VMGlow = math.Approach(self.VMGlow, 0, FrameTime() * 10)
		end
		
		if self.VMGlow > 0 then
			local bonepos, boneang = vm:GetBonePosition(23)
			if bonepos then
				local pos = bonepos + boneang:Up() * -15 + boneang:Right() * 1.9 + boneang:Forward() * 3.9
				render.SetMaterial(matGlow)
				local siz = math.Rand(16, 18) * self.VMGlow
				render.DrawSprite(pos, siz, siz, Color(255, 255, 255))
			end
		end
	end
end
	
	
	
	
	