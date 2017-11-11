ENT.Type = "anim"
ENT.IsProjectile = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Damage")
end
