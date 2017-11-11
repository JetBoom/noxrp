ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/rockcliff01k.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self.MatCount = 20
		self.MatTimer = 0

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end

		local ang = self:GetAngles()
		self:SetAngles(Angle(ang.p, math.random(0, 360), ang.r))

		self:UpdateMat("ore_copper")
	end

	function ENT:UpdateMat(mat)
		self:SetIronMat(mat)

		local gitem = GetGlobalItem(self:GetIronMat())
		if gitem and gitem.MetalColor then
			self:SetColor(gitem.MetalColor)
		end
	end

	function ENT:Mine(pl, trace)
		if self.MatCount <= 0 then
			local tab = {}
				tab.Text = "This mine has been depleted."
				tab.Position = trace.HitPos
			pl:AddGlobalText(tab)
		--	pl:SendNotification("This mine has been depleted.")
			return
		end
		local chance = math.random(1, 3)
		local gemchance = math.random(1, 150)
		if chance == 1 then
			local tab = Item(nil, self:GetIronMat() or "metal_iron")
			pl:InventoryAdd(tab, nil, false)

			self.MatCount = self.MatCount - 1
			self.MatTimer = CurTime() + 2

			local text = {}
				text.Text = "Mined "..ITEMS[self:GetIronMat()].Name
				text.Position = trace.HitPos
				text.Sound = "physics/concrete/rock_impact_hard"..math.random(6)..".wav"
			pl:AddGlobalText(text)
		--	BroadcastLocalOverheadText(tab, self)
		end

		if gemchance == 1 then
			local gtype = math.random(3)
			local gem
			if gtype == 1 then
				gem = "gem_sapphire"
			elseif gtype == 2 then
				gem = "gem_ruby"
			else
				gem = "gem_emerald"
			end

			local tab = Item(nil, gem)
				pl:InventoryAdd(tab)

			local tab2 = {}
				tab2.Text = "Mined "..ITEMS[gem].Name
				tab2.Position = trace.HitPos
			pl:AddGlobalText(tab2)
		end
	end

	function ENT:Think()
		if self.MatTimer <= CurTime() and self.MatCount < 10 then
			self.MatCount = math.min(self.MatCount + 1, 20)
			self.MatTimer = CurTime() + 10
		end
	end

	function ENT:GetVarsToSave()
		return {IronMat = self:GetIronMat(), MatCount = self.MatCount}
	end

	function ENT:SetVarsToLoad(tab)
		if tab.IronMat then
			self:SetIronMat(tab.IronMat)
		end

		if tab.MatCount then
			self.MatCount = tab.MatCount
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "IronMat")
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		if self:GetIronMat() ~= self.Mat then
			self.Mat = self:GetIronMat()
			self.CachedName = ITEMS[self:GetIronMat()].Name
		end

		local alpha = 1

		local dist = self:GetPos():Distance(LocalPlayer():GetPos())
		local var = GetConVar("noxrp_radius3dtext"):GetInt() or 200
		if (dist - 100) > var then
			return
		elseif dist > var then
			alpha = math.Clamp(1 - (dist - GetConVar("noxrp_radius3dtext"):GetInt()) * 0.01, 0, 1)
		end

		local pos = self:GetPos() + self:OBBCenter() + self:GetRight() * -15 + Vector(0, 0, 70)
		local ang = Angle(180, EyeAngles().y + 90, EyeAngles().r - 90)

		surface.SetFont("hidden48")
			local tw, th = surface.GetTextSize(self.CachedName)

		cam.Start3D2D(pos, ang, 0.1)
			draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 - 5, tw + 10, th + 10, Color(20, 20, 20, 180 * alpha))
			draw.SimpleText(self.CachedName, "hidden48", 0, 0, Color(255, 255, 150, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end