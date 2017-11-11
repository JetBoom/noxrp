local ITEM = {}
ITEM.DataName = "gib"

ITEM.Description = "Part of someone's long dead body."
	
function ITEM:Initialize()
	self:SetColor(Color(255, 0, 0))
	
	self.Emitter = ParticleEmitter(self:GetPos())
	self.NextEmit = CurTime() + 0.1
end
	
function ITEM:LocalDraw()
end

RegisterItem(ITEM)