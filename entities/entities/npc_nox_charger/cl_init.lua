include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	self:HandleOverheadText()
end