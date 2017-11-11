--[[
	Name: Charger
	Aggression: If Provoked
	Desc: If it is created from a hive, then it wanders around the immediate area. If the hive is damaged by someone or something, they start to attack them.
	If not created from a hive, they wander map-wide until they randomly start to make a hive.
	
	Attack Process: If too far, charge them.
	If close but not close enough, move to target.
	If close enough, swing at them.
]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Base 			= "npc_nox_base"
ENT.NextBot			= true

local STATE_IDLE = 0
local STATE_MOVING = 1
local STATE_ATTACKING = 2
local STATE_SWUNG = 3
local STATE_CHARGING = 4
local STATE_REPAIRINGHIVE = 5

function ENT:Initialize2()
	self:SetClassRelationships()

	self:SetModel( "models/antlion.mdl" )
	self:SetHealth(100)
	
	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(400)		//default 400
	self.loco:SetDeceleration(2000)		//default 400
	self.loco:SetStepHeight(20)			//default 18
	self.loco:SetJumpHeight(300)		//default 58
	self.loco:SetMaxYawRate(360)
	
	self:SetCollisionBounds( Vector(-12, -12, 0), Vector(12, 12, 48) ) 
	
	self.Damage = 9
	self.DamageType = DMG_SLASH
	self.DamageRange = 130
	self.DamageBox = Vector(8, 8, 8)
	
	self.RunSpeed = 800
	self.WalkSpeed = 180
	self.ChargeSpeed = 1400
	
	self.StopMovingDist = 100
	
	self.Karma = -3000
	self.KarmaLimit = 500
	
	self:SetState(STATE_IDLE)
	
	if self.ParentSpawner then
		self.MoveRadius = self.ParentSpawner.m_MoveRadius
		self.MoveCenterVec = self.ParentSpawner:GetPos()
	else
		self.MoveRadius = 400
	end
	
	self.Target = NULL
	
	self.ChaseTime = 0
	self.NextAttack = 0
	self.SwingTime = 0
	self.NextIdleMove = 0
	
	self.NextFootSound = 0
	self.NextIdleNoise = 0
	self.NextHurtSound = 0
	self.NextEmote = 0
	
	self.InitialSpawn = CurTime() + 2
end

//Setup all relations with other classes and players
function ENT:SetClassRelationships()
	self:SetRelationshipToClass("npc_nox_zombie", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_charger_a", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_charger_w", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_police", G_RELATIONSHIP_HATE, 1)
	
	self:SetRelationshipToPlayers(G_RELATIONSHIP_NEUTRAL, 0)
end

//If they are created by a hive
function ENT:SetParentSpawner(ent)
	self.ParentSpawner = ent
	self.MoveRadius = ent.m_MoveRadius
	self.MoveCenterVec = ent:GetPos()
end

//If the main hive is damaged
function ENT:AlertHiveIsDamaged(cdmg)
	if not self:GetTarget():IsValid() then
		local target = cdmg:GetAttacker()
		if self:IsValidTargetRelation(target, G_RELATIONSHIP_NEUTRAL) or self:IsValidTargetRelation(target, G_RELATIONSHIP_HATE) then
			self:SetTarget(target)
			
			self.ChaseTime = CurTime() + math.random(10, 12)
		end
	end
end

function ENT:SetState(state)
	self.State = state
end

function ENT:OnTargetSet(target)
	self.ChaseTime = CurTime() + math.random(10, 12)
	
	local tab = {}
		tab.Color = Color(255, 180, 180, 255)
		tab.Text = "(It buzzes angrily!)"
		tab.LifeTime = 5
		tab.SubtitleType = 1
	BroadcastLocalOverheadText(tab, self)
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

function ENT:Swing()
	self:SetNextSwingTime(CurTime() + 0.3)

	local data = {}
	data.start = self:GetPos() + Vector(0, 0, 36)
	data.endpos = data.start + self:GetForward() * self.DamageRange
	data.mins = self.DamageBox * -1
	data.maxs = self.DamageBox
	data.filter = {}
	for _, filt in pairs(ents.FindByClass(self:GetClass())) do
		if filt:GetPos():Distance(self:GetPos()) <= self.DamageRange then
			table.insert(data.filter, filt)
		end
	end
		
	local trace = util.TraceHull(data)
	local ent = trace.Entity
		
	if ent:IsValid() then
		local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(self.Damage)
			dmginfo:SetDamageType(self.DamageType)
			dmginfo:SetDamagePosition(trace.HitPos)
		ent:TakeDamageInfo(dmginfo)
		
		ent:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav")
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
	self.PreviousNode = self.CurrentNode
	self.CurrentNode = path:GetCurrentGoal().pos

	while ( path:IsValid() ) do

		path:Update( self )
		
		if self.NextFootSound < CurTime() then
			self.NextFootSound = CurTime() + 0.38
			self:EmitSound("npc/antlion/foot"..math.random(4)..".wav", 60)
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
		
		if self:GetTarget():IsValid() and not self.HaveTarget then
			self.HaveTarget = true
			return "ok"
		end
		
		if path:GetCurrentGoal() then
			local data1 = {}
				data1.start = self:GetPos() + self:OBBCenter()
				data1.endpos = path:GetCurrentGoal().pos + self:OBBCenter()
				data1.filter = self
				data1.mins = Vector(-8, -8, -8)
				data1.maxs = Vector(8, 8, 8)
				
			local tr = util.TraceLine(data1)
			if tr.HitWorld then
				data1 = {}
				data1.start = self:GetPos() + self:OBBCenter() + Vector(0, 0, 100)
				data1.endpos = path:GetCurrentGoal().pos + self:OBBCenter() + Vector(0, 0, 100)
				data1.filter = self
				data1.mins = Vector(-8, -8, -8)
				data1.maxs = Vector(8, 8, 8)
				
				tr = util.TraceLine(data1)
				if not tr.Hit then
					self.loco:Jump()
				end
			end
		end
		
		coroutine.yield()
	end
	
	return "ok"

end

function ENT:MoveToTarget()
	if not self:GetTarget():IsValid() then return end
	
	local options = {}
	options.repath = 0.02

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( self.StopMovingDist )
	path:Compute(self, self:GetTarget():GetPos() )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update(self)
		
		local target = self:GetTarget()
		
		if self.NextFootSound < CurTime() then
			self.NextFootSound = CurTime() + 0.15
			self:EmitSound("npc/antlion/foot"..math.random(4)..".wav", 60)
		end

		if ( self.loco:IsStuck() ) then

			self:HandleStuck();
			
			return "stuck"

		end
		
		if target:IsValid() then
			if ( options.repath ) then
				if ( path:GetAge() > options.repath ) then 
					path:Compute( self, target:GetPos())
				end
			end

			if self:GetPos():Distance(target:GetPos()) <= self.StopMovingDist then
				self.loco:SetDesiredSpeed(0) 
				self:SetVelocity(Vector(0, 0, 0))
					
				if self.State == STATE_CHARGING then
					self:EmitSound("npc/antlion_guard/shove1.wav")
					if target:IsPlayer() then
						if self.Target:CanBlock(self, DMG_CRUSH, nil, 0) then
							local pos = self:NearestPoint(self:GetPos())
													
							local effect = EffectData()
								effect:SetOrigin(pos)
							util.Effect("meleeclash", effect)
													
							self.Target:ThrowFromPosition(self:GetPos(), 200)
						else
							self.Target:ThrowFromPosition(self:GetPos(), 200, true)
							self.Target:GiveStatus("knockdown", 2)
						end
					else
						self.Target:ThrowFromPosition(self:GetPos(), 200)
					end
				end
				
				self.State = STATE_IDLE
				return "ok"
			elseif path:GetCurrentGoal().pos:Distance(target:GetPos()) >= 100 then
				local data1 = {}
					data1.start = self:GetPos() + self:OBBCenter()
					data1.endpos = data1.start + self:GetForward() * 300
					data1.filter = self
					data1.mins = Vector(-8, -8, -8)
					data1.maxs = Vector(8, 8, 8)
						
				local tr = util.TraceLine(data1)
				if tr.HitWorld then
					data1.start = self:GetPos() + self:OBBCenter() + Vector(0, 0, 100)
					data1.endpos = data1.start + self:GetForward() * 300 + self:OBBCenter() + Vector(0, 0, 100)
					data1.mins = Vector(-8, -8, -8)
					data1.maxs = Vector(8, 8, 8)
					
					tr = util.TraceLine(data1)
					if not tr.Hit then
						self.loco:SetVelocity(self:GetForward() * 300)
						self.loco:Jump()
					end
				end
			end
		end
		
		coroutine.yield()
	end
end

function ENT:GetSwingPos()
	return self:GetPos() + self:OBBCenter()
end

function ENT:BehaveStart()

	self.BehaveThread = coroutine.create( function() self:RunBehaviour() end )
	
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
	util.Effect("effectdebug", effect)
			
	self:EmitSound("npc/antlion/digup1.wav")
end

function ENT:BehaveUpdate( fInterval )
	if self:GetTarget():IsValid() then
		if self.ChaseTime < CurTime() then
			self:SetTarget(NULL)
		else
			if not self:CheckTargetValidity(self:GetTarget()) then
				self:ClearTarget()
			end
		end
	else
		if self.ParentSpawner then
			if not self.ParentSpawner:IsValid() then
				self.ParentSpawner = nil
			else
				if self.ParentSpawner.HiveHealth then
					if self.ParentSpawner.HiveHealth < self.ParentSpawner.MaxHiveHealth then
						self.State = STATE_REPAIRINGHIVE
					else	
						self:FindTargetsAndSet()
					end
				end
			end
		else
			self:FindTargetsAndSet()
		end
	end
		
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then
		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );
	end
end

function ENT:RunBehaviour()
    while ( true ) do
		if self.InitialSpawn then
			self:PlaySequenceAndWait("digout")
			self.InitialSpawn = nil
			coroutine.yield()
		else
			if self:GetTarget():IsValid() then
				if self.State ~= STATE_ATTACKING and self.State ~= STATE_SWUNG then
					local dist = self:GetPos():Distance(self.Target:GetPos())
					--they're too far, so start walking
					
					if dist > 700 then
						if self.State ~= STATE_CHARGING then
							self.State = STATE_CHARGING
						end
						
						self:StartActivity( ACT_WALK )
						self.loco:SetDesiredSpeed( self.ChargeSpeed ) 
							
						self:MoveToTarget()	
					elseif self.State ~= STATE_CHARGING then
						if dist > self.StopMovingDist then
							if self.State ~= STATE_MOVING then
								self.State = STATE_MOVING
							end
							
							self:StartActivity( ACT_WALK )
							self.loco:SetDesiredSpeed( self.RunSpeed ) 
								
							self:MoveToTarget()	
							
						elseif self:CanSwing() then
							if self:IsFacing(self.Target) then
								self:StartActivity( ACT_MELEE_ATTACK1 )
								self:EmitSound("npc/antlion/attack_single"..math.random(3)..".wav")
									
								self.State = STATE_ATTACKING
								self.SwingTime = CurTime() + 0.3
							else
								self.loco:FaceTowards(self.Target:GetPos() + self.Target:OBBCenter())
							end
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
					elseif self:GetNextSwingTime() < CurTime() then
						if self.State ~= STATE_IDLE then
							self.State = STATE_IDLE
						end
					end
				end
			else
				if self.State == STATE_REPAIRINGHIVE then
					local dist = self:GetPos():Distance(self.ParentSpawner:GetPos())
					
					if dist > 140 then
						self:StartActivity(ACT_WALK)
						self.loco:SetDesiredSpeed(200)
						
						self:MoveToPos(self.ParentSpawner:GetPos(), {tolerance = 130})
					elseif not self:IsFacing(self.ParentSpawner) then
						self.loco:FaceTowards(self.ParentSpawner:GetPos() + self.ParentSpawner:OBBCenter())
					elseif self:GetNextSwingTime() < CurTime() then
						self:SetNextSwingTime(CurTime() + 0.8)
						
						self:StartActivity( ACT_MELEE_ATTACK1 )
						self:EmitSound("npc/antlion/attack_single"..math.random(3)..".wav")
						
						self.ParentSpawner:Repair(15)
						
						if self.ParentSpawner.HiveHealth >= self.ParentSpawner.MaxHiveHealth then
							self.State = STATE_IDLE
						end
					end
				else
					if self.NextIdleNoise < CurTime() then
						self.NextIdleNoise = CurTime() + 2.5
						self:EmitSound("npc/antlion/idle"..math.random(5)..".wav")
					end
						
					if self.NextIdleMove < CurTime() then
						if self.State ~= STATE_MOVING then
							self.State = STATE_MOVING
						end
						
						self:StartActivity( ACT_WALK )
						self.loco:SetDesiredSpeed( self.WalkSpeed ) 
						
						local pos = self:PickRandomSpotToMove()
						
						self:MoveToPos(pos)	

						self:StartActivity( ACT_IDLE )
						self.NextIdleMove = CurTime() + 2
					else
						if self.State ~= STATE_IDLE then
							self.State = STATE_IDLE
						end
						self:StartActivity( ACT_IDLE ) 
					end
				end
			end
		end
		coroutine.yield()
    end
end

function ENT:PickRandomSpotToMove()
	if self.ParentSpawner then
		return self.ParentSpawner:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.ParentSpawner.m_MoveRadius
	else
		return self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.MoveRadius
	end
end

function ENT:ClearTarget()
	self.Target = nil
	self.HaveTarget = false

	BroadcastLocalOverheadText("[Buzzing]", self)
end

function ENT:OnInjured2(cdmg)
	if not self:GetTarget():IsValid() then
		local target = cdmg:GetAttacker()
		if self:IsValidTargetRelation(target, G_RELATIONSHIP_NEUTRAL) or self:IsValidTargetRelation(target, G_RELATIONSHIP_HATE) then
			self:SetTarget(target)
		end

		--horde mentality: hurt one, the rest go after the same target
		for _, ally in pairs(ents.FindInSphere(self:GetPos(), 900)) do
			if ally:GetClass() == "npc_nox_charger" then
				if not ally:GetTarget():IsValid() then
					ally:SetTarget(target)
				end
			end
		end
	end
	
	self.ChaseTime = CurTime() + math.random(10, 12)
	
	if self.NextHurtSound < CurTime() then
		self.NextHurtSound = CurTime() + 1
		self:EmitSound("npc/antlion/pain"..math.random(2)..".wav")
	end
end

function ENT:Use(pl)
	if self.NextIdleNoise < CurTime() and not self:GetTarget():IsValid() then
		self:EmitSound("npc/antlion/idle"..math.random(5)..".wav")
		self.NextIdleNoise = CurTime() + 4
		self.NextIdleMove = CurTime() + 2
		
		if tonumber(pl:GetInfo("noxrp_worldsubtitles")) >= 1 then
			pl:AddLocalOverheadText("(It buzzes at you.)", self)
		end
	end
end

function ENT:OnKilled(cdmg)
	gamemode.Call("OnNPCKilled", self, cdmg:GetAttacker() or cdmg:GetInflictor() or nil, cdmg)
	self:BecomeRagdoll( cdmg )
	
	local tab = {}
	if cdmg:IsDamageType(DMG_BURN) then
		table.insert(tab, {Chance = 3, Item = "cookedmeat", Amount = 1})
	else
		table.insert(tab, {Chance = 3, Item = "rawmeat", Amount = 1})
	end
	
	self:DoKarma()
	
	self:DoDropTable(tab)
	self:DoGlobalDrop()
end
	