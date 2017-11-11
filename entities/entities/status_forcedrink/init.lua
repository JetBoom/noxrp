AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ShouldDrawShadow = false

function ENT:PlayerSet(pPlayer, bExists)
	self:SetDie(3)
end

function ENT:Think()
	local ct = CurTime()
	local owner = self:GetOwner()

	if self:GetDTFloat(0) <= CurTime() then
		self:Remove()
	end

	local dist = owner:GetPos():Distance(self:GetForcing():GetPos())

	--If they get too far then stop trying to force them
	if dist > 150 then
		owner:ChatPrint("They're too far away!")
		self.OnlyRemove = true
		self:Remove()
	end

	--If the owner presses attack either, then also cancel it
	if owner:KeyDown(IN_ATTACK) then
		self.OnlyRemove = true
		self:Remove()
	end

	self:NextThink(ct)
	return true
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	owner[self:GetClass()] = nil

	if self.OnlyRemove then return end

	local target = self:GetForcing()

	--Force them to drink everything in it
	for _, item in pairs(self.Item:GetContainer()) do
		if item.OnReagentDrink then
			item:OnReagentDrink(target)
		end
	end

	--Empty the container
	self.Item:EmptyItems()
end

function ENT:SetForcing(pl)
	self:SetDTEntity(0, pl)
end

function ENT:SetItem(item)
	self.Item = item
end