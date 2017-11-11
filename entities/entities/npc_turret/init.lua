AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/combine_turrets/floor_turret.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
		
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
	self:SetHealth(20)
	self.AmmoCount = 50
	self:SetTarget(NULL)
end

function ENT:GetAttackFilter()
	local tab = {}
	table.insert(tab, self)
	
	return tab
end

function ENT:TurretFire(src, dir, numbullets)
	if self:GetNextFire() <= CurTime() then
		local ammo = self.AmmoCount
		if ammo > 0 then
			self:SetNextFire(CurTime() + 0)
			self.AmmoCount = ammo - 1

			local bullet = ents.Create("projectile_asbullet")
			if bullet:IsValid() then
				local ang = AngleCone(self:GetAngles(), 5)
				local vel = dir * 2900
				
				bullet.LastPosition = pos
				bullet.Speed = 2900
				bullet:SetPos(self:ShootPos())
				bullet:SetAngles(ang)

				bullet:SetOwner(self)

				bullet.Inflictor = NULL
				bullet.Damage = 0

				bullet:SetVelocity(vel)

				bullet:Spawn()

				local phys = bullet:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous(vel)
				end

				if prehit then
					bullet:Hit(prehit, true)
					bullet:NextThink(CurTime())
				end
			end
			
			self:EmitSound(self.FireSound)
		else
			self:SetNextFire(CurTime() + 5)
			self.Reloading = CurTime() + 5
			self:EmitSound("npc/turret_floor/die.wav")
		end
	end
end

function ENT:OnTakeDamage(cdmg)
	local amt = cdmg:GetBaseDamage()
	
	self:SetHealth(self:Health() - amt)
	
	if self:Health() <= 0 then
		self:Remove()
	end
end

function ENT:OnRemove()
	local effectdata = EffectData()
		effectdata:SetStart(self:GetPos())
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetScale(1)
				
	util.Effect("Explosion", effectdata)
end

function ENT:Think()
	local shootpos = self:ShootPos()
	
	if self.Reloading then
		if self.Reloading < CurTime() then
			self.Reloading = nil
			self.AmmoCount = 50
		end
	end

	local target = self:GetTarget()
	if target:IsValid() then
		if target:Health() > 0 then
			local dir = (self:GetTargetPos(target) - shootpos):GetNormalized()
			self:SetAngles(dir:Angle())
			
			local dot = dir:Dot(self:GetForward())
			if dot > 0.8 and target:GetPos():Distance(self:GetPos()) < 650 then
				self:TurretFire(shootpos, dir)
			else
				self:SetTarget(NULL)
			end
		else
			self:SetTarget(NULL)
		end
	else
		for _, pl in pairs(ents.FindInSphere(self:GetPos(), 500)) do
			if pl:IsPlayer() and pl:Health() > 0 then
				self:SetTarget(pl)
				break
			end
		end
	end
	
	self:NextThink(CurTime())
end

function ENT:SetTarget(target)
	self.Target = target
end

function ENT:GetTarget()
	return self.Target
end
