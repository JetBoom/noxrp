ENT.Type = "anim"
ENT.Base = "status__base_noxrp"


function ENT:GetIntensity()
	return self:GetDTFloat(1)
end