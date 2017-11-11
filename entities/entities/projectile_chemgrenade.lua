ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_grenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self.DieTime = CurTime() + 2.5
	end
	
	function ENT:Think()
		if self.DieTime < CurTime() then
			CheckChemistryRecipe(self)
			
			self:Remove()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Think()
		if not self.Emitter then
			self.Emitter = ParticleEmitter(self:GetPos(), false)
		end
		
		self.Emitter:SetPos(self:GetPos())
		
		local smoke = self.Emitter:Add("particles/smokey", self:GetPos() + self:GetUp() * 8)
			smoke:SetVelocity(Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) * 2)
			smoke:SetDieTime(math.Rand(0.7, 0.9))
			smoke:SetStartAlpha(200)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(1)
			smoke:SetEndSize(0.5)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-5, 5))
			smoke:SetColor(255, 255, 255)
			smoke:SetGravity(Vector(0, 0, 50))
			smoke:SetColor(150, 150, 150)
	end
	
	function ENT:OnRemove()
		self.Emitter:Finish()
	end
end