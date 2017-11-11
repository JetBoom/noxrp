AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

ENT.CanBleed = false

function ENT:Initialize()
	self.Entity:SetModel("models/combine_turrets/floor_turret.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
		
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
	self:SetHealth(250)
	self:SetMaxHealth(250)
	self:SetEnergy(100)
	
	self.NextEnergy = 0
end

function ENT:GetAttackFilter()
	local tab = {}
	table.insert(tab, self)
	
	return tab
end

function ENT:OnWelded(welder, pl, trace)
	if self:Health() >= self:GetMaxHealth() then return false end
	
	self:SetHealth(math.min(self:Health() + 1, self:GetMaxHealth()))
	
	if math.random(10) == 1 then
		self:SetMaxHealth(math.max(self:GetMaxHealth() - 1, 1))
	end
	
	return true
end

function ENT:TurretFire(src, dir, numbullets)
	if self:GetNextFire() <= CurTime() then
		local energy = self:GetEnergy()
		if energy > 0 then
			self:SetNextFire(CurTime() + 0.15)
			self:SetEnergy(math.ceil(energy - 1, 0))

			CreateBullet(src, AngleCone(dir:Angle(), 0.5):Forward(), self, self, 8, 2900, "projectile_asbullet", false, true)
			self:EmitSound("npc/turret_floor/shoot"..math.random(3)..".wav")
		else
			self:SetNextFire(CurTime() + 2)
			self:EmitSound("npc/turret_floor/die.wav")
		end
	end
end

function ENT:OnTakeDamage(cdmg)
	local amt = cdmg:GetBaseDamage()
	
	self:SetHealth(self:Health() - amt)
	
	if self:Health() <= 0 then
		self.Explode = true
		self:Remove()
	end
end

function ENT:OnRemove()
	if self.Explode then
		local effectdata = EffectData()
			effectdata:SetStart(self:GetPos())
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetScale(1)
					
		util.Effect("Explosion", effectdata)
	end
end

function ENT:Think()
	local shootpos = self:ShootPos()

	local target = self:GetTarget()
	if target:IsValid() then
		if target:Health() > 0 then
			local dir = (self:GetTargetPos(target) - shootpos):GetNormalized()
			
			local dot = dir:Dot(self:GetForward())
			if dot > 0.5 and target:GetPos():Distance(self:GetPos()) < 650 then
				self:TurretFire(shootpos, dir)
			else
				self:SetTarget(nil)
			end
		else
			self:SetTarget(nil)
		end
	else
		local trace = {}
		trace.start = shootpos
		trace.endpos = shootpos + self:GetForward() * 600 + self:GetUp() * math.sin(CurTime() * 3) * 100
		trace.filter = {self}
		local tr = util.TraceLine(trace)
		local ent = tr.Entity
		if ent and ent:IsValid() then
			if ent:IsNextBot() then
				if ent:IsValidTargetRelation(self, G_RELATIONSHIP_HATE) or (self.m_Creator and ent:IsValidTargetRelation(self.m_Creator, G_RELATIONSHIP_HATE)) then
					self:SetTarget(ent)
				end
			elseif self.m_Creator then
				if self.m_Creator.Attackers[ent] then
					self:SetTarget(ent)
				end
			end
		end
	end
	
	if self:GetEnergy() < 100 and self.NextEnergy < CurTime() then
		self.NextEnergy = CurTime() + 4
		self:SetEnergy(math.min(self:GetEnergy() + 1, 100))
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:IsPlayerOwner(pl)
	return self.m_Owner == pl:GetAccountID() or self.m_Creator == pl
end

function ENT:Use(pl)
	if not pl:KeyDown(IN_WALK) then return end
	if pl:IsPlayer() then
		if self:IsPlayerOwner(pl) then
			local item = Item("turret")
				item:GetData().Health = self:Health()
				item:GetData().MaxHealth = self:GetMaxHealth()
				item:GetData().Energy = self:GetEnergy()
			
			pl:InventoryAdd(item, self)
		end
	end
end

function ENT:OnElectroHacked(pl)
	self.m_Owner = pl:GetAccountID()
	self.m_Creator = pl
end

function ENT:SetEnergy(amt)
	self:SetDTInt(0, amt)
end

function ENT:AddEnergy(amt)
	self:SetDTInt(0, self:GetDTInt(0) + amt)
end