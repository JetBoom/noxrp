include("shared.lua")
ENT.Name = "Container"

function ENT:Think()
end

function ENT:Initialize()
	local owner = self:GetOwner()
end

function ENT:Draw()
	if self then
		self:DrawModel()
	end
end
