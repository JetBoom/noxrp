ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "EntityAppliedTo")
	
	self:NetworkVar("Float", 0, "HackTime")
end