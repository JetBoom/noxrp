local ITEM = {}
ITEM.DataName = "crafting_engineering"

ITEM.Draw3DName = true
ITEM.Name3DPos = Vector(-20, 20, 10)
ITEM.Name3DAng = Angle(0, 180, 90)
ITEM.Name3DScale = 0.05
ITEM.NoRotateForEyes = true
	
ITEM.Description = "You can create various mechanical devices here.\nNeeds to be locked down to use."

function ITEM:Initialize()
	self.AmbientSound = CreateSound(self, "ambient/machines/machine6.wav")
end
	
function ITEM:Think()
	self.AmbientSound:PlayEx(0.7, 100 + math.sin(CurTime()))
end
	
function ITEM:OnRemove()
	self.AmbientSound:Stop()
end

RegisterItem(ITEM)