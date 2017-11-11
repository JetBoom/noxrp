AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ShouldSave = false

function ENT:Initialize()
	self:DrawShadow(false)
	
	if self.Model then
		self:SetModel(self.Model)
	else
		self:SetNoDraw(true)
	end
end

function ENT:Think()
end