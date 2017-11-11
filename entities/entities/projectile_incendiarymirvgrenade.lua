ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_eq_smokegrenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self.FireTime = CurTime() + 2.5
	end
	
	function ENT:Think()
		if self.Data then
			local data = self.Data
			self.Data = nil
			
			local vel = data.OurOldVelocity * 0.3
			self:SetVelocity(vel)
			self:SetLocalAngularVelocity(self:GetLocalAngularVelocity() * 0.6)
		end
		
		if self.FireTime < CurTime() or self:WaterLevel() > 0 then
			for i = 1, 4 do
				local dir = Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(200, 250))
						
				local proj = ents.Create("projectile_incendiarymirvgrenade_mini")
					proj:SetPos(self:GetPos())
					proj:Spawn()
						
					local phys = proj:GetPhysicsObject()
					if phys:IsValid() then
						phys:Wake()
						phys:SetVelocityInstantaneous(dir)
					end
			end
				
			local data = EffectData()
				data:SetOrigin(self:GetPos())
				data:SetMagnitude(0.9)
			util.Effect("genericrefractring", data)
				
			local effect = EffectData()
				effect:SetOrigin(self:GetPos())
			util.Effect("Explosion", effect)
				
			self:EmitSound(Sound("WeaponFrag.Throw"))
				
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