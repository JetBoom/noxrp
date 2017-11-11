AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/manhack.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self:EmitSound("weapons/c4/c4_plant.wav")
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
	
	if self:GetEntityAppliedTo():IsValid() then
		local ent = self:GetEntityAppliedTo()
		local size = ent:OBBMaxs() - ent:OBBMins()
		local vol = size.x * size.y * size.z
		
		self:SetHackTime(CurTime() + math.Round(vol * 0.0002))
		self.NextBeep = CurTime() + 1.5
	else
		self:SetHackTime(CurTime() + 10)
		self.NextBeep = CurTime() + 1.5
	end
end

function ENT:Think()
	if self.NextBeep < CurTime() then
		self.NextBeep = CurTime() + 1.5
		self:EmitSound("buttons/combine_button2.wav")
	end
	
	if self:GetHackTime() < CurTime() then
		local ent = self:GetEntityAppliedTo()
		if ent:IsValid() then
			if string.find(ent:GetClass(), "door") then
				ent:Fire("unlock", "", .5)
				ent:Fire("open", "", .6)
				ent:Fire("setanimation", "open", .6)
			else
				ent:OnElectroHacked(self.m_Creator)
			end
		end
		
		local effect = ents.Create("point_tesla")
		if effect:IsValid() then
			effect:SetKeyValue("m_flRadius", "16")
			effect:SetKeyValue("m_SoundName", "DoSpark")
			effect:SetKeyValue("m_Color", "255 255 255")
			effect:SetKeyValue("texture", "effects/laser1.vmt")
			effect:SetKeyValue("beamcount_min", "4")
			effect:SetKeyValue("beamcount_max", "8")
			effect:SetKeyValue("thick_min", "1")
			effect:SetKeyValue("thick_max", "3")
			effect:SetKeyValue("lifetime_min", "0.25")
			effect:SetKeyValue("lifetime_max", "0.4")
			effect:SetKeyValue("interval_min", "0.05")
			effect:SetKeyValue("interval_max", "0.12")
			effect:SetPos(self:GetPos())
			effect:Spawn()
			effect:Fire("DoSpark", "", 0)
			effect:Fire("kill", "", 0.4)
		end
	
		local item = ents.Create("item_electrohack")
			item:SetPos(self:GetPos())
			item:Spawn()
			item:SetData()
			
		self:EmitSound("ambient/energy/zap7.wav")
		self:Remove()
	end
end

function ENT:OnTakeDamage(cdmg)
	local amt = cdmg:GetBaseDamage()
	
	self:Remove()
end