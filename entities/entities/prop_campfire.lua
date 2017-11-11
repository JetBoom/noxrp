ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/noxrp/camp_fire/deployed.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
		
		local ent = ents.Create("env_fire")
		if ent:IsValid() then
			ent:SetPos(self:GetPos())
			ent:SetKeyValue("health", 10)
			ent:SetKeyValue("firesize", 32)
			ent:SetKeyValue("damagescale", 4)
			ent:SetKeyValue("spawnflags", "1")
			ent:Spawn()
			ent:Fire("Enable", "", 0)
			ent:Fire("StartFire", "", 0)
			
			self.FireEnt = ent
		end
		
		self.LifeTime = CurTime() + 180
	end
	
	function ENT:Think()
		if self.LifeTime < CurTime() then
			self:Remove()
		end
	end
	
	function ENT:OnRemove()
		self.FireEnt:Fire("kill", "", 0)
	end
end

if CLIENT then
	function ENT:Initialize()
		self.AmbientSound = CreateSound(self, "ambient/fire/fire_small_loop2.wav")
	end
	
	function ENT:Think()
		local emitter = ParticleEmitter(self:GetPos())
		
		local particle = emitter:Add("effects/fire_cloud1", self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)))
			particle:SetVelocity(Vector(math.Rand(-0.2, 0.2),math.Rand(-0.2, 0.2),math.Rand(0, 2)) * 120)
			particle:SetDieTime(0.75)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(20)
			particle:SetStartSize(2)
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-5, 5))
			particle:SetColor(255, 255, 255)
			particle:SetGravity(Vector(0,0,-600))
			particle:SetCollide(true)
			
		local particle = emitter:Add("effects/fire_cloud1", self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)))
			particle:SetVelocity(Vector(math.Rand(-0.2, 0.2),math.Rand(-0.2, 0.2),math.Rand(0, 2)) * 120)
			particle:SetDieTime(0.75)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(20)
			particle:SetStartSize(1)
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-5, 5))
			particle:SetColor(255, 255, 255)
			particle:SetGravity(Vector(0, 0, -600))
			particle:SetCollide(true)
		
		local dlight = DynamicLight(self:EntIndex())
		if ( dlight ) then
			dlight.Pos = self:GetPos() + Vector(0, 0, 10)
			dlight.r = 255
			dlight.g = 30
			dlight.b = 0
			dlight.Brightness = 1
			dlight.Decay = 64
			dlight.Size = 512
			dlight.DieTime = CurTime() + 1
		end
		
		self.AmbientSound:PlayEx(0.8, 100 + math.sin(RealTime()))
	end
	
	function ENT:OnRemove()
		self.AmbientSound:Stop()
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
end