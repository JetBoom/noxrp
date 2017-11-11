AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.ItemTab = {}
end

function ENT:SetItem(item)
	item = item or Item("plant")
	
	self:SetModel("models/props/cs_italy/orange.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
		phys:SetMass(5)
	end
	
	self.Item = item
	
	self.Grow = CurTime() + 5
end

function ENT:Think()
	local ct = CurTime()
	
	if self.ItemTab then
		for k, item in pairs(self.ItemTab) do
			if not item.Entity and item.GrowTime then
				if item.GrowTime < CurTime() then
					item.GrowTime = nil
					
					self:CreateChildItem(k)
				end
			end
		end
	end
	
	if self.Grow then
		if self.Grow < CurTime() then
			self.Grow = nil
			
			self:SetModel("models/props/cs_militia/fern01.mdl")
			self:SetPos(self:GetPos() + Vector(0, 0, 30))
			self:SetAngles(Angle(0, 0, 0))
			self:SetModelScale(1, 0)
			self:SetupWorldItems()
		end
	end
	
	if self:GetDying() then
		if self:GetDieTime() < CurTime() then
			self:Remove()
		end
	end
	
	local pl = self:GetOwner()
	self:NextThink(ct)
	return true
end

function ENT:SetupWorldItems()
	for i = 1, self.Item:GetData().GrowNum do	
		self.ItemTab[i] = {
			GrowTime = CurTime() + 2
			//GrowTime = CurTime() + self.Item:GetData().GrowTime
			}
	end
end

function ENT:CreateChildItem(i)
	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()

	local randspot = Vector(0, 0, 0)
		randspot.x = math.random(-20, 20)
		randspot.y = math.random(-20, 20)
		randspot.z = math.random(0, 15)	
	
	local item = ents.Create(self.Item:GetData().GrowItem)
		item:SetPos(self:GetPos() + randspot)
	item:Spawn()
	item:SetData()
	item.WorldMine = self
		
	local phys = item:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
		
	self.ItemTab[i] = {
		Entity = item
	}
end

function ENT:OnChildPickedup(item)
	for k, tab in pairs(self.ItemTab) do
		if tab.Entity == item then
			table.remove(self.ItemTab, k)

			break
		end
	end
	
	if #self.ItemTab == 0 then
		self.ItemTab = nil
		self:SetDying(true)
		self:SetDieTime(CurTime() + 5)
	end
end
	
function ENT:OnRemove()
end

function ENT:GetVarsToSave()
	local tab = {
		["Item"] = self.Item
	}
	
	return tab
end

function ENT:SetVarsToLoad(tab)
	if tab.Item then
		self.Item = RecreateItem(tab.Item)
	end
end