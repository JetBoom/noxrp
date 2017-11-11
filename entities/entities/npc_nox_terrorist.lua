AddCSLuaFile()

ENT.Base 			= "npc_nox_base"
ENT.NextBot			= true


if SERVER then
	function ENT:Initialize()
		self:SetModel("models/Humans/Group01/male_0"..math.random(1, 9)..".mdl")
		
		self:SetHealth(100)
		
		self.loco:SetDeathDropHeight(500)	//default 200
		self.loco:SetAcceleration(400)		//default 400
		self.loco:SetDeceleration(400)		//default 400
		self.loco:SetStepHeight(18)			//default 18
		self.loco:SetJumpHeight(90)		//default 58
		
		self:SetCollisionBounds( Vector(-16, -16, 0), Vector(16, 16, 72) ) 
		
		self.NextIdleMove = CurTime() + 2
		self.NextPlant = CurTime() + 20
		self.RunningTo = false
		self.NextOpen = 0
		
		self.GivenTo = {}
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
			
			local targz = path:GetClosestPosition(self:GetPos()).z
			local selfz = self:GetPos().z
			
			if targz - selfz >= self.loco:GetStepHeight() or selfz - targz >= self.loco:GetStepHeight() then
				self.loco:Jump()
			end

			coroutine.yield()

		end
			
		self.Moving = false
		return "ok"
	end

	function ENT:BehaveUpdate( fInterval )
		if not self.RunningTo then
			self:GetPlayerToRunTo()
		end
		
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if string.find(v:GetClass(), "door") then
				if self.NextOpen < CurTime() then
					self.NextOpen = CurTime() + 0.5
					v:Fire("Open", "", 0)
				end
			end
		end
		
		local ok, message = coroutine.resume( self.BehaveThread )
		if ( ok == false ) then
			self.BehaveThread = nil
			Msg( self, "error: ", message, "\n" );
		end
	end

	function ENT:GetPlayerToRunTo()
		local dist = 999999
		local targ = nil
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 600)) do
			if v:IsPlayer() then
				if not self.GivenTo[v] then
					if v:GetPos():Distance(self:GetPos()) < dist then
						targ = v
						dist = v:GetPos():Distance(self:GetPos())
					end
				end
			end
		end
				
		if targ then
			self.RunningTo = targ
		end
	end

	function ENT:RunBehaviour()
		while ( true ) do
			if not self.RunningTo then
				if self.NextIdleMove < CurTime() then
					self.NextIdleMove = CurTime() + 5
					
					if self.NextPlant < CurTime() then
						self.NextPlant = self.NextPlant + 30
						
						local ent = ents.Create("planted_timebomb")
							ent:SetPos(self:GetPos())
							ent:Spawn()
							ent.Player = self
							ent.CanPickUp = false
							
						self:EmitSound("vo/npc/Barney/ba_laugh0"..math.random(4)..".wav")
						
						self:StartActivity(ACT_RUN)
						self.loco:SetDesiredSpeed(500)
						self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2500 )
					else
						self:StartActivity(ACT_WALK)
						self.loco:SetDesiredSpeed(200)
						self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 1000 )
					end
				else
					self:StartActivity(ACT_IDLE)
				end
			else
				self.loco:SetDesiredSpeed(500)
				self:StartActivity( ACT_RUN )
				
				local opts = {}
					opts.maxage = 0.1
				
				if self.RunningTo:IsValid() then
					if self.RunningTo:GetPos():Distance(self:GetPos()) < 100 then
						self:EmitSound("vo/npc/male01/ammo03.wav")
						self.GivenTo[self.RunningTo] = true
						
						local tab = Item("moneyprinter")
							tab:SetAmount(1)
						self.RunningTo:InventoryAdd(tab)
						
						self.RunningTo = false
					else
						for k, v in pairs(ents.FindInSphere(self:GetPos(), 200)) do
							if string.find(v:GetClass(), "door") then
								v:Fire("Open", "", 0)
							end
						end
						self:MoveToPos(self.RunningTo:GetPos(), opts)
					end
				end
			end
			coroutine.yield()
		end
	end

	function ENT:OnKilled( damageinfo )

		self:BecomeRagdoll( damageinfo )

		local bomb = ents.Create("item_timebomb")
			bomb:SetPos(self:GetPos() + Vector(0, 0, 10))
			bomb:Spawn()
			bomb:SetData()
	end
end