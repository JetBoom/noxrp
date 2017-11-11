local ITEM = {}
ITEM.DataName = "burntmeat"

ITEM.Description = "A piece of burnt meat."
	
function ITEM:Initialize()
	self:SetColor(Color(40, 40, 40))
	self.NextEmit = CurTime() + 0.1
end
	
function ITEM:LocalDraw()
	if self.NextEmit < CurTime() then
		self.NextEmit = CurTime() + 0.1
		local emit = ParticleEmitter(self:GetPos())
		if emit then
			local particle = emit:Add("particles/smokey", self:GetPos())
				particle:SetDieTime(1)
				particle:SetStartAlpha(40)
				particle:SetEndAlpha(0)
				particle:SetStartSize(16)
				particle:SetEndSize(14)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetGravity(Vector(0, 0, 200))
				particle:SetColor(100, 100, 100)
		end
		emit:Finish()
	end
end
	
function ITEM:OnRemove()
end

RegisterItem(ITEM)