AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.BulletBounceTimes = 0
ENT.MaximumBounces = 0
ENT.BulletHitEffect = "hit_bullet"
ENT.BulletHitEffectBlocked = "hit_bullet_blocked"

--[[
Penetration List:

0-1: Nothing
2-3: Thin Wood (table legs, tabletops)
]]

ENT.PiercingPower = 3
ENT.BulletPiercingTimes = 0

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetModel(self.BulletModel)
	self:PhysicsInitSphere(1)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetModelScale(1.5, 0)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then 
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0.00001)
		phys:Wake()
	end

	self.Damage = self.Damage or 10
	self.Speed = self.Speed or 3000
	self.BulletDamageType = self.BulletDamageType or DMG_BULLET

	self.DeathTime = self.DeathTime or CurTime() + 30

	self.LastPosition = self.LastPosition or self:GetPos()

	-- I cache this because it would be rediculous to do it dynamically.
	local owner = self:GetOwner()
	if owner:IsValid() then
		self.BulletFilter = owner:GetAttackFilter()
	end

	self:NextThink(CurTime())
end

function ENT:CheckPenetration(tr)
	local lastpos = tr.HitPos
	local penetrated = false
	
	local scalar = 1
	if tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_FLESH then
		scalar = 2
	elseif tr.MatType == MAT_WOOD or tr.MatType == MAT_PLASTIC then
		scalar = 1.2
	elseif tr.MatType == MAT_METAL then
		scalar = 0.5
	elseif tr.MatType == MAT_DEFAULT then
		scalar = 0
	end
	
	local pen = math.floor(self.PiercingPower * scalar)
	
	
	--hacky as shit
	if pen > 0 then 
		for i = 0, pen do
			local data = {}
				data.start = lastpos
				data.endpos = data.start + tr.Normal * 2
				
			local tr2 = util.TraceLine(data)
			if not tr2.HitWorld and not tr2.Entity:IsValid() then
				penetrated = true
				
				self.LastPosition = tr2.HitPos + tr2.Normal * 1
				local phys = self:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetPos(self.LastPosition)
					self.PenetrateNormal = tr.Normal
					
					--self:FakeBullet(self.LastPosition, (self.LastPosition - tr.HitPos):GetNormalized())
					
					self.Damage = self.Damage * 0.8
				end
				
				break
			elseif tr2.Entity:IsPlayer() then
				self.Damage = self.Damage * 0.8
				
				local hitent = tr2.Entity
				
				TEMPBULLET = self
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(self.Damage)
				dmginfo:SetAttacker(self:GetOwner())
				if self.Inflictor and self.Inflictor:IsValid() then
					dmginfo:SetInflictor(self.Inflictor)
				end
				dmginfo:SetDamageType(self.BulletDamageType)
				dmginfo:SetDamageForce(self.Damage * 5 * tr.Normal)
				if hitent:IsPlayer() then
					gamemode.Call("ScalePlayerDamage", hitent, tr.HitGroup, dmginfo, true, true)
					hitent:EmitSound("Flesh.BulletImpact")
				elseif hitent:IsNPC() then
					gamemode.Call("ScaleNPCDamage", hitent, tr.HitGroup, dmginfo)
					hitent:EmitSound("Flesh.BulletImpact")
				end

				if self.AlterDamageInfo then
					self:AlterDamageInfo(dmginfo, tr, prehit)
				end

				hitent:TakeDamageInfo(dmginfo)
				TEMPBULLET = nil
				
				if self.DoSkillCheck and self:GetOwner():IsPlayer() then
					if hitent:IsPlayer() or (hitent:IsNextBot() and self:GetOwner():GetPos():Distance(hitent:GetPos()) <= self:GetAwarenessRadius()) then
						local chance = math.random(self.DoSkillCheck:GetSkillChance(self.Skill))

						if chance == 1 then
							self.DoSkillCheck:AddSkill(self.Skill, 1)
						end
					end
				end
				
				break
			else
				lastpos = data.endpos
			end
		end
	end

	return penetrated
end

function ENT:Hit(tr, prehit)
	local shouldremove = true
	local ricochet = false
	
	if tr.HitWorld and self.BulletBounceTimes < self.MaximumBounces and not prehit then
		local Dot = tr.HitNormal:Dot(tr.Normal * -1)
		if Dot <= 0.25 then
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				ricochet = true
				shouldremove = false
				bounce = (2 * Dot * tr.HitNormal + tr.Normal)
				self.BulletBounceTimes = self.BulletBounceTimes + 1
				sound.Play("weapons/fx/rics/ric"..math.random(1, 5)..".wav", tr.HitPos, 76, math.random(100, 110))
				self.LastPosition = tr.HitPos + tr.HitNormal * 0.5
				phys:SetPos(self.LastPosition)
				phys:SetVelocityInstantaneous(bounce * self.Speed)
			end
		end
	end

	if self:OnHit(tr, prehit) then return true end

	local hitent = tr.Entity
	if hitent:IsValid() then
		local ret = hitent.OnHitWithBullet and hitent:OnHitWithBullet(self, tr, prehit)
		if ret == 1 then
			shouldremove = false
		end

		if not ret or ret == 2 then
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0)
				shouldremove = false
			else
				TEMPBULLET = self
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(self.Damage)
				dmginfo:SetAttacker(self:GetOwner() or self)
				if self.Inflictor and self.Inflictor:IsValid() then
					dmginfo:SetInflictor(self.Inflictor)
				end
				dmginfo:SetDamageType(self.BulletDamageType)
				dmginfo:SetDamageForce(self.Damage * 5 * tr.Normal)
				if hitent:IsPlayer() then
					gamemode.Call("ScalePlayerDamage", hitent, tr.HitGroup, dmginfo, true, true)
					hitent:EmitSound("Flesh.BulletImpact")
				elseif hitent:IsNPC() then
					gamemode.Call("ScaleNPCDamage", hitent, tr.HitGroup, dmginfo)
					hitent:EmitSound("Flesh.BulletImpact")
				end

				if self.AlterDamageInfo then
					self:AlterDamageInfo(dmginfo, tr, prehit)
				end

				hitent:TakeDamageInfo(dmginfo)
				TEMPBULLET = nil
				
				if self.DoSkillCheck and self:GetOwner():IsPlayer() then
					if hitent:IsPlayer() or (hitent:IsNextBot() and self:GetOwner():GetPos():Distance(hitent:GetPos()) <= hitent:GetAwarenessRadius()) then
						local chance = math.random(self.DoSkillCheck:GetSkillChance(SKILL_GUNNERY))

						if chance == 1 then
							self.DoSkillCheck:AddSkill(SKILL_GUNNERY, 1)
						end
					end
				end

				local phys = hitent:GetPhysicsObject()
				if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					hitent:SetPhysicsAttacker(self:GetOwner())
				end

				if self.PostDoDamage then
					self:PostDoDamage(hitent, dmginfo, tr, prehit, bounce)
				end
			end
		end
	elseif tr.HitWorld and self.BulletPiercingTimes < 1 and not ricochet then
		if self:CheckPenetration(tr) then
			shouldremove = false
			self.BulletPiercingTimes = self.BulletPiercingTimes + 1
		end
	end

	if self.BulletHitEffect and not tr.HitSky then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			local owner = self:GetOwner()
			effectdata:SetScale(owner:IsValid() and owner:IsPlayer() and owner:Team() or 0)
			effectdata:SetMagnitude(self.Damage)
		util.Effect(self.BulletHitEffect, effectdata, true, true)
	end

	if shouldremove then
		self.DeathTime = 0
		self.HitTrace = tr
		self:FakeBullet(self.LastPosition, (tr.HitPos - self.LastPosition):GetNormalized())
		self:Remove()
	else
		self:NextThink(CurTime())
	end

	return true
end

function ENT:Think()
	if CurTime() >= self.DeathTime then
		self:Remove()
		return
	end
	
	if self.PenetrateNormal then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocityInstantaneous(self.PenetrateNormal * self.Speed)
		end
		
		self.PenetrateNormal = nil
	end

	local thisposition = self:GetPos()

	local tr = BulletTrace(self.LastPosition, thisposition, self.BulletFilter)
	if not (tr.Hit and self:Hit(tr)) then
		self.LastPosition = thisposition
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnHit(tr)
end

function ENT:PhysicsCollide(data, phys)
	self:NextThink(CurTime())
end
