ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel("models/props_wasteland/antlionhill.mdl")
	--	self:SetModelScale(0.5, 0)
		self:SetTrigger(true)
	--	self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitBox(Vector(-100, -100, 0), Vector(100, 100, 90))
		self:SetCollisionBounds(Vector(-100, -100, 0), Vector(100, 100, 90))
	--	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
		
		self.HiveHealth = 800
		self.MaxHiveHealth = 800
		
		self.m_Children = {}
		self.m_MinSpawnRadius = 180
		self.m_SpawnRadius = 300
		self.m_MoveRadius = 1000
		self.m_SpawnTime = 10
		
		self.NextSpawn = CurTime() + 0
		
		self:SetCustomCollisionCheck(true)
	end
	
	function ENT:OnTakeDamage(cdmg)
		self.HiveHealth = self.HiveHealth - cdmg:GetDamage()
		
		if self.HiveHealth < 0 then
			self:Remove()
		else
			self:AlertChildrenDamage(cdmg)
		end
	end
	
	function ENT:AlertChildrenDamage(cdmg)
		for _, child in pairs(self:GetNPCChildren()) do
			child:AlertHiveIsDamaged(cdmg)
		end
	end

	function ENT:SetRadius(radius)
		self.m_SpawnRadius = radius
	end

	function ENT:SetSpawnTime(timet)
		self.m_SpawnTime = timet
	end
	
	function ENT:GetNPCChildren()
		return self.m_Children
	end
	
	function ENT:Repair(amount)
		self.HiveHealth = math.min(self.HiveHealth + 15, self.MaxHiveHealth)
	end

	function ENT:Think()
		for k,v in pairs(self.m_Children) do
			if not v:IsValid() then
				self.NextSpawn = CurTime() + self.m_SpawnTime
				table.remove(self.m_Children, k)
				
				k = k - 1
			end
		end
		
		if self.NextSpawn < CurTime() and (#self.m_Children < 10) then
			self.NextSpawn = CurTime() + self.m_SpawnTime
			
			local pos

			local ent = ents.Create("npc_nox_charger")
			if self.m_SpawnRadius == 0 then
				pos = self:GetPos()
			else
				pos = self:GetPos() + Vector(math.cos(math.random(0, math.pi)) * math.random(self.m_MinSpawnRadius, self.m_SpawnRadius), math.sin(math.random(0, math.pi)) * math.random(self.m_MinSpawnRadius, self.m_SpawnRadius), 0)
			end
			
			local tr = util.TraceHull({start = pos + Vector(0, 0, 150), endpos = pos, mask = MASK_SOLID_BRUSHONLY, mins = Vector(-16, -16, -1), maxs = Vector(16, 16, 1)})
			ent:SetPos(tr.HitPos)
			
			ent.MoveCenterVec = self:GetPos()
			ent:Spawn()
			
			ent:SetParentSpawner(self)
			table.insert(self.m_Children, ent)
		end
	end

	function ENT:GetVarsToSave()
		local tab = {
			SpawnRadius = self.m_SpawnRadius,
			MoveRadius = self.m_MoveRadius,
			SpawnTime = self.m_SpawnTime
		}
		
		return tab
	end
	
	function ENT:SetVarsToLoad(tab)
		if tab.SpawnRadius then
			self.m_SpawnRadius = tab.SpawnRadius
		end
		
		if tab.MoveRadius then
			self.m_MoveRadius = tab.MoveRadius
		end
		
		if tab.SpawnTime then
			self.m_SpawnTime = tab.SpawnTime
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
