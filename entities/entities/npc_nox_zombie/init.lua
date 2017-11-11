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

local STATE_IDLE = 0
local STATE_MOVING = 1
local STATE_ATTACKING = 2
local STATE_SWUNG = 3

function ENT:Initialize2()
	self:SetClassRelationships()

	self:SetModel("models/Zombie/Classic.mdl")
	self:SetHealth(100)
	
	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(400)		//default 400
	self.loco:SetDeceleration(2000)		//default 400
	self.loco:SetStepHeight(14)			//default 18
	self.loco:SetJumpHeight(100)		//default 58
	self.loco:SetMaxYawRate(720)
	
	self:SetCollisionBounds( Vector(-12, -12, 0), Vector(12, 12, 72) ) 
	
	self.Damage = 9
	self.DamageType = DMG_SLASH
	self.DamageRange = 130
	self.DamageBox = Vector(8, 8, 8)
	
	self.RunSpeed = 110
	self.WalkSpeed = 60
	
	self.StopMovingDist = 100
	
	self.Karma = -6000
	self.KarmaLimit = 500
	
	self:SetState(STATE_IDLE)
	
	if self.ParentSpawner then
		self.MoveRadius = self.ParentSpawner.m_MoveRadius
		self.MoveCenterVec = self.ParentSpawner:GetPos()
	else
		self.MoveRadius = 400
	end
	
	self.ChaseTime = 0
	self.NextAttack = 0
	self.SwingTime = 0
	self.NextIdleMove = 0
	
	self.NextFootSound = 0
	self.NextIdleNoise = 0
	self.NextHurtSound = 0
	self.NextEmote = 0
	self.Target = NULL
	self.NextTarget = 0
	
	self.InitialSpawn = CurTime() + 2
	self.HaveTarget = false
end

//Setup all relations with other classes and players
function ENT:SetClassRelationships()
	self:SetRelationshipToClass("npc_nox_zombie", G_RELATIONSHIP_FRIEND, 1)
	
	self:SetRelationshipToPlayers(G_RELATIONSHIP_HATE, 0)
end

function ENT:GetDefaultRelationship()
	return {Relationship = G_RELATIONSHIP_HATE, Intensity = 1}
end

function ENT:PlaySequenceAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1
	
	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed  );
	
	if self:GetTarget():IsValid() then
		self.loco:FaceTowards(target:GetPos() + target:OBBCenter())
	end

	-- wait for it to finish
	coroutine.wait( len / speed )

end

//If they are created by a hive
function ENT:SetParentSpawner(ent)
	self.ParentSpawner = ent
	self.MoveRadius = ent.m_MoveRadius
	self.MoveCenterVec = ent:GetPos()
end

function ENT:SetState(state)
	self.State = state
end

function ENT:OnTargetSet(target)
	self.ChaseTime = CurTime() + math.random(12, 14)
	
	self:EmitSound("npc/zombie/zombie_alert"..math.random(1, 3)..".wav")
	
	local tab = {}
		tab.Color = Color(255, 180, 180, 255)
		tab.Text = "(It groans.)"
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
	self:SetNextSwingTime(CurTime() + 0.5)

	local data = {}
	data.start = self:GetPos() + self:OBBCenter()
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
		
		if ent.CanBleed then
			local bleedchance = math.random(6)
			
			if bleedchance == 1 then
				ent:GiveStatus("bleeding", 5)
			end
		end
		
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
		
		if self:GetTarget():IsValid() and not self.HaveTarget then
			self.HaveTarget = true
			return "ok"
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
	path:Compute(self, self:GetTarget():GetPos())

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update(self)
		
		local target = self:GetTarget()
		
		if self.NextFootSound < CurTime() then
			self.NextFootSound = CurTime() + 0.15
			self:EmitSound("npc/zombie/foot"..math.random(3)..".wav")
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
				self.State = STATE_IDLE
				return "ok"
			end
			
			if self.NextTarget < CurTime() then
				if self:GetTarget() != self:GetLargestDamager() and self:GetLargestDamager():IsValid() then
					self:SetTarget(self:GetLargestDamager())
					self.NextTarget = CurTime() + 5
					return "ok"
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
end

function ENT:BehaveUpdate( fInterval )
	if self:GetTarget():IsValid() then
		if self.NextTarget < CurTime() then
			if self:GetTarget() != self:GetLargestDamager() and self:GetLargestDamager():IsValid() then
				self:SetTarget(self:GetLargestDamager())
				self.NextTarget = CurTime() + 5
			end
		end
		
		if self.ChaseTime < CurTime() then
			self:ClearTarget()
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
				self:FindTargetsAndSet()
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
		if self:GetTarget():IsValid() then
			local target = self:GetTarget()
			if self.State ~= STATE_ATTACKING and self.State ~= STATE_SWUNG then
				local dist = self:GetPos():Distance(target:GetPos())
				--they're too far, so start walking
				
				if dist > self.StopMovingDist then
					if self.State ~= STATE_MOVING then
						self.State = STATE_MOVING
					end
						
					self:StartActivity( ACT_WALK )
					self.loco:SetDesiredSpeed( self.RunSpeed ) 
						
					self:MoveToTarget()	
					
					self:StartActivity( ACT_IDLE )
						
				elseif self:CanSwing() then
					if self:IsFacing(target) then
						self:StartActivity( ACT_MELEE_ATTACK1 )
						self:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav")
								
						self.State = STATE_ATTACKING
						self.SwingTime = CurTime() + 0.5
					else
						self.loco:FaceTowards(target:GetPos() + target:OBBCenter())
					end
				end
			else
				if self.State == STATE_ATTACKING then
					if self.SwingTime < CurTime() then
						self.State = STATE_SWUNG
						self:Swing()
					else
						self.loco:FaceTowards(target:GetPos() + target:OBBCenter())
					end
				elseif self:GetNextSwingTime() < CurTime() then
					if self.State ~= STATE_IDLE then
						self.State = STATE_IDLE
					end
				end
			end
		else
			if self.NextIdleNoise < CurTime() then
				self.NextIdleNoise = CurTime() + 2.5
				self:EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav")
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
	self.Target = NULL
	self.HaveTarget = false

	BroadcastLocalOverheadText("[It loses interest.]", self)
end

function ENT:OnInjured2(cdmg)
	if not self:GetTarget():IsValid() then
		local target = cdmg:GetAttacker()
		if self:IsValidTargetRelation(target, G_RELATIONSHIP_NEUTRAL) or self:IsValidTargetRelation(target, G_RELATIONSHIP_HATE) then
			self:SetTarget(target)
		end

		--horde mentality: hurt one, the rest go after the same target
		for _, ally in pairs(ents.FindInSphere(self:GetPos(), 900)) do
			if ally:GetClass() == "npc_nox_zombie" then
				if not ally:GetTarget():IsValid() then
					ally:SetTarget(target)
				end
			end
		end
	end
	
	self.ChaseTime = CurTime() + math.random(10, 12)
	
	if self.NextHurtSound < CurTime() then
		self.NextHurtSound = CurTime() + 1
		self:EmitSound("npc/zombie/zombie_pain"..math.random(6)..".wav")
	end
end

function ENT:Use(pl)
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
	
	table.insert(tab, {Chance = 1, Item = "money", Amount = math.random(10, 35)})
	
	self:DoKarma()
	
	self:DoDropTable(tab)
	self:DoGlobalDrop()
end
	