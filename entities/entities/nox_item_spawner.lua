ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel("models/props/cs_italy/orange.mdl")
		self:DrawShadow(false)
		self.SpawnItem = "item_ore_iron"
		self.Children = {}
		self.MaxCount = 5
		self.SpawnRadius = 256
		self.SpawnTime = 60
		
		self.NextSpawn = 0
	end

	function ENT:Think()
		if self.NextSpawn < CurTime() then
			if (#self.Children < self.MaxCount or self.MaxCount == -1) then
				self.NextSpawn = CurTime() + self.SpawnTime
				
				local pos

				local ent = ents.Create(self.SpawnItem)
				if self.SpawnRadius == 0 then
					pos = self:GetPos()
				else
					pos = self:GetPos() + Vector(math.cos(math.random(0, math.pi)) * self.SpawnRadius, math.sin(math.random(0, math.pi)) * self.SpawnRadius, 0)
				end
				
				local tr = util.TraceHull({start = pos + Vector(0, 0, 100), endpos = pos, mask = MASK_SOLID_BRUSHONLY, mins = Vector(-16, -16, -1), maxs = Vector(16, 16, 1)})
				ent:SetPos(tr.HitPos)
				ent:Spawn()
				ent.WorldMine = self
				ent.ParentSpawner = self
				ent:SetData()

				table.insert(self.Children, ent)
			end
		end
	end
	
	function ENT:OnChildPickedup(item)
		for k, v in pairs(self.Children) do
			if v == item then
				v = nil
				self.Children[k] = nil
				
				return
			end
		end
	end

	function ENT:GetVarsToSave()
		local tab = {
			Item = self.SpawnItem,
			MaxCount = self.MaxCount,
			SpawnRadius = self.SpawnRadius,
			SpawnTime = self.SpawnTime
		}
		
		return tab
	end
	
	function ENT:SetVarsToLoad(tab)
		if tab.Item then
			self.SpawnItem = tab.Item
		end
		
		if tab.MaxCount then
			self.MaxCount = tab.MaxCount
		end
		
		if tab.SpawnRadius then
			self.SpawnRadius = tab.SpawnRadius
		end
		
		if tab.SpawnTime then
			self.SpawnTime = self.SpawnTime
		end
	end
end

if CLIENT then
	function ENT:Draw()
		if LocalPlayer():IsSuperAdmin() then
			self:DrawModel()
		end
	end
end
