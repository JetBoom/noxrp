ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_eq_smokegrenade.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self.SmokeTime = CurTime() + 2.5
		self.Smoked = false
		self.DieTime = CurTime() + 5
		self.HitGround = false
	end
	
	function ENT:Think()
		if self.SmokeTime < CurTime() and not self.Smoked then
			self.Smoked = true
			
			local infosmoke = ents.Create("point_smoke")
				infosmoke:SetPos(self:GetPos())
				infosmoke:Spawn()
				
				infosmoke:StartSmoke(1)
			
			self:EmitSound("weapons/smokegrenade/sg_explode.wav")
			
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
			
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(false)
			end
		end
		
		if self.Data then
			local data = self.Data
			self.Data = nil
			
			self:SetLocalAngularVelocity(self:GetLocalAngularVelocity() * 0.6)
			if data.Speed > 50 then
				self:EmitSound("weapons/smokegrenade/grenade_hit1.wav")
			end
		end
		
		if self.DieTime < CurTime() then
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