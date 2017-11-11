ENT.Type = "anim"
AddCSLuaFile()

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_eq_flashbang_thrown.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		self.DieTime = CurTime() + 2.5
	end
	
	function ENT:Think()
		if self.DieTime < CurTime() then
			for _, pl in pairs(ents.FindInSphere(self:GetPos(), 1000)) do
				if pl:IsPlayer() then
					local dist = pl:GetPos():Distance(self:GetPos())
					local dir = (self:GetPos() - pl:GetPos()):GetNormalized()
					
					local data = {}
						data.start = pl:GetShootPos()
						data.endpos = data.start + dir * dist
						data.filter = pl
						
					local tr = util.TraceLine(data)
					PrintTable(tr)
					if tr.Entity == self or tr.Fraction == 1 then
						local intensity = pl:GetFacingAccuracy(self, pl:GetAimVector())
						if intensity > 0 then
							pl:GiveStatus("flashbanged", intensity * 2)
							
							if intensity > 1 then
								pl:SetDSP(32)
							end
						end
					end
				end
			end
			
			self:EmitSound("weapons/flashbang/flashbang_explode"..math.random(2)..".wav")
			
			local effect = EffectData()
				effect:SetOrigin(self:GetPos())
				effect:SetMagnitude(5)
			util.Effect("genericrefractring", effect)
			
			self:Remove()
		end
		
		if self.Data then
			local data = self.Data
			self.Data = nil
			
			self:SetLocalAngularVelocity(self:GetLocalAngularVelocity() * 0.6)
			if data.Speed > 50 then
				self:EmitSound("weapons/smokegrenade/grenade_hit1.wav")
			end
		end
		
		if self.DieTime < CurTime() then
			self:Remove()
		end
	end
	
	function ENT:PhysicsCollide(data)
		self.Data = data
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Think()
		if not self.Emitter then
			self.Emitter = ParticleEmitter(self:GetPos(), false)
		end
		
		self.Emitter:SetPos(self:GetPos())
		
		local smoke = self.Emitter:Add("particles/smokey", self:GetPos() + self:GetUp() * 6)
			smoke:SetVelocity(Vector(math.Rand(-1, 1),math.Rand(-1, 1), 0) * 2)
			smoke:SetDieTime(math.Rand(0.7, 0.9))
			smoke:SetStartAlpha(200)
			smoke:SetEndAlpha(0)
			smoke:SetStartSize(1)
			smoke:SetEndSize(0.5)
			smoke:SetRoll(math.Rand(0, 360))
			smoke:SetRollDelta(math.Rand(-5, 5))
			smoke:SetColor(255, 255, 255)
			smoke:SetGravity(Vector(0, 0, 50))
			smoke:SetColor(150, 150, 150)
	end
	
	function ENT:OnRemove()
		self.Emitter:Finish()
		
		local dlight = DynamicLight(self:EntIndex())
		if ( dlight ) then
			dlight.Pos = self:GetPos() + Vector(0, 0, 2)
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 10
			dlight.Decay = 2000
			dlight.Size = 500
			dlight.DieTime = CurTime() + 0.5
		end
	end
end