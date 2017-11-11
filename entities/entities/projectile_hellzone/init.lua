AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(true)
	self.DieTime = CurTime() + 30
	
	self:SetModel("models/Items/CrossbowRounds.mdl")
	self:SetModelScale(0.5, 0)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0.002)
		phys:Wake()
	end
	
	self.NextFireWall = CurTime() + 0.01
	self.FireWalls = 0
	
	self:Think()
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysData = data
	self:NextThink(CurTime())
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Think()
	if self.DieTime < CurTime() then
		self:Remove()
	end
	
	if self.FireWalls < math.floor(self:GetDamage() / 10) then
		if self.NextFireWall < CurTime() then
			self.FireWalls = self.FireWalls + 1
			self.NextFireWall = CurTime() + 0.04
				
			local data = {}
				data.start = self:GetPos()
				data.endpos = data.start - self:GetUp() * 40
				data.filter = self
				data.mask = MASK_PLAYERSOLID_BRUSHONLY
				
			local tr = util.TraceLine(data)
				
			if tr.HitWorld and tr.HitNormal.z > 0.95 then
				local fire = ents.Create("hellzone_firewall")
				if fire then
					fire:SetPos(tr.HitPos)
					fire:SetOwner(self:GetOwner())
					fire:SetAngles(Angle(0, self:GetAngles().y, 0))
					fire:Spawn()
				end
			end
		end
	end
	
	if self.PhysData then
		if self.PhysData.HitEntity.IsProjectile then self.PhysData = nil return end
		local data = self.PhysData
		self.PhysData = nil

		local damage = self:GetDamage()
		local owner = self:GetOwner()
		local wep = self.Weapon or owner
		
		local newdamage = DamageInfo()
			newdamage:SetDamage(damage)
			newdamage:SetAttacker(owner)
			newdamage:SetInflictor(wep)
			newdamage:SetDamageType(DMG_BURN)
							
		data.HitEntity:TakeDamageInfo(newdamage)
		
		for k, v in pairs(ents.FindInSphere(data.HitPos, 50)) do
			if v ~= data.HitEntity then
				local cen = data.HitPos
				local dam = damage - (damage - 1) * (cen:Distance(v:GetPos()) / 50)
							
				local newdamage = DamageInfo()
					newdamage:SetDamage(dam)
					newdamage:SetAttacker(owner)
					newdamage:SetInflictor(wep)
					newdamage:SetDamageType(DMG_BURN)
								
				v:TakeDamageInfo(newdamage)
					
				if v:IsPlayer() or v.IsNextBot then
					v:GiveStatus("onfire", 1)
				end
			end
		end
		
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetNormal(data.OurOldVelocity:GetNormalized() * -1)
		util.Effect("bullet_fire", effectdata)
		
		self:HitEffect()
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:StartTouch(ent)
	if ent.IsProjectile then return end
	local damage = self:GetDamage()
	local owner = self:GetOwner()
	local wep = self.Weapon
	
	local newdamage = DamageInfo()
		newdamage:SetDamage(damage)
		newdamage:SetAttacker(owner)
		newdamage:SetInflictor(wep)
		newdamage:SetDamageType(DMG_BURN)
							
	ent:TakeDamageInfo(newdamage)
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 50)) do
		if v ~= ent then
			local cen = self:GetPos()
			local dam = damage - (damage - 1) * (cen:Distance(v:GetPos()) / 50)
							
			local newdamage = DamageInfo()
				newdamage:SetDamage(dam)
				newdamage:SetAttacker(owner)
				newdamage:SetInflictor(wep)
				newdamage:SetDamageType(DMG_BURN)
								
			v:TakeDamageInfo(newdamage)
				
			if v:IsPlayer() or v.IsNextBot then
				if dam > damage * 0.5 then
					v:GiveStatus("onfire")
				end
			end
		end
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetVelocity():GetNormalized() * -1)
	util.Effect("bullet_fire", effectdata)
		
	self:HitEffect()
end

function ENT:HitEffect(data)
	self:Remove()
end
