AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local STATE_IDLE = 0
local STATE_MOVING = 1
local STATE_ATTACKING = 2
local STATE_SWUNG = 3
local STATE_CHARGING = 4

function ENT:Initialize2()
	self:SetClassRelationships()

	self:SetModel( "models/antlion.mdl" )
	self:SetHealth(160)
	
	self.loco:SetDeathDropHeight(500)	//default 200
	self.loco:SetAcceleration(400)		//default 400
	self.loco:SetDeceleration(1600)		//default 400
	self.loco:SetStepHeight(20)			//default 18
	self.loco:SetJumpHeight(100)		//default 58
	
	self:SetCollisionBounds( Vector(-12, -12, 0), Vector(12, 12, 48) )
	
	self:SetColor(Color(255, 180, 180, 255))
	
	self.Damage = 12
	self.DamageType = DMG_SLASH
	self.DamageRange = 140
	self.DamageBox = Vector(9, 9, 9)
	
	self.ChargeSpeed = 1400
	self.RunSpeed = 800
	self.WalkSpeed = 160
	
	self.StopMovingDist = 60
	
	--How much karma they are 'considered' to have
	self.Karma = -3000
	--If a player with more karma than this kills one, then they don't gain any extra karma.
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
end

function ENT:SetClassRelationships()
	self:SetRelationshipToClass("npc_nox_zombie", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_charger_a", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_charger_w", G_RELATIONSHIP_FRIEND, 1)
	self:SetRelationshipToClass("npc_nox_police", G_RELATIONSHIP_HATE, 1)
	
	self:SetRelationshipToPlayers(G_RELATIONSHIP_HATE, 0)
end

function ENT:GetDefaultRelationship()
	return {Relationship = G_RELATIONSHIP_HATE, Intensity = 1}
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
	