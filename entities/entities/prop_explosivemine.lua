ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/props_combine/combine_mine01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
		
		self.ArmTime = CurTime() + 2
	end
	
	function ENT:StartTouch(act)
		if self.ArmTime < CurTime() then
			if act:IsPlayer() or act:IsNPC() then
				util.BlastDamage(self, self.OwnerPl or self, self:GetPos(), 250, 15)
				
				local effectdata = EffectData()
				effectdata:SetStart(self:GetPos())
				effectdata:SetOrigin(self:GetPos())
				effectdata:SetScale(1)
				
				util.Effect("Explosion", effectdata)
				
				self:Remove()
			end
		end
	end
end

if CLIENT then
	function ENT:Initialize()
	end
	
	function ENT:OnRemove()
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
end