function EFFECT:Init( data )
	self.Entity = data:GetEntity()
	local col = data:GetColor()
	if col == 1 then
		self.Color = Color(150, 20, 20)
	elseif col == 2 then
		self.Color = Color(20, 20, 150)
	end
end

function EFFECT:Think()
	if self.Entity:IsValid() then
		local pos = self.Entity:GetPos()
		self:SetPos(pos)
		local emitter = ParticleEmitter(pos)
		
		for i = 1, 2 do
			local particle = emitter:Add("particle/smokestack", pos + VectorRand() * math.Rand(2, 4))
				particle:SetVelocity(VectorRand() * 100)
				particle:SetDieTime(math.Rand(0.4, 0.6))
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(20)
				particle:SetEndSize(30)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand( -1, 1))
				if self.Color then
					particle:SetColor(self.Color.r, self.Color.g, self.Color.b)
				else
					particle:SetColor(10, 10, 10)
				end
				particle:SetAirResistance(50)
				particle:SetCollide(true)
				particle:SetBounce(0.5)
		end
		
		emitter:Finish()
	end
	
	return self.Entity:IsValid()
end

function EFFECT:Render()
end
