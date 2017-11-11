--[[
	Name: Police
	Aggression: If attacked or negative karma
	Desc: If they have a node path to patrol, then they walk along the path, stopping at each node for a moment. If not, then they wander around their immediate area.
		If someone with low karma or an npc attributed with low karma gets too close, they target them and fire.
	
	Attack Process: If too far or no clear line of sight, run towards them.
	If clear line of sight, fire auto-pistol.
]]


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize2()
	self:SetClassRelationships()
	
	self:SetModel( "models/police.mdl" )
	self:SetHealth(200)
	
	self.loco:SetDeathDropHeight(500)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(200)
	self.loco:SetStepHeight(18)
	self.loco:SetJumpHeight(50)
	
	self.Entity:SetCollisionBounds(Vector(-12, -12, 0), Vector(12, 12, 72) ) 
	self.Target = NULL
	self.NextAttack = 0
	self.NextWander = CurTime() + 4
	
		
	local att = "anim_attachment_RH"
	local shootpos = self:GetAttachment(self:LookupAttachment(att))
		
	local weptype = math.random(1, 2)
		
	local wep = ents.Create("prop_physics")
	wep:SetModel("models/weapons/w_pist_deagle.mdl")
		
	self.Delay = 0.12
	self.Damage = 15
	self.Cone = 0.1
	self.ShootSound = Sound("Weapon_357.Single")
	wep:SetOwner(self)
	wep:SetPos(shootpos.Pos)
	wep:Spawn()
		
	wep:SetSolid(SOLID_NONE)
	wep:SetParent(self)
	wep:Fire("setparentattachment", "anim_attachment_RH")
	wep:AddEffects(EF_BONEMERGE)
	wep:SetAngles(self:GetForward():Angle())
		
	self.Weapon = wep
	self.ChaseTime = 0
	self:SetHealth(100)
	
	self.NextEmote = 0
	self.TimeToNode = 0
	
	self.HaveTarget = false
	self.Moving = false
	
	self.WalkingToDead = false

	self.InitializedNodes = false
end

function ENT:GetAttackFilter()
	local tab = {}
	table.insert(tab, self)
	
	return tab
end

function ENT:SetClassRelationships()
	self:SetRelationshipToClass("npc_nox_zombie", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger_a", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_charger_w", G_RELATIONSHIP_HATE, 1)
	self:SetRelationshipToClass("npc_nox_police", G_RELATIONSHIP_FRIEND, 1)
	
	self:SetRelationshipToPlayers(G_RELATIONSHIP_NEUTRAL, 0)
end

function ENT:BehaveStart()
	self.BehaveThread = coroutine.create( function() self:RunBehaviour() end )
	
	--Get the closest point_policenode and move to it
	local dist = 99999
	for _, ent in pairs(ents.FindByClass("point_policenode")) do
		if ent:GetPos():Distance(self:GetPos()) < dist then
			dist = ent:GetPos():Distance(self:GetPos())
			self.TargetNode = ent
		end
	end
end

function ENT:BehaveUpdate( fInterval )
	if not self.Target:IsValid() then
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 1000)) do
			--If they're a nextbot or npc that has bad karma, shoot them
			if NPCKarma[v:GetClass()] then
				local karma = NPCKarma[v:GetClass()]
				if karma <= KARMA_CRIMINAL and v:Health() > 0 then
					self:SetTarget(v)
					break
				end
			elseif v:IsPlayer() then
				--If they're a player with low karma or have a criminal flag, attack them
				if (v:Karma() <= KARMA_CRIMINAL or v:GetCriminalFlag()) and v:Health() > 0 then
					self:SetTarget(v)
					break
				end
			end
		end
	else
		self:CheckTargetValidity()
		if self.Target:IsValid() then
			if self.Target:Health() <= 0 then
				self.WalkingToDead = self.Target:GetPos()
				
				if self.TargetNode then
					local dist = 99999
					for _, ent in pairs(ents.FindByClass("point_policenode")) do
						if ent:GetPos():Distance(self.WalkingToDead) < dist then
							self.TargetNode = ent
						end
					end
				end
						
				self.Target = NULL
				self.HaveTarget = false
			elseif self.Target:GetKarma() > KARMA_CRIMINAL and not self.Target:GetCriminalFlag() then
				self.Target = NULL
				self.HaveTarget = nil
				
				self.TimeToNode = CurTime() + 20
				
				self:EmitSound("npc/metropolice/vo/getoutofhere.wav")
				BroadcastLocalOverheadText("Get out of here.", self)
			end
		elseif self.HaveTarget then
			self.Target = NULL
			self.HaveTarget = nil
			
			self.TimeToNode = CurTime() + 20
		end
			
		if self.ChaseTime < CurTime() then
			self.Target = NULL
			self.HaveTarget = nil
			
			self:EmitSound("npc/metropolice/vo/suspectlocationunknown.wav")
			BroadcastLocalOverheadText("Suspect location unknown.", self)
			
			self.TimeToNode = CurTime() + 20
		end
	end

	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then
		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );
	end
end

function ENT:GetTarget()
	return self.Target
end

function ENT:SetTarget(target)
	self.Target = target
	
	if target then
		self.WalkingToDead = nil
		self.ChaseTime = CurTime() + math.random(10, 12)
		
		if self.NextEmote < CurTime() then
			self.NextEmote = CurTime() + 10
			self:EmitSound("npc/metropolice/takedown.wav")
			BroadcastLocalOverheadText("Take him down!", self)
		end
	end
end

function ENT:SomeoneCalled(pl, attacker)
	if attacker:GetClass() ~= "npc_nox_police" then
		self:SetTarget(attacker)
	end
end

function ENT:MoveToPos( pos, options )

	local options = options or {}
	options.maxage = options.maxage or 30

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end
	
	self.Moving = true

	while ( path:IsValid() ) do
		path:Update( self )

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()

			return "stuck"
		end

		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		
		//This is basically for if they get stuck in a door (meaning someone tried to shoot them and bring them into a building)
		if (options.maxage) then
			if path:GetAge() > options.maxage then
				//Move them to the closest node. Police should always have a node path to follow, or at least close to a node anyway
				for _, ent in pairs(ents.FindByClass("point_policenode")) do
					if ent:GetSelfID() == self.TargetNode:GetTargetID() then
						self:SetPos(ent:GetPos() + Vector(0, 0, 5))
						return "ok"
					end
				end
			end
		end
			
		if self.Target:IsValid() and not self.HaveTarget then
			--this is to break the walking, so if someone shoots it, it doesn't wait until it stops walking before turning to the target; it just breaks the walking immediately
			self.HaveTarget = true
			return "ok"
		end
		
		if self.TimeToNode and self.TargetNode then
			if self.TimeToNode < CurTime() then
				self:SetPos(self.TargetNode:GetPos())
				self.TimeToNode = nil
				return "ok"
			end
		end
		
		if path:GetCurrentGoal() then
			if self.Target:IsValid() then	
				local data = {}
				local tab = ents.FindByClass("projectile_asbullet")
				table.insert(tab, self)
					
					data.start = self:GetPos() + self:GetShootPos()
					data.endpos = self.Target:GetPos() + self.Target:OBBCenter()
					data.filter = tab
				local tr = util.TraceLine(data)
			
				if tr.Entity == self.Target then
					return "ok"
				elseif not self.OpeningDoor then
					for _, door in pairs(ents.FindInSphere(self:GetPos() + self:OBBCenter(), 60)) do
						if string.find(door:GetClass(), "door") then
							self.OpeningDoor = door
							return "ok"
						end
					end
				end
			else
				local data = {}
					data.start = self:GetPos() + self:OBBCenter()
					data.endpos = path:GetCurrentGoal().pos + self:OBBCenter()
					data.filter = self
				local tr = util.TraceLine(data)
				
				if tr.Entity:IsValid() then
					if not self.OpeningDoor then
						if string.find(tr.Entity:GetClass(), "door") then
							self.OpeningDoor = tr.Entity
							self.PathTarget = path:GetCurrentGoal().pos
							return "ok"
						end
					end
				end
			end
		end

		coroutine.yield()
	end
		
	self.Moving = false
	return "ok"
end

function ENT:RunBehaviour()
    while ( true ) do
		if self.OpeningDoor then
			if self.t_KickingDoor then
				if self.t_KickingDoor < CurTime() then
					self.OpeningDoor:Fire("unlock", "0")
					self.OpeningDoor:Fire("open", "0")
						
					self:StartActivity( ACT_RUN_PISTOL )
					self.loco:SetDesiredSpeed(80)
					self:MoveToPos(self:GetPos() - self:GetForward() * 60 + self:GetRight() * math.Rand(-10, 10))
						
					self.OpeningDoor = nil
					self.PathTarget = nil
					self.t_KickingDoor = nil
				end
			else
				local sequence = self:LookupSequence( "adoorkick" )
				self:SetSequence( sequence )
				self.t_KickingDoor = CurTime() + 1.8
			end
			coroutine.yield()
		else
			if not self.Target:IsValid() then
				//If we're moving to go laugh at someone
				if self.WalkingToDead then
					self:StartActivity( ACT_WALK_PISTOL )
					self.loco:SetDesiredSpeed(80)
					self:MoveToPos(self.WalkingToDead)
						
					self.WalkingToDead = nil
						
					self:EmitSound("npc/metropolice/vo/chuckle.wav")
					BroadcastLocalOverheadText("[Laughs]", self)
				elseif self.NextWander <= CurTime() then
					self:StartActivity( ACT_WALK_PISTOL )
					self.loco:SetDesiredSpeed(80)
					
					local nextpos
					if self.TargetNode then
						nextpos = self.TargetNode:GetPos()
						for _, ent in pairs(ents.FindByClass("point_policenode")) do
							if ent:GetSelfID() == self.TargetNode:GetTargetID() then
								self.TargetNode = ent
								break
							end
						end
					else
						nextpos = self:GetPos() + self:GetRight() * math.Rand(-1, 1) * 300 + self:GetForward() * math.Rand(-1, 1) * 300
					end
					
					self:MoveToPos(nextpos)

					self:StartActivity( ACT_IDLE_PISTOL )
					self.NextWander = CurTime() + 4
				else
					self:StartActivity( ACT_IDLE_PISTOL )
				end
			else
				if self.Target:IsValid() then		
					local data = {}
					local tab = ents.FindByClass("projectile_asbullet")
					table.insert(tab, self)
					
						data.start = self:GetPos() + self:GetShootPos()
						data.endpos = self.Target:GetPos() + self.Target:OBBCenter()
						data.filter = tab
					local tr = util.TraceLine(data)
					
					if tr.Entity ~= self.Target then --don't have a clear shot
						local pos = self.Target:GetPos()
						local dir = (pos - self:GetPos()):GetNormalized()
						
						self.loco:SetDesiredSpeed(300) 
						
						self:StartActivity( ACT_RUN_PISTOL )
						
						self:MoveToPos(pos)
						
						self:StartActivity( ACT_IDLE_PISTOL )
					else
						local pos = self.Target:GetPos() + self.Target:OBBCenter()
						local shootpos = self:GetPos() + self:GetShootPos()
						self.loco:FaceTowards(pos)

						self:StartActivity( ACT_RANGE_AIM_PISTOL_LOW )
						
						
						if self.NextAttack < CurTime() then
							self.NextAttack = CurTime() + self.Delay
							self:EmitSound(self.ShootSound)

							local ang = AngleCone((pos - shootpos):Angle(), self.Cone)

							CreateBullet(self:GetPos() + self:GetShootPos(), ang:Forward(), self, self, self.Damage, 2900, "projectile_asbullet", false, true)
						end
					end
				else
					self.Target = NULL
				end
			end
		end

        coroutine.yield()
    end
end

function ENT:OnInjured(cdmg)
	local attacker = cdmg:GetAttacker()
	cdmg:SetDamage(0)
	//Until the respawning system is up for police, we're not going to let them be killed
	//Otherwise we would have to have admins sit here 24/7 just to respawn cops because someone will inevitably kill one
	//if self:Health() <= 0 then
	//	self:OnKilled(cdmg)
	//	self.Weapon:Remove()
	//end
	
	if attacker:GetClass() ~= "npc_nox_police" and not self.Target:IsValid() then
		self:SetTarget(attacker)
	end
	
	if self.NextEmote < CurTime() then
		self.NextEmote = CurTime() + 0.7
		self:EmitSound("npc/metropolice/pain"..math.random(1, 4)..".wav")
	end
end

function ENT:OnKilled(cdmg)
	gamemode.Call("OnNPCKilled", self, cdmg:GetAttacker() or cdmg:GetInflictor() or nil, cdmg)
	self:BecomeRagdoll( cdmg )
end

function ENT:OnOtherKilled( ... )
end

function ENT:OnRemove()
end