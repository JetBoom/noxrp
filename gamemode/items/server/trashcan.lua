local ITEM = {}
ITEM.DataName = "trashcan"

function ITEM:OnUseLocked(act)
	for _, ent in pairs(ents.FindInSphere(self:GetPos(), 22)) do
		if string.sub(ent:GetClass(), 1, 5) == "item_" then
			if not ent:GetLockedDown() then
				ent:Remove()
			end
		end
	end
end

RegisterItem(ITEM)