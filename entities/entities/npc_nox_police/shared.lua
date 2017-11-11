ENT.Base = "npc_nox_base"
ENT.NextBot			= true

ENT.CleanName = "Cop"

function ENT:GetShootPos()
	return Vector(0, 0, 60) + self:GetForward() * 2
end