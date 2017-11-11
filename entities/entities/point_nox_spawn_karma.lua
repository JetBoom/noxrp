ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:DrawShadow(false)
		self:SetModel("models/props/cs_italy/orange.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end
	
	function ENT:GetVarsToSave()
	end
	
	function ENT:SetVarsToLoad(tab)
	end
end

if CLIENT then
	function ENT:Draw()
		if not LocalPlayer():IsSuperAdmin() then return end
		
		self:DrawModel()
	end
	
	function ENT:Display(alpha, posx, posy)
		draw.SimpleTextOutlined("[point_nox_spawn] Player Spawn", "hidden14", posx, posy, Color(255, 255, 255, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255 * alpha))
	end
end