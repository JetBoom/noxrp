AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_c4_planted.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self:DrawShadow(false)
end

function ENT:SetItem(item)
	self.Item = item
end

function ENT:GetItem()
	return self.Item
end

function ENT:Think()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:GetVarsToSave()
	local tab = {
		["Item"] = self:GetItem(),
		["Angles"] = self.ItemAngles
	}
	
	return tab
end

function ENT:SetVarsToLoad(tab)
	if tab.Item then
		local item = Item(tab.Item.DataName)
			item:SetAmount(tab.Item.Amount)
			item:SetItemName(tab.Item.Name)
			item:SetData(tab.Item.Data)
			
		self:SetItem(item)
	end
	
	if tab.Angles then
		self.ItemAngles = tab.Angles
	end
end