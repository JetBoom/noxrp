include("shared.lua")

local base = Material("noxrp/statusicons/status_onfire.png")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))

	local owner = self:GetOwner()
	if owner:IsValid() then
		owner[self:GetClass()] = self
	end
	
	self.Created = CurTime()
	self.NextBurn = CurTime()
end

function ENT:Draw()
end
