ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/props_junk/flare.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
	--	self:PhysicsInitSphere(2)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(true)
			phys:Wake()
		end
		
		self.Stick = false
		
		self.DieTime = CurTime() + 30
	end
	
	function ENT:Think()
		if self.DieTime < CurTime() then
			self:Remove()
		end
		
		if self:WaterLevel() > 2 then
			self:Remove()
		end
	end
	
	function ENT:Touch(activator)
		if string.find(activator:GetClass(),"zombie") and not activator:IsOnFire() then
			activator:Ignite(5)
		end
	end
end

if CLIENT then
	function ENT:Initialize()
		self.AmbientSound = CreateSound(self, "ambient/fire/fire_small_loop2.wav")
		self.AmbientSound:PlayEx(0.5,100)
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Think()
		local emitter = ParticleEmitter(self:GetPos())
		local pos = self:GetPos() + self:GetUp() * 5
		
		local smoke = emitter:Add("particles/smokey", pos)
			smoke:SetVelocity(Vector(math.Rand(-1,1),math.Rand(-1,1),0)*5)
			smoke:SetDieTime(math.Rand(1,1.8))
			smoke:SetStartAlpha(200)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(4)
			smoke:SetEndSize(4)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-5, 5))
			smoke:SetColor(255, 255, 255)
			smoke:SetGravity(Vector(0,0,100))
			smoke:SetLighting(true)
		
		for i = 1, 3 do
			local particle = emitter:Add("effects/fire_cloud1", pos + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)))
				particle:SetVelocity(Vector(math.Rand(-4,4),math.Rand(-4,4),math.Rand(0,5)) * 2)
				particle:SetDieTime(0.75)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(20)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-5, 5))
				particle:SetColor(255, 255, 255)
				particle:SetGravity(Vector(0,0,-200))
				particle:SetCollide(true)
				
			local particle = emitter:Add("effects/fire_cloud1", pos+Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1)))
				particle:SetVelocity(Vector(math.Rand(-4,4),math.Rand(-4,4),math.Rand(0,5)))
				particle:SetDieTime(0.75)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(20)
				particle:SetStartSize(2)
				particle:SetEndSize(0)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-5, 5))
				particle:SetColor(255, 255, 255)
				particle:SetGravity(Vector(0,0,200))
				particle:SetCollide(true)
		end
				
			local particle = emitter:Add("effects/fire_cloud1", pos)
				particle:SetDieTime(0.5)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(20)
				particle:SetStartSize(3)
				particle:SetEndSize(1)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-5, 5))
				particle:SetColor(255, 255, 255)
				
		emitter:Finish()
		
		local dlight = DynamicLight(self:EntIndex())
		if ( dlight ) then
			dlight.Pos = self:GetPos()+Vector(0,0,2)
			dlight.r = 255
			dlight.g = 30
			dlight.b = 0
			dlight.Brightness = 3
			dlight.Decay = 50
			dlight.Size = 300
			dlight.DieTime = CurTime() + 1
		end
	end
	
	function ENT:OnRemove()
		self.AmbientSound:Stop()
	end
end