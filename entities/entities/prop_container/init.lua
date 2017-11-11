AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	--models/nox_pouch.mdl
	self:SetModel("models/props_c17/briefcase001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.Inventory = {}
	self.Openers = {}
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
	end
	
	self:SetDieTime(30)
end

function ENT:AddLocalItem(tbl)
	for k,v in pairs(self.Inventory) do
		if v:GetDataName() == tbl:GetDataName() then
			if table.Compare(tbl:GetData(), v:GetData()) then
				v:SetAmount(v:GetAmount() + tbl:GetAmount())
				return
			end
		end
	end
	
	table.insert(self.Inventory, tbl)
end

function ENT:OnTakeItem(pl, item, amt)
	local sync = false
	
	for k, v in pairs(self.Inventory) do
		if v:GetDataName() == item then
			if pl:CanTakeItem(v, amt) then
				pl:InventoryAdd(v)
				sync = true
				
				table.remove(self.Inventory, k)
			end
		end
	end
	
--	pl.c_OpenedInventory:CloseAllOpeners()
	self:SelfCheck()
	
	if sync then
		self:SyncToOpeners()
	end
end

function ENT:SelfCheck()
	if #self.Inventory == 0 then
		self:CloseAllOpeners()
	end
end

function ENT:SyncToOpeners()
	net.Start("sendOtherInventory")
		net.WriteTable(self.Inventory)
	net.Send(self:GetOpenedBy())
end

function ENT:CloseAllOpeners()
	for _, pl in pairs(self:GetOpenedBy()) do
		CloseInventory(pl)
	end
end

function ENT:Use(pl)
	if pl:IsPlayer() then
		self:AddOpener(pl)
		pl:OpenOtherInventory(self)
	end
end