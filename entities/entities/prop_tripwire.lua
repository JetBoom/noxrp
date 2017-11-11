ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/TrapPropeller_Lever.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
		
		self.DieTime = CurTime() + 60 * 5 --5 minute lifetime
		self.LastAlert = 0
	end
	
	function ENT:Think()
		local data = {}
			data.start = self:GetPos() + self:GetRight() * 5
			data.endpos = data.start + self:GetRight() * 500
			data.filter = self
			
		local tr = util.TraceLine(data)
		if tr.Entity:IsValid() and self.LastAlert < CurTime() then
			self.LastAlert = CurTime() + 1
			
			self:EmitSound("buttons/blip1.wav")
			
			if self.m_Creator then
				self.m_Creator:SendNotification("A tripwire went off!", 4, Color(100, 150, 255), nil, 1)
			end
		end
			
		if self.DieTime < CurTime() then
			self:Remove()
		end
	end
	
	function ENT:OnTakeDamage(cdmg)
		self:Remove()
	end
end

if CLIENT then
	local laser = Material("cable/redlaser")
	function ENT:Draw()
		self:DrawModel()

		local data = {}
			data.start = self:GetPos() + self:GetRight() * 5
			data.endpos = data.start + self:GetRight() * 500
			data.filter = self
		
		local tr = util.TraceLine(data)
		
		render.SetMaterial(laser)
		render.DrawBeam(data.start, tr.HitPos, 0.2, 0, 1, Color(255, 255, 255, 0))
	end
	
	function ENT:Think()
		if not self.Emitter then
			self.Emitter = ParticleEmitter(self:GetPos(), false)
		end
		
		self.Emitter:SetPos(self:GetPos())
	end
	
	function ENT:OnRemove()
		self.Emitter:Finish()
	end
end