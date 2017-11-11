ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_eq_fraggrenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
	--	self:PhysicsInitSphere(4)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self.DieTime = CurTime() + 2.5
	end
	
	function ENT:Think()
		if self.Data then
			local data = self.Data
			self.Data = nil
			
			self:SetLocalAngularVelocity(self:GetLocalAngularVelocity() * 0.1)
			self:SetLocalVelocity(Vector(0, 0, 0))
			if data.Speed > 50 then
				self:EmitSound("weapons/hegrenade/he_bounce-1.wav")
			end
		end
		
		if self.DieTime < CurTime() then
			util.BlastDamage(self, self:GetOwner(), self:GetPos(), 300, 70)
			
			local effect = EffectData()
				effect:SetOrigin(self:GetPos())
			util.Effect("Explosion", effect)
			
			self:EmitSound("weapons/hegrenade/explode"..math.random(3, 5)..".wav")
			self:Remove()
		end
	end
	
	function ENT:PhysicsCollide(data)
		self.Data = data
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
		
		local smoke = self.Emitter:Add("particles/smokey", self:GetPos()+self:GetUp()*8)
			smoke:SetVelocity(Vector(math.Rand(-1,1),math.Rand(-1,1),0)*2)
			smoke:SetDieTime(math.Rand(0.7,0.9))
			smoke:SetStartAlpha(200)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(1)
			smoke:SetEndSize(0.5)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-5, 5))
			smoke:SetColor(255, 255, 255)
			smoke:SetGravity(Vector(0,0,50))
			smoke:SetColor(150,150,150)
	end
	
	function ENT:OnRemove()
		self.Emitter:Finish()
	end
end