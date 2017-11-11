AddCSLuaFile()

ENT.Base 			= "npc_nox_charger"
ENT.IsNPC			= true

local STATE_IDLE = 0
local STATE_MOVING = 1
local STATE_ATTACKING = 2
local STATE_SWUNG = 3
local STATE_SPITTING = 4
local STATE_SPITED = 5

function ENT:Initialize2()
	self:SetClassRelationships()

	self:SetModel( "models/antlion.mdl" )
	self:SetHealth(100)
	
	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(400)		//default 400
	self.loco:SetDeceleration(1400)		//default 400
	self.loco:SetStepHeight(14)			//default 18
	self.loco:SetJumpHeight(100)		//default 58
	
	self.NextIdleMove = 0
--	self:SetCollisionBounds( Vector(-16, -16, 0), Vector(16, 16, 48) ) 
	self.Entity:SetCollisionBounds( Vector(-12,-12,0), Vector(12,12,64) )
	self.NextAttack = 0
	
	self.State = STATE_IDLE
	
	if self.ParentSpawner then
		self.MoveRadius = self.ParentSpawner.m_MoveRadius
		self.MoveCenterVec = self.ParentSpawner:GetPos()
	else
		self.MoveRadius = 400
	end
	
	self.ChaseTime = 0
	self.NextAttack = 0
	self.SwingTime = 0
	self.LastSpit = 0
	
	
	self.NextFootSound = 0
	self.NextIdleNoise = 0
	self.NextHurtSound = 0
	self.NextEmote = 0
end

function ENT:SetClassRelationships()
	self:SetRelationshipToClass("npc_nox_zombie", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_charger_a", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_charger_w", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_police", G_RELATIONSHIP_HATE, 1)
	
	self:SetRelationshipToPlayers(G_RELATIONSHIP_NEUTRAL, 0)
end

function ENT:Spit()
	self:SetNextSwingTime(CurTime() + 0.7)
	self:EmitSound("npc/antlion/attack_single"..math.random(3)..".wav")
	
	local shock = ents.Create("projectile_acidball")
	if shock then
		shock:SetPos(self:GetPos() + Vector(0, 0, 30))
		shock:SetAngles(self:GetAngles())
		shock:SetOwner(self)
		shock:Spawn()
		shock:SetDestination(self.Target:GetPos())
		--	shock.Target = self.Target
	end
end

function ENT:GetSwingPos()
	return self:GetPos() + self:OBBCenter()
end

function ENT:BehaveUpdate( fInterval )
	if self.Target then
		self:CheckTargetValidity()
		if self.Target:IsValid() then
			local dist = self:GetPos():Distance(self.Target:GetPos())
			if dist <= 130 then
				if self.State ~= STATE_ATTACKING then
					if not self:IsFacing(self.Target) then
						self.loco:FaceTowards(self.Target:GetPos() + self.Target:OBBCenter())
					end
				end
			end
			
			if self.State == STATE_ATTACKING then
				if self.SwingTime < CurTime() then
					self.State = STATE_SWUNG
					self:Swing()
				end
			elseif self.State == STATE_SPITTING then
				if self.SwingTime < CurTime() then
					self.State = STATE_SPITED
					self:Spit()
				end
			end
			
			if self.ChaseTime < CurTime() then
				self:ClearTarget()
			end
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

function ENT:RunBehaviour()
    while ( true ) do
		if not self.Target then
			if self.NextIdleMove < CurTime() then
				if self.State ~= STATE_MOVING then
					self.State = STATE_MOVING
				end
				self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed( 200 ) 
				local pos
				
				if self.ParentSpawner then
					pos = self.MoveCenterVec + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.MoveRadius
				else
					pos = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.MoveRadius
				end
				
				self:MoveToPos( pos, opts )	

				self:StartActivity( ACT_IDLE )
				self.NextIdleMove = CurTime() + 2
			else
				if self.State ~= STATE_IDLE then
					self.State = STATE_IDLE
				end
				self:StartActivity( ACT_IDLE ) 
				if self.NextIdleNoise < CurTime() then
					self.NextIdleNoise = CurTime() + 2.5
					self:EmitSound("npc/antlion/idle"..math.random(5)..".wav")
				end
			end
		elseif self.Target:IsValid() then
			local dist = self:GetPos():Distance(self.Target:GetPos())
			if dist >= 400 then
				if (self.LastSpit + 4) < CurTime() then
					self.LastSpit = CurTime()
					
					self:StartActivity( ACT_MELEE_ATTACK1 )
					self.State = STATE_SPITTING
					self.SwingTime = CurTime() + 0.4
				else
					self:StartActivity( ACT_RUN )
					self.loco:SetDesiredSpeed(1100)
					
				--	self:MoveToTarget()	
					self:MoveToPos(self.Target:GetPos(), {repath = 0.1})
				end	
			elseif dist > 115 and self.State ~= STATE_ATTACKING then
				if self.State ~= STATE_MOVING then
					self.State = STATE_MOVING
				end
				
				self:StartActivity( ACT_RUN )
				self.loco:SetDesiredSpeed(1100)				
				self:MoveToTarget()	
				
			elseif self:CanSwing() and self.State ~= STATE_ATTACKING then
				self.loco:SetDesiredSpeed(0)
				if self:IsFacing(self.Target) then
					self:StartActivity( ACT_MELEE_ATTACK1 )
					
					self.State = STATE_ATTACKING
					self.SwingTime = CurTime() + 0.4
				end
			end
			
			if self.Target then
				if self.Target:Health() <= 0 then
					self:ClearTarget()
					coroutine.yield()
				end
			end
		end
		coroutine.yield()
    end
end