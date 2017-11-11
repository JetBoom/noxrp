ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/rockcliff01k.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(true)
			phys:Wake()
		end
		
		self.DieTime = CurTime() + 10
	end
	
	function ENT:Think()
		if self.DieTime <= CurTime() then
			self:Remove()
		end
	end
	
	function ENT:GetVarsToSave()
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end