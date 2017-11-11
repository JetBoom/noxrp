local ITEM = {}
ITEM.DataName = "blueprint"
ITEM.Model = "models/props_lab/binderredlabel.mdl"
ITEM.Name = "Blueprint"
ITEM.ItemWeight = 0
ITEM.Category = ITEM_CAT_DEPLOY
ITEM.Usable = true
ITEM.DestroyOnUse = true

function ITEM:GetItemName(pl, item)
	if item then
		local data = item.Data
		local amt = pl:GetItemCountByID(item.IDRef)
			
		if data.Blueprint then
			local name = BLUEPRINTS[data.Blueprint].Name
			
			if amt > 1 then
				return self.Name.." ["..name.."] ("..amt..")"
			else
				return self.Name.." ["..name.."]"
			end
		else
			return self.Name
		end
	else
		if self.GetDisplayName then
			return self:GetDisplayName()
		else
			return self.Name
		end
	end
end

RegisterItem(ITEM)