AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("construction.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:SSetHolstered(bool)
end

function SWEP:UpdateDurability(amt)
	local item = self.Owner:GetItemByID(self:GetItemID())
	item:GetData().Durability = (item:GetData().Durability or 0) + amt
	self:GetOwner():UpdateInventoryItem(item)
		
	self:SetDurability(self:GetDurability() + amt)
end

function SWEP:SetNewDurability(amt)
	local item = self.Owner:GetItemByID(self:GetItemID())
	item:GetData().Durability = amt
	self:GetOwner():UpdateInventoryItem(item)
		
	self:SetDurability(amt)
end

function SWEP:SetMaxDurability(amt)
	local item = self.Owner:GetItemByID(self:GetItemID())
	item:GetData().Durability = math.min(item:GetData().Durability, math.max(amt, 0))
	item:GetData().MaxDurability = math.max(amt, 0)
	self:GetOwner():UpdateInventoryItem(item)
end

function SWEP:GetMaxDurability()
	return self.Owner:GetItemByID(self:GetItemID()):GetData().MaxDurability
end
	
function SWEP:ToggleHolstered(bool)
	self:SetHolstered(bool)
	
	if bool then
		self:SetHoldType("normal")
		self:CallOnClient("StartHolster", self.HolsterHoldType)
	else
		self:SetHoldType(self.HoldType)
		self:CallOnClient("EndHolster")
		
		self:SetNextPrimaryAttack(CurTime() + self.HolsterTime)
		self:SetNextSecondaryAttack(CurTime() + self.HolsterTime)
	end
	
	if self.HolsterSound then
		self:EmitSound("physics/metal/weapon_impact_soft"..math.random(1,3)..".wav")
	end
end

function SWEP:SetNewSlot(slot)
	self.Slot = slot
	self:CallOnClient("SetNewSlot", tostring(slot))
end