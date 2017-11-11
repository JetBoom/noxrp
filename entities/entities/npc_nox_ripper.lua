AddCSLuaFile()

ENT.Base 			= "npc_nox_base"

local STATE_IDLE = 0
local STATE_MOVING = 1
local STATE_ATTACKING = 2
local STATE_SWUNG = 3
local STATE_WAVING = 4
local STATE_RIPPING = 5

function ENT:Initialize2()
	self:SetClassRelationships()

	self:SetModel( "models/Zombie/Poison.mdl" )
	self:SetHealth(2000)
	self:SetMaxHealth(2000)
	
	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(200)		//default 400
	self.loco:SetDeceleration(200)		//default 400
	self.loco:SetStepHeight(18)			//default 18
	self.loco:SetJumpHeight(50)		//default 58
	
	self:SetModelScale(2, 0)
	self:SetAwarenessRadius(1200)
	
	self.State = STATE_IDLE
	
	self.DropTable = {
		{Chance = 2, Item = "phosphorus", Amount = 1}
	}
	
	
	self.NextIdleMove = 0
	self:SetCollisionBounds( Vector(-18, -18, 0), Vector(18, 18, 80) ) 
	self.NextAttack = 0
	if self.ParentSpawner then
		self.MoveRadius = self.ParentSpawner.m_MoveRadius
		self.MoveCenterVec = self.ParentSpawner:GetPos()
	else
		self.MoveRadius = 400
	end
	
	self.Damage = 0
	self.DamageType = DMG_SLASH
	self.DamageRange = 150
	self.DamageBox = Vector(12, 12, 12)
	
	self.NextFootSound = 0
	self.NextIdleNoise = 0
	self.NextHurtSound = 0
	self.NextEmote = 0
	
	self.ChaseTime = 0
	self.NextAttack = 0
	self.SwingTime = 0
	self.NextWave = 0
	self.Waves = 0
	
	self.Rips = 0
end

function ENT:SetClassRelationships()
	self:SetRelationshipToClass("npc_nox_zombie", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_charger", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger_a", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger_w", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_police", G_RELATIONSHIP_HATE, 1)
	
	self:SetRelationshipToPlayers(G_RELATIONSHIP_HATE, 1)
end

function ENT:SetParentSpawner(ent)
	self.ParentSpawner = ent
	self.MoveRadius = ent.m_MoveRadius
	self.MoveCenterVec = ent:GetPos()
end

function ENT:OnTargetSet(target)
	self:EmitSound("npc/zombie/zombie_alert"..math.random(3)..".wav")

	self.ChaseTime = CurTime() + math.random(10, 12)
	
	local dist = self:GetPos():Distance(target:GetPos())
	
	if dist > 200 then
		self.State = STATE_WAVING
	end
end

function ENT:SetNextSwingTime(time)
	self.NextAttack = time
end

function ENT:GetNextSwingTime()
	return self.NextAttack
end

function ENT:CanSwing()
	return self:GetNextSwingTime() < CurTime()
end

function ENT:ClearTarget()
	self.Target = nil
	self.HaveTarget = false

	BroadcastLocalOverheadText("[Groaning]", self)
end

function ENT:Swing()
	self:SetNextSwingTime(CurTime() + 0.8)
	
	local dist = self:GetPos():Distance(self.Target:GetPos())
	
	local data = {}
	data.start = self:GetPos() + Vector(0, 0, 36)
	data.endpos = data.start + self:GetForward() * self.DamageRange
	data.mins = self.DamageBox * -1
	data.maxs = self.DamageBox
	data.filter = self
		
	local trace = util.TraceHull(data)
	local ent = trace.Entity
		
	if ent:IsValid() then
		local pos = self:NearestPoint(self:GetPos())
		
		local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(self.Damage)
			dmginfo:SetDamageType(self.DamageType)
			dmginfo:SetDamagePosition(pos)
		ent:TakeDamageInfo(dmginfo)
		
		ent:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav")
		
		local dir = (ent:GetPos() - self:GetPos() + ent:OBBCenter()):GetNormalized()
		ent:SetVelocity(dir * 800)
		
		if ent:IsPlayer() then
			ent:KnockDown()
		end
	else
		self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav")
	end
end

function ENT:MoveToPos( pos, options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )
		
		if self.NextFootSound < CurTime() then
			self.NextFootSound = CurTime() + 0.38
			self:EmitSound("npc/zombie/foot"..math.random(3)..".wav")
		end
		
		if self.NextIdleNoise < CurTime() then
			self.NextIdleNoise = CurTime() + 3.5
			self:EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav")
		end

		if ( options.draw ) then
			path:Draw()
		end

		if ( self.loco:IsStuck() ) then

			self:HandleStuck();
			
			return "stuck"

		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		
		if self.Target and not self.HaveTarget then
			self.HaveTarget = true
			return "ok"
		end
		
		coroutine.yield()

	end
	
	return "ok"

end

function ENT:MoveToTarget()
	if not self.Target then return end
	
	local options = {}
	options.repath = 0.2

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute(self, self.Target:GetPos())

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update(self)
		
		if self.NextFootSound < CurTime() then
			self.NextFootSound = CurTime() + 0.3
			self:EmitSound("npc/zombie/foot"..math.random(3)..".wav")
		end

		if ( self.loco:IsStuck() ) then

			self:HandleStuck();
			
			return "stuck"

		end
		
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then 
				if self.Target then
					path:Compute( self, self.Target:GetPos())
				else
					return "failed"
				end
			end
		end

		if path:GetEnd():Distance(self:GetPos()) <= 120 then
			return "ok"
		elseif self.NextWave < CurTime() then
			self.State = STATE_WAVING
			self.Waves = 0
			
			return "ok"
		end
		
		coroutine.yield()

	end
end

function ENT:BehaveUpdate( fInterval )
	if self:GetTarget():IsValid() then	
		if self.ChaseTime < CurTime() then
			self:ClearTarget()
		end
	else
		self:FindTargetsAndSet()
	end
	
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then
		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );
	end
end

function ENT:Rip()
	self:EmitSound("npc/zombie_poison/pz_call1.wav")
	self:PlaySequenceAndWait("headcrab2Leap")
				
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
		effect:SetMagnitude(2)
	util.Effect("gib", effect)
				
	for i = 1, 4 do
		local shock = ents.Create("projectile_fleshball")
		if shock then
			shock:SetPos(self:GetPos() + Vector(0, 0, 30))
			shock:SetAngles(self:GetAngles())
			shock:SetOwner(self)
			shock:Spawn()
			shock:SetDestination(self:GetPos() + Vector(math.Rand(-100, 100), math.Rand(-100, 100), 0))
		end
	end
	
	local alpha = ents.Create("npc_nox_ripper_alpha")
	if alpha then
		alpha:SetPos(self:GetPos() + self:GetRight() * 50)
		alpha:SetAngles(self:GetAngles())
		alpha:Spawn()
		alpha:SetHealth(self:Health())
	end
	
	local beta = ents.Create("npc_nox_ripper_beta")
	if beta then
		beta:SetPos(self:GetPos() + self:GetRight() * 50)
		beta:SetAngles(self:GetAngles())
		beta:Spawn()
		beta:SetHealth(self:Health())
	end
				
	self:Remove()
end

function ENT:CheckRip()
	if self.Rips == 0 then
		if self:Health() <= self:GetMaxHealth() * 0.8 then
			self.State = STATE_RIPPING
		end
	elseif self.Rips == 1 then
		if self:Health() <= self:GetMaxHealth() * 0.5 then
			self.State = STATE_RIPPING
		end
	end
end

function ENT:RunBehaviour()
    while ( true ) do
		if not self:GetTarget():IsValid() then
			if self.NextIdleNoise < CurTime() then
				self.NextIdleNoise = CurTime() + 3
				self:EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav")
			end
			
			if self.NextIdleMove < CurTime() then
				if self.State ~= STATE_MOVING then
					self.State = STATE_MOVING
				end
				self:StartActivity( ACT_WALK )                            -- walk anims
				self.loco:SetDesiredSpeed( 70 ) 
				
				local pos = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.MoveRadius
				
				self:MoveToPos( pos, opts )	
				
				if self.State ~= STATE_IDLE then
					self.State = STATE_IDLE
				end
				
				self:StartActivity( ACT_IDLE_MELEE )        -- revert to idle activity
				self.NextIdleMove = CurTime() + 3
			else
				self:StartActivity( ACT_IDLE_MELEE ) 
			end
		else
			if self.State ~= STATE_RIPPING then
				self:CheckRip()
				
				if self.State ~= STATE_ATTACKING and self.State ~= STATE_SWUNG then
					local dist = self:GetPos():Distance(self.Target:GetPos())
					if dist > 300 then
						if self.State == STATE_WAVING then
							if self:IsFacing(self.Target, 0.95) and self.NextWave < CurTime() then
								self.Waves = self.Waves + 1
								self:StartActivity( ACT_MELEE_ATTACK1 )

								self.NextWave = CurTime() + 0.5
						
								self:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav")
								
								local shock = ents.Create("projectile_fleshball")
								if shock then
									shock:SetPos(self:GetPos() + Vector(0, 0, 30))
									shock:SetAngles(self:GetAngles())
									shock:SetOwner(self)
									shock:Spawn()
									shock:SetDestination(self.Target:GetPos())
								--	shock.Target = self.Target
								end
								
								if self.Waves > 5 then
									self.State = STATE_IDLE
									self.NextWave = CurTime() + 10
								end
							else
								self.loco:FaceTowards(self.Target:GetPos() + self.Target:OBBCenter())
							end
						else
							if self.NextWave > CurTime() then
								if self.State ~= STATE_MOVING then
									self.State = STATE_MOVING
								end
								self:StartActivity( ACT_WALK )
								self.loco:SetDesiredSpeed( 200 ) 
								
								self:MoveToTarget()
							else
								self.State = STATE_WAVING
								self.Waves = 0
							end
						end
					elseif dist >= 120 then
						if self.State ~= STATE_MOVING then
							self.State = STATE_MOVING
						end
						
						self:StartActivity( ACT_WALK )
						self.loco:SetDesiredSpeed( 150 )
						self:MoveToTarget()
						
					elseif self:CanSwing() then
						if self:IsFacing(self.Target) then
							self:StartActivity( ACT_MELEE_ATTACK1 )
							self:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav")
								
							self.State = STATE_ATTACKING
							self.SwingTime = CurTime() + 0.7
						else
							self.loco:FaceTowards(self.Target:GetPos() + self.Target:OBBCenter())
						end
					end
				else
					if self.State == STATE_ATTACKING then
						if self.SwingTime < CurTime() then
							self.State = STATE_SWUNG
							self:Swing()
						else
							if not self:IsFacing(self.Target) then
								self.loco:FaceTowards(self.Target:GetPos() + self.Target:OBBCenter())
							end
						end
					else
						if self:GetNextSwingTime() < CurTime() then
							if self.State ~= STATE_IDLE then
								self.State = STATE_IDLE
							end
						end
					end
				end
			else
				self:Rip()
			end
		end
		coroutine.yield()
    end
end

function ENT:OnInjured2(cdmg)
	cdmg:ScaleDamage(1)
	local target = cdmg:GetAttacker()
	if not self:GetTarget() and (self:IsValidTargetRelation(target, G_RELATIONSHIP_NEUTRAL) or self:IsValidTargetRelation(target, G_RELATIONSHIP_HATE)) then
		self:SetTarget(target)
	end
	
	self:EmitSound("npc/zombie/zombie_pain"..math.random(6)..".wav")
end

function ENT:OnKilled(cdmg)
	gamemode.Call("OnNPCKilled", self, cdmg:GetAttacker() or cdmg:GetInflictor() or nil, cdmg)
	
	self:EmitSound("npc/zombie/zombie_die"..math.random(3)..".wav")
	
	self:DoDropTable()
	
	self:BecomeRagdoll( cdmg )
end
	