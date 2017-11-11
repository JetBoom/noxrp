ENT.Type = "anim"
ENT.Base = "status__base_noxrp"

function ENT:GetForcing()
	return self:GetDTEntity(0)
end
