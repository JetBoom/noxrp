AddCSLuaFile()

ENT.Base = "npc_nox_base"
ENT.NextBot			= true

function ENT:Initialize2()
	self:SetClassRelationships()
	
	self:SetModel( "models/police.mdl" )
	self:SetHealth(200)
	
	self.loco:SetDeathDropHeight(500)
	self.loco:SetAcceleration(200)
	self.loco:SetDeceleration(200)
	self.loco:SetStepHeight(18)
	self.loco:SetJumpHeight(50)
	
	self.Entity:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72) ) 
	self.Target = nil
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
	
	self.HaveTarget = false
	self.Moving = false
	
	self.WalkingToDead = false
	self.Frozen = false
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

function ENT:BehaveUpdate( fInterval )
	if self.Frozen then return end
	
	if not self.Target and not WalkingToDead then
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 2000)) do
			if NPCKarma[v:GetClass()] then
				local karma = NPCKarma[v:GetClass()]
				if karma <= KARMA_CRIMINAL and v:Health() > 0 then
					self:SetTarget(v)
					break
				end
			elseif v:IsPlayer() then
				if v:Karma() <= KARMA_CRIMINAL and v:Health() > 0 then
					self:SetTarget(v)
					break
				end
				
				if not self.TargetBecauseWeapon then
					if v:GetPos():Distance(self:GetPos()) < 400 then
						if v:GetActiveWeapon():IsValid() and v:GetActiveWeapon():GetClass() ~= "weapon_melee_fists" then
							if not v:GetActiveWeapon():GetHolstered() then
								self.TargetBecauseWeapon = v
								self.TargetWeaponTime = CurTime() + 8
								
								self:EmitSound("npc/metropolice/vo/citizen.wav")
								BroadcastLocalOverheadText("Citizen, put it away.", self)
							end
						end
					end
				else
					if self.TargetBecauseWeapon:GetActiveWeapon():IsValid() then
						if self.TargetBecauseWeapon:GetActiveWeapon():GetHolstered() then
							self.TargetBecauseWeapon = nil
							self.TargetWeaponTime = nil
							self.TargetWeapon_FinalWarning = nil
							
							self:EmitSound("npc/metropolice/vo/allrightyoucango.wav")
							BroadcastLocalOverheadText("Alright, you can go.", self)
						elseif self.TargetWeaponTime < CurTime() then
							self:SetTarget(self.TargetBecauseWeapon)
							
							self.TargetBecauseWeapon = nil
							self.TargetWeaponTime = nil
							self.TargetWeapon_FinalWarning = nil
						elseif not self.TargetWeapon_FinalWarning then
							if self.TargetWeaponTime < (CurTime() + 3) then
								self.TargetWeapon_FinalWarning = true
								self:EmitSound("npc/metropolice/vo/finalwarning.wav")
								BroadcastLocalOverheadText("Final warning. Put it away.", self)
							end
						end
					else
						self.TargetBecauseWeapon = nil
						self.TargetWeaponTime = nil
						self.TargetWeapon_FinalWarning = nil
					end
				end
			end
		end
	else
		self:CheckTargetValidity()
		if self.Target:IsValid() then
			if self.Target:Health() <= 0 then
				self.Target = nil
				self.HaveTarget = nil
			end
		elseif self.HaveTarget then
			self.Target = nil
			self.HaveTarget = nil
		end
		
		if self.ChaseTime < CurTime() then
			self:SetTarget(nil)
			self.HaveTarget = false
			self:EmitSound("npc/metropolice/vo/suspectisbleeding.wav")
			BroadcastLocalOverheadText("Suspect is bleeding!", self)
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
		self.ChaseTime = CurTime() + math.random(10, 12)
		
		if self.NextEmote < CurTime() then
			self.NextEmote = CurTime() + 10
			self:EmitSound("npc/metropolice/takedown.wav")
			BroadcastLocalOverheadText("Take him down!", self)
		end
	end
end

function ENT:SomeoneCalled(pl, attacker)
	self:SetTarget(attacker)
end

function ENT:MoveToPos( pos, options )

	local options = options or {}
	options.maxage = options.maxage or 5

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end
	
	self.Moving = true

	while ( path:IsValid() ) do
		if not self.Frozen then
			path:Update( self )

			if ( options.draw ) then
				path:Draw()
			end

			if ( options.maxage ) then
				if ( path:GetAge() > options.maxage ) then return "timeout" end
			end

			if ( options.repath ) then
				if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
			end
			
			if self.Target and not self.HaveTarget then
				--this is to break the walking, so if someone shoots it, it doesn't wait until it stops walking before turning to the target; it just breaks the walking immediately
				self.HaveTarget = true
				return "ok"
			elseif self.Target then
				local data = {}
					data.start = self:GetShootPos()
					data.endpos = self.Target:GetPos() + self.Target:OBBCenter()
					data.filter = self
				local tr = util.TraceLine(data)
				
				if tr.Entity == self.Target then
					return "ok"
				end
			end
		end

		coroutine.yield()

	end
		
	self.Moving = false
	return "ok"
end

function ENT:GetShootPos()
	return self:GetPos() + Vector(0, 0, 60) + self:GetForward() * 2
end

function ENT:RunBehaviour()
    while ( true ) do
		if self.Frozen then coroutine.yield() end
		if not self.Target then
			if self.NextWander <= CurTime() and not self.TargetBecauseWeapon then
				self:StartActivity( ACT_WALK_PISTOL )
				self.loco:SetDesiredSpeed(80)
				self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )

				self:StartActivity( ACT_IDLE_PISTOL )
				self.NextWander = CurTime() + 4
			else
				self:StartActivity( ACT_IDLE_PISTOL )
				
				if self.TargetBecauseWeapon then
					self.loco:FaceTowards(self.TargetBecauseWeapon:GetPos() + self.TargetBecauseWeapon:OBBCenter())
				end
				
				if self.WalkingToDead then
					self:StartActivity( ACT_WALK_PISTOL )
					self:MoveToPos( self.WalkingToDead, {maxage = 5} )
					
					self.WalkingToDead = nil
					
					self:EmitSound("npc/metropolice/vo/chuckle.wav")
					BroadcastLocalOverheadText("[Laughs]", self)
				end
			end
		else
			if self.Target:IsValid() then
				local data = {}
					data.start = self:GetShootPos()
					data.endpos = self.Target:GetPos() + self.Target:OBBCenter()
					data.filter = self
				local tr = util.TraceLine(data)
				
				if tr.Entity ~= self.Target then --don't have a clear shot
					local pos = self.Target:GetPos()
					local dir = (pos - self:GetPos()):GetNormalized()
					
					self.loco:SetDesiredSpeed(300) 
					
					self:StartActivity( ACT_RUN_PISTOL )
					
					self:MoveToPos(pos)
					
					self:StartActivity( ACT_IDLE_PISTOL )
				else
					local dir = (self.Target:GetPos() - Vector(0,0,60) - self:GetPos() + self.Target:OBBCenter()):GetNormalized()
					local pos = self.Target:GetPos() + self.Target:OBBCenter()
					self.loco:FaceTowards(pos)

					self:StartActivity( ACT_RANGE_AIM_PISTOL_LOW )
					
					
					if self.NextAttack < CurTime() then
						self.NextAttack = CurTime() + self.Delay
						self:EmitSound(self.ShootSound)

						local ang = AngleCone((pos - self:GetShootPos()):Angle(), self.Cone)

						CreateBullet(self:GetShootPos(), ang:Forward(), self, self, self.Damage, 2900, "projectile_asbullet", false, true)
						
					 --[[	local bullet = {}
						bullet.Num 		= 1
						bullet.Src 		= self:GetPos() + Vector(0,0,60)
						bullet.Dir 		= dir
						bullet.Spread 	= Vector(self.Cone, self.Cone, 0)
						bullet.Tracer	= 1
						bullet.TracerName = "Tracer"
						bullet.Force	= 1
						bullet.Damage	= self.Damage
						bullet.AmmoType = "pistol"
						bullet.Attacker = self
						bullet.Inflictor = self
						bullet.DamageType = DMG_BULLET
						
						self:FireBullets( bullet )]]
						if self.Target:Health() <= 0 then			
							self.WalkingToDead = self.Target:GetPos()
							
							self.loco:SetDesiredSpeed(200)
							self:MoveToPos(self.Target:GetPos())
						
							self.Target = nil
							self.HaveTarget = false
							coroutine.yield()
						end
					end
				end
			else
				self.Target = nil
			end
		end
        coroutine.yield()
    end
end

function ENT:OnInjured(cdmg)
	if self.Frozen then return end
	local attacker = cdmg:GetAttacker()
	
	if self:Health() <= 0 then
		self:OnKilled(cdmg)
		self.Weapon:Remove()
	end
	
	if attacker:GetClass() ~= "npc_nox_police" and not self.Target then
		self:SetTarget(attacker)
	end
	
	if self.NextEmote < CurTime() then
		self.NextEmote = CurTime() + 0.7
		self:EmitSound("npc/metropolice/pain"..math.random(1, 4)..".wav")
	end
end

local randomemotes = {
	{"npc/metropolice/vo/citizen.wav", "Citizen."},
	{"npc/metropolice/vo/examine.wav", "Examining."},
	{"npc/metropolice/vo/isreadytogo.wav", "Ready to go."}
}

local randomemotes_p = {
	{"npc/metropolice/vo/clearandcode100.wav", "Clear and code 100."},
	{"npc/metropolice/vo/code100.wav", "Code 100."},
	{"npc/metropolice/vo/isreadytogo.wav", "Ready to go."}
}

function ENT:Use(pl)
	if self.NextEmote < CurTime() and not self.Target then
		local emote = randomemotes[math.random(#randomemotes)]
		self:EmitSound(emote[1])
		self.NextEmote = CurTime() + 4
		
		if emote[2] then
			local tab = {}
				tab.Color = Color(200, 200, 255, 255)
				tab.Text = emote[2]
				tab.LifeTime = 5
			BroadcastLocalOverheadText(tab, self)
		end
		self:SetAngles((pl:GetPos() - self:GetPos()):GetNormalized():Angle())
	end
end

function ENT:Freeze(bool)
	self.Frozen = bool
end

function ENT:OnKilled(cdmg)
	gamemode.Call("OnNPCKilled", self, cdmg:GetAttacker() or cdmg:GetInflictor() or nil, cdmg)
	self:BecomeRagdoll( cdmg )
end

function ENT:OnOtherKilled( ... )
end

function ENT:GetVarsToSave()
	return {}
end
	