AddCSLuaFile()

ENT.Base 			= "npc_nox_charger"
ENT.NextBot			= true

local STATE_IDLE = 0
local STATE_MOVING = 1
local STATE_ATTACKING = 2
local STATE_SWUNG = 3
local STATE_CHARGING = 4

function ENT:Initialize2()
	self:SetClassRelationships()

	self:SetModel( "models/antlion.mdl" )
	self:SetHealth(100)
	
	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(400)		//default 400
	self.loco:SetDeceleration(1400)		//default 400
	self.loco:SetStepHeight(14)			//default 18
	self.loco:SetJumpHeight(100)		//default 58
	
--	self:SetCollisionBounds( Vector(-16, -16, 0), Vector(16, 16, 48) ) 
	self.Entity:SetCollisionBounds( Vector(-12, -12, 0), Vector(12, 12, 48) )
	
	self.Damage = 8
	self.DamageType = DMG_SLASH
	self.DamageRange = 100
	self.DamageBox = Vector(12, 12, 12)
	
	self.StopMovingDist = 100
	
	self:SetState(STATE_IDLE)
	
	self.MoveRadius = 400
	
	self.ChaseTime = 0
	self.NextAttack = 0
	self.SwingTime = 0
	self.NextIdleMove = 0
	
	self.NextFootSound = 0
	self.NextIdleNoise = 0
	self.NextHurtSound = 0
	self.NextEmote = 0
end

function ENT:PickRandomSpotToMove()
	return self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.MoveRadius
end