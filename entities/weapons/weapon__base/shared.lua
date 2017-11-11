/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/


SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Sound = ""
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Burst = false

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.5

SWEP.HoldType = "pistol"
SWEP.HolsterHoldType = "normal"

SWEP.HolsterTime = 0.5
SWEP.NextLerpTime = 0

--Moddable Parts--
SWEP.Primary.Damage = 20
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Cone = 0.36

SWEP.UseHands = true

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.DamageType = DMG_BULLET

SWEP.WeaponInfo = {}

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "ItemID")
	
	self:NetworkVar("Float", 0, "Durability")
	
	self:NetworkVar("Bool", 0, "Holstered")
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(2)
	
	
	self.m_Primary = {}
	if not self.Primary.Damage and self.Primary.DamageMin and self.Primary.DamageMax then
		self.m_Primary.DamageMin = self.Primary.DamageMin
		self.m_Primary.DamageMax = self.Primary.DamageMax
	else
		self.m_Primary.Damage = self.Primary.Damage
	end
	self.m_Primary.NumShots = self.Primary.NumShots
	self.m_Primary.Delay = self.Primary.Delay
	self.m_Cone = self.Cone
	
	-- other initialize code goes here

	if CLIENT then
	--	self:SetupClientModels()
		
		if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
			self.Owner.LoadoutEffect:WeaponInitialize(self)
		end
	end
end

function SWEP:Deploy()
	if self.DrawSound then
		for k,v in pairs(self.DrawSound) do
			timer.Simple(v[2],function() self.Weapon:EmitSound(v[1]) end)
		end	
	end
	
	self.Owner:GetViewModel():SetModel(self.ViewModel)
	
	return true	
end
	
function SWEP:SecondaryAttack()
	return false
end

function SWEP:OnRemove()
	if CLIENT then
		if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
			self.Owner.LoadoutEffect:WeaponRemove(self.Slot)
			self:Holster()
		end
	end
end
	
function SWEP:Holster()
	if self:CanHolster() then
		if CLIENT and IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		end
		
		return true
	else
		return false
	end
end

function SWEP:CanHolster()
	local ifhol = (CurTime() > self:GetReloadEnd()) and (CurTime() > self:GetNextPrimaryFire())
	if ifhol then
		if CLIENT then
			self:HolsterEffect()
		end
		return true
	end
	return false
end

function SWEP:OnRemove()
	self:Holster()
end

