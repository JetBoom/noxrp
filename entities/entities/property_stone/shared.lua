ENT.Type = "anim"

util.PrecacheModel("models/props_c17/gravestone001a.mdl")

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "PropertyOwner")
	self:NetworkVar("String", 1, "PropertyName")
	
	self:NetworkVar("Int", 0, "Price")
	
	self:NetworkVar("Float", 0, "DecayTime")
end