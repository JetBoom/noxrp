AddCSLuaFile()

ENT.Base 			= "npc_nox_base"
ENT.NextBot			= true

local STATE_IDLE = 0
local STATE_MOVING = 1
local STATE_ATTACKING = 2
local STATE_SWUNG = 3

function ENT:Initialize2()
	self:SetClassRelationships()

	self:SetModel( "models/antlion.mdl" )
	self:SetMaterial("models/debug/debug_white")
	self:SetHealth(60)
	
	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(700)		//default 400
	self.loco:SetDeceleration(1400)		//default 400
	self.loco:SetStepHeight(20)			//default 18
	self.loco:SetJumpHeight(100)		//default 58
	
	self.NextIdleMove = 0
	self:SetCollisionBounds( Vector(-12, -12, 0), Vector(12, 12, 24) ) 
	self:SetModelScale(0.5, 0)
	self.NextAttack = 0
	
	self:SetColor(Color(0, 0, 0, 255))
	
	self.State = STATE_IDLE
	
	self.MoveRadius = 400
	
	self.NextAttack = 0
	self.SwingTime = 0
	
	self.Damage = 5
	self.DamageType = DMG_SLASH
	self.DamageRange = 90
	self.DamageBox = Vector(8, 8, 8)
	self.SwingDelay = 0.1
	
	self.StopMovingDist = 70
	
	self.NextFootSound = 0
	self.NextIdleNoise = 0
	self.NextHurtSound = 0
	self.NextEmote = 0
	self.NextSearch = 0
	self.Searching = 0
	self.Target = NULL
	
	local effect = EffectData()
		effect:SetEntity(self)
	util.Effect("reaversmoke", effect)
	
	self.ImmuneToType = 1
end

function ENT:GetDefaultRelationship()
	return {Relationship = G_RELATIONSHIP_HATE, Intensity = 99}
end

function ENT:SetClassRelationships()
	self:SetRelationshipToPlayers(G_RELATIONSHIP_HATE, 1)
end

function ENT:GetTarget()
	return self.Target
end

function ENT:OnTargetSet(target)
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
	self:SetNextSwingTime(CurTime() + self.SwingDelay)
	
	local data = {}
	data.start = self:GetPos() + Vector(0, 0, self:OBBCenter().z)
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
		
		local bleedchance = math.random(6)
		
		if bleedchance == 1 then
			ent:GiveStatus("bleeding", 5)
		end
		
		self.Target:EmitSound("physics/body/body_medium_impact_hard"..math.random(1, 6)..".wav")
		self.Target:ThrowFromPosition(self:GetPos(), 20)
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
			self.NextFootSound = CurTime() + 0.15
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
		
		local targz = path:GetClosestPosition(self:GetPos()).z
		local selfz = self:GetPos().z
		
		if targz - selfz >= self.loco:GetStepHeight() or selfz - targz >= self.loco:GetStepHeight() then
			self.loco:Jump()
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
	if not self.Target:IsValid() then return end
	
	local options = {}
	options.repath = 0.1

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute(self, self.Target:GetPos())

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update(self)
		
		if self.NextFootSound < CurTime() then
			self.NextFootSound = CurTime() + 0.1
			self:EmitSound("npc/antlion/foot"..math.random(4)..".wav", 60)
		end
		
		if not self.Target:IsValid() then
			return "failed"
		end

		if ( self.loco:IsStuck() ) then

			self:HandleStuck();
			
			return "stuck"

		end
		
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then 
				path:Compute( self, self.Target:GetPos())
			end
		end
		
		if path:GetEnd():Distance(self:GetPos()) <= 120 then
			return "ok"
		end
		coroutine.yield()

	end
end

function ENT:GetSwingPos()
	return self:GetPos() + self:OBBCenter()
end

function ENT:BehaveUpdate( fInterval )
	if self.Target:IsValid() then	
		local targ = self:CheckTargetValidity()
		if targ then
			local dist = self:GetPos():Distance(self.Target:GetPos())
			if dist <= 130 then
				if self.State ~= STATE_ATTACKING then
					if not self:IsFacing(self.Target) then
						self.loco:FaceTowards(self.Target:GetPos() + self.Target:OBBCenter())
					end
				end
			end
		else
			self:ClearTarget()
		end
	elseif self.Searching < CurTime() then
		self:FindTargetsAndSet()
	end
		
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then
		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );
	end
end

function ENT:RunBehaviour()
    while ( true ) do
		--If we have a target
		if self:GetTarget():IsValid() then
			--If we aren't attacking then try to decide what to do
			if self.State ~= STATE_ATTACKING and self.State ~= STATE_SWUNG then
				local dist = self:GetPos():Distance(self.Target:GetPos())
				--they're too far, so start walking
				if dist > self.StopMovingDist then
					self.State = STATE_MOVING
					self:StartActivity( ACT_WALK )                            -- walk anims
					self.loco:SetDesiredSpeed( 700 ) 
						
					self:MoveToTarget()	
				--if they're close, then try to swing
				elseif self:CanSwing() then
					if self:IsFacing(self.Target) then
						self:StartActivity( ACT_MELEE_ATTACK1 )
						self:EmitSound("npc/antlion/attack_single"..math.random(3)..".wav")
							
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
			self:TakeDamage(50)
		end
		coroutine.yield()
    end
end

function ENT:ClearTarget()
	self.Target = NULL
	self.HaveTarget = false

	self.Searching = CurTime() + 2
end

function ENT:OnInjured(cdmg)
	if self.ImmuneToType == 1 and cdmg:IsDamageType(DMG_BULLET) then
		cdmg:SetDamage(0)
	elseif self.ImmuneToType == 2 and cdmg:IsDamageType(DMG_CLUB) then
		cdmg:SetDamage(0)
	end
	
	if self.NextHurtSound < CurTime() then
		self.NextHurtSound = CurTime() + 1
		self:EmitSound("npc/antlion/pain"..math.random(2)..".wav")
	end
end

function ENT:OnKilled(cdmg)
	gamemode.Call("OnNPCKilled", self, cdmg:GetAttacker() or cdmg:GetInflictor() or nil, cdmg)

	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
	util.Effect("gib", effect)
	
	self:EmitSound("physics/body/body_medium_break2.wav")
	
	self:Remove()
end
	