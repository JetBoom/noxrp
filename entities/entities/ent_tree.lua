ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	ENT.ToSave = {}
	
	ENT.ModelList = {}
	
	ENT.ModelList["dead"] = {
		"models/props_foliage/tree_deciduous_01a.mdl",
		"models/props_foliage/tree_deciduous_01a.mdl"
	}
	
	ENT.ModelList["forest"] = {
		"models/props_foliage/tree_pine04.mdl",
		"models/props_foliage/tree_pine05.mdl",
		"models/props_foliage/tree_pine06.mdl"
	}
		
	
	AddCSLuaFile()
	function ENT:SetModelForArea(area)
		if area and self.ModelList[area] then
			local rand = self.ModelList[area][math.random(1, #self.ModelList[area])]
			self:SetModel(rand)
		end
	end
	
	function ENT:Initialize()
		self.AreaType = "dead"
		self:SetModelForArea(self.AreaType)
		self:PhysicsInit(SOLID_VPHYSICS)
		
		self:SetWoodMat("wood_oak")
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
		
		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.p, math.random(0, 360), ang.r))
		
		self.MatCount = 10
		self.MatTimer = 0
	end
	
	function ENT:Think()
		if self.MatTimer <= CurTime() and self.MatCount < 10 then
			self.MatCount = math.min(self.MatCount + 1, 10)
			self.MatTimer = CurTime() + 10
		end
	end
	
	function ENT:Cut(pl, trace, efficiency)
		efficiency = efficiency or 1
		if self.MatCount <= 0 then 
			local tab = {}
				tab.Text = "There is no more wood to cut."
				tab.Position = trace.HitPos
			pl:AddGlobalText(tab)
			return
		end
		
		local chance = math.random(1, 6 - efficiency)
		
		if chance == 1 then
			if self:GetWoodMat() == "" then
				self:SetWoodMat("wood_oak")
			end
			
			local name = self:GetWoodMat() or "wood_oak"
			local tab = Item(name)

			pl:InventoryAdd(tab, nil, false)
			
			pl:SendNotification("Cut the '"..ITEMS[name].Name.."'", 4, Color(255, 255, 255))

			self.MatCount = self.MatCount - 1
			self.MatTimer = CurTime() + 2
			
			local text = {}
				text.Text = "Cut "..ITEMS[self:GetWoodMat()].Name
				text.Position = trace.HitPos
			pl:AddGlobalText(text)
		end
	end
	
	function ENT:GetVarsToSave()
		return {WoodMat = self:GetWoodMat(), MatCount = self.MatCount, AreaType = self.AreaType}
	end
	
	function ENT:SetVarsToLoad(tab)
		if tab.WoodMat then
			self:SetWoodMat(tab.WoodMat)
		end
		
		if tab.MatCount then
			self.MatCount = tab.MatCount
		end
		
		if tab.AreaType then
			self:SetModelForArea(tab.AreaType)
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "WoodMat")
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local dir = (self:GetPos() - LocalPlayer():GetPos()):GetNormalized()
		dir.z = 0
		
		local pos = self:GetPos() + Vector(0, 0, 60) + dir * 30
		local ang = Angle(180, EyeAngles().y + 90, EyeAngles().r - 90)
		
		--[[cam.Start3D2D(pos, ang, 0.05)
			local name = ITEMS[self:GetWoodMat()].ParentName
			surface.SetFont("hidden48")
			local tw, th = surface.GetTextSize(name)
			
			draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 - 5, tw + 10, th + 10, Color(20, 20, 20, 180)) 
			draw.SimpleText(name, "hidden48", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()]]
	end
end