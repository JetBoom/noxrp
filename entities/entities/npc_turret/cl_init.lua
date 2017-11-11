include("shared.lua")

function ENT:Initialize()
end
	
function ENT:OnRemove()
end
	
local laser = Material("effects/laser1")
local glow = Material("sprites/glow04_noz")
function ENT:Draw()
	self:DrawModel()
end