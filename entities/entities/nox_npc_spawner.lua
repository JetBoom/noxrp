ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self:SetNoDraw(true)
		self.m_Class = "npc_nox_charger"
		self.m_Children = {}
		self.m_MaxCount = 5
		self.m_SpawnRadius = 256
		self.m_MoveRadius = 256
		self.m_SpawnTime = 10
		
		self.NextSpawn = 0
	end

	function ENT:SetClass(class)
		self.m_Class = class
	end

	function ENT:SetRadius(radius)
		self.m_SpawnRadius = radius
	end

	function ENT:SetMaxChildren(num)
		self.m_MaxCount = num
	end

	function ENT:SetSpawnTime(timet)
		self.m_SpawnTime = timet
	end

	function ENT:Think()
		for k,v in pairs(self.m_Children) do
			if not v:IsValid() then
				self.NextSpawn = CurTime() + self.m_SpawnTime
				table.remove(self.m_Children, k)
				
				k = k - 1
			end
		end
		
		if self.NextSpawn < CurTime() then
			if (#self.m_Children < self.m_MaxCount or self.m_MaxCount == -1) then
				self.NextSpawn = CurTime() + self.m_SpawnTime
				
				local pos

				local ent = ents.Create(self.m_Class)
				if self.m_SpawnRadius == 0 then
					pos = self:GetPos()
				else
					pos = self:GetPos() + Vector(math.cos(math.random(0, math.pi)) * self.m_SpawnRadius, math.sin(math.random(0, math.pi)) * self.m_SpawnRadius, 0)
				end
				
				local tr = util.TraceHull({start = pos + Vector(0, 0, 150), endpos = pos, mask = MASK_SOLID_BRUSHONLY, mins = Vector(-16, -16, -1), maxs = Vector(16, 16, 1)})
				ent:SetPos(tr.HitPos)
				
				ent.MoveCenterVec = self:GetPos()
				ent:Spawn()
				
				if ent.SetParentSpawner then
					ent:SetParentSpawner(self)
				end
				
				table.insert(self.m_Children, ent)
			end
		end
	end

	function ENT:GetVarsToSave()
		local tab = {
			Class = self.m_Class,
			MaxCount = self.m_MaxCount,
			SpawnRadius = self.m_SpawnRadius,
			MoveRadius = self.m_MoveRadius,
			SpawnTime = self.m_SpawnTime
		}
		
		return tab
	end
	
	function ENT:SetVarsToLoad(tab)
		if tab.Class then
			self.m_Class = tab.Class
		end
		
		if tab.MaxCount then
			self.m_MaxCount = tab.MaxCount
		end
		
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
	end
end
