ENT.Type 			= "anim"

util.PrecacheSound("weapons/c4/c4_explode1.wav")
util.PrecacheSound("weapons/c4/c4_exp_deb2.wav")

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Diffuse")
end
