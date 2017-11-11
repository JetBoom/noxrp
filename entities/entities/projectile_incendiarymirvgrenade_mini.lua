ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		self:SetModelScale(0.2, 0)
		
		self:SetMoveType(MOVETYPE_VPHYSICS)
		
		self:PhysicsInitSphere(2)
		self.FireTime = CurTime() + 2.5
	end
	
	function ENT:Think()
		if self:WaterLevel() > 0 then
			local data = EffectData()
				data:SetOrigin(self:GetPos())
				data:SetMagnitude(0.9)
			util.Effect("genericrefractring", data)
				
			local effect = EffectData()
				effect:SetOrigin(self:GetPos())
			util.Effect("Explosion", effect)
				
			self:EmitSound("weapons/smokegrenade/sg_explode.wav")
				
			local firefield = ents.Create("spot_incendiary")
			if firefield then
				firefield:SetPos(self:GetPos())
				firefield:SetOwner(self:GetOwner())
				firefield:Spawn()
			end
				
			self:Remove()
		end
		
		if self.Data then
			local data = self.Data
			self.Data = nil
			
			local vel = data.OurOldVelocity * 0.3
			self:SetVelocity(vel)
			self:SetLocalAngularVelocity(self:GetLocalAngularVelocity() * 0.6)
			
			local data = EffectData()
				data:SetOrigin(self:GetPos())
				data:SetMagnitude(0.9)
			util.Effect("genericrefractring", data)
				
			local effect = EffectData()
				effect:SetOrigin(self:GetPos())
			util.Effect("Explosion", effect)
				
			self:EmitSound("weapons/smokegrenade/sg_explode.wav")
				
			local firefield = ents.Create("spot_incendiary")
			if firefield then
				firefield:SetPos(self:GetPos())
				firefield:SetOwner(self:GetOwner())
				firefield:Spawn()
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
		
		self:SetColor(Color(255, 150, 0))
	end
	
	function ENT:Think()
		if not self.Emitter then
			self.Emitter = ParticleEmitter(self:GetPos(), false)
		end
		
		self.Emitter:SetPos(self:GetPos())
		
		local smoke = self.Emitter:Add("particles/smokey", self:GetPos() + self:GetUp() * 6)
			smoke:SetVelocity(Vector(math.Rand(-1, 1),math.Rand(-1, 1), 0) * 2)
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