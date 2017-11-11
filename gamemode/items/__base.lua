ITEM.Name = "BASE"
ITEM.Mass = 1
ITEM.Description = "BASE"

ENT.Type = "anim"
ENT.Model = "models/error.mdl"

if CLIENT then
	ITEM.ToolTip = ""

	function ENT:Draw()
		self:DrawModel()
	end
end
