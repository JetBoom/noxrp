local ITEM = {}
ITEM.DataName = "cookedmeat"
ITEM.Description = "A piece of cooked meat."
	
function ITEM:Initialize()
	self:SetColor(Color(100, 100, 100))
	self.NextEmit = CurTime() + 0.1
end
	
function ITEM:LocalDraw()
	if self.NextEmit < CurTime() then
		self.NextEmit = CurTime() + 0.1
		
		local emitter = ParticleEmitter(self:GetPos())
			local particle = emitter:Add("particles/smokey", self:GetPos())
				particle:SetDieTime(1)
				particle:SetStartAlpha(20)
				particle:SetEndAlpha(0)
				particle:SetStartSize(16)
				particle:SetEndSize(14)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(Vector(0, 0, 200))
				particle:SetColor(100, 100, 100)
		emitter:Finish()
	end
end
	
function ITEM:OnRemove()
end

RegisterItem(ITEM)