ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel("models/props/cs_italy/orange.mdl")
		self:DrawShadow(false)
	end

	function ENT:Think()
	end

	function ENT:GetVarsToSave()
		local tab = {
			["SelfID"] = self:GetSelfID(),
			["TargetID"] = self:GetTargetID(),
		}
		
		return tab
	end
	
	function ENT:SetVarsToLoad(tab)
		if tab.SelfID then
			self:SetSelfID(tab.SelfID)
		end
		
		if tab.TargetID then
			self:SetTargetID(tab.TargetID)
		end
	end
	
	function ENT:SetSelfID(id)
		self.SelfID = id
		self:SetDTInt(0, id)
	end
	
	function ENT:SetTargetID(id)
		self.TargetID = id
		self:SetDTInt(1, id)
	end
	
	function ENT:GetSelfID()
		return self.SelfID
	end

	function ENT:GetTargetID()
		return self.TargetID
	end
end

if CLIENT then
	function ENT:Draw()
		if LocalPlayer():IsSuperAdmin() then
			self:DrawModel()
			
			if not LocalPlayer():IsSuperAdmin() then return end
			local targ
			for _, ent in pairs(ents.FindByClass("point_policenode")) do
				if ent:GetDTInt(0) == self:GetDTInt(1) and ent != self then
					targ = ent
					break
				end
			end
			
			if targ then
				render.DrawLine(self:GetPos(), targ:GetPos(), Color(255, 0, 0), true)
			end
			local ang = EyeAngles()
			cam.Start3D2D(self:GetPos() + Vector(0, 0, 40), Angle(180, ang.y + 90, -90), 0.05)
				draw.RoundedBox(8, -300, -50, 600, 100, Color(0, 0, 0, 200))
				draw.SimpleText("Self ID: "..self:GetDTInt(0), "hidden48", 0, -20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Target ID: "..self:GetDTInt(1), "hidden48", 0, 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end
