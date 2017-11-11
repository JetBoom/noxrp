ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/weapons/w_knife_t.mdl")
		--self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitSphere(2)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(true)
			phys:Wake()
		end
		
		self.DieTime = CurTime() + 10
		self.Stuck = false
		
		self.LastPosition = self.LastPosition or self:GetPos()
	end
	
	function ENT:Think()
		if self.DieTime < CurTime() then
			self:Remove()
		end
		
		if self:WaterLevel() > 2 then
			self:Remove()
		end
		
		if not self.Stuck then
			local owner = self:GetOwner()
			local curpos = self:GetPos()
			
			local data = {}
				data.start = self.LastPosition
				data.endpos = curpos
				data.filter = owner:GetAttackFilter()
				
			table.insert(data.filter, self)
				
			local tr = util.TraceLine(data)
			
			if not tr.Hit then
				self.LastPosition = curpos
			else
				self.Data = tr
			end
		
			if self.Data then
				local data = self.Data
				self.Data = nil
				
				self.DieTime = CurTime() + 5
				self.Stuck = true
				
				if data.Entity:IsPlayer() or data.Entity:IsNPC() or data.Entity:IsNextBot() then
					self:ImpaleEntity(data.Entity)
				elseif data.HitWorld then
					self:ImpaleWall(data)
				end
			end
			
			if self.Collision then
				local data = self.Collision
				self.Data = nil
			
				self.DieTime = CurTime() + 5
				self.Stuck = true
				
				if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() or data.HitEntity:IsNextBot() then
					self:ImpaleEntity(data.HitEntity)
				else
					self:ImpaleWall(data)
				end
			end
		end
	end
	
	function ENT:ImpaleEntity(ent)
		local owner = self:GetOwner()
		ent:GiveStatus("bleeding")
		
		ent:TakeSpecialDamage(5, owner, self, DMG_SLASH, data.HitPos)
					
		self:SetPos(data.HitPos + self:GetForward() * 10)
		self:EmitSound("physics/flesh/flesh_impact_bullet1.wav")
					
		self:Remove()
	end
	
	function ENT:ImpaleWall(data)
		local owner = self:GetOwner()
		util.Decal("ManhackCut", data.HitPos - data.HitNormal, data.HitPos + data.HitNormal)
		self:EmitSound("physics/metal/sawblade_stick"..math.random(3)..".wav")
					
		if owner:GetStat(STAT_STRENGTH) >= 10 then
			self:SetPos(data.HitPos - data.OurOldVelocity:GetNormalized() * 10)
			self:SetAngles(data.OurOldVelocity:GetNormalized():Angle() + Angle(0, 90, 90))
			self:GetPhysicsObject():EnableMotion(false)
			self:SetVelocity(self:GetVelocity() * 0)
		end
	end
	
	function ENT:PhysicsCollide(data)
		self.Collision = data
		self:NextThink(CurTime())
	end
end

function ENT:OnRemove()
end

if CLIENT then
	function ENT:Initialize()
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Think()
	end
	
	function ENT:OnRemove()
	end
end