ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "DieTime")
	
	self:NetworkVar("Bool", 0, "Dying")
end