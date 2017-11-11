ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_eq_smokegrenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self.ShieldTime = CurTime() + 2.5
	end
	
	function ENT:Think()
		if self.Data then
			local data = self.Data
			self.Data = nil
			
			local vel = data.OurOldVelocity * 0.3
			self:SetVelocity(vel)
			self:SetLocalAngularVelocity(self:GetLocalAngularVelocity() * 0.6)
		end
		
		if self.ShieldTime < CurTime() then
			local shield = ents.Create("prop_combinebarricade")
			if shield:IsValid() then
				shield:SetPos(self:GetPos())
				shield:SetAngles(self.DeployNormal:Angle())
				shield:Spawn()
				
				local hei = shield:OBBCenter().z - shield:OBBMins().z
				shield:SetPos(shield:GetPos() + Vector(0, 0, hei + 2))
			end
			
			self:Remove()
		end
	end
	
	function ENT:PhysicsCollide(phys)
		self.Data = phys
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Think()
	end
	
	function ENT:OnRemove()
	end
end