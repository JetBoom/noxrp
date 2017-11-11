local ITEM = {}
ITEM.DataName = "bandage"

function ITEM:ItemUse(pl)
	if not pl["status_bandage"] then
		local ent = ents.Create("status_bandage")
		if ent:IsValid() then
			ent:SetPlayer(pl)
			ent:Spawn()
			ent.Owner = self
		end
		return true
	end
	return false
end

RegisterItem(ITEM)