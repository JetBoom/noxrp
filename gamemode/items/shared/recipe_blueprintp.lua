local ITEM = {}
ITEM.DataName = "recipe_blueprintp"
ITEM.Model = "models/props_junk/garbage_newspaper001a.mdl"
ITEM.Name = "Recipe"
ITEM.ItemWeight = 0
ITEM.Base = "_base"
ITEM.Category = "other"
ITEM.BasePrice = 1500
ITEM.Usable = true
ITEM.DestroyOnUse = true

function ITEM:GetItemName(pl, item)
	if item then
		local data = item.Data
		local amt = pl:GetItemCountByID(item.IDRef)
			
		if data.Recipe and data.RecipeAmount then
			local recipe = data.Recipe
			local itemamt = data.RecipeAmount

			local gblitem = ITEMS[RECIPEES[recipe].FinishedItems[1][1]]
			
			if itemamt > 1 then
				return self.Name.." ["..gblitem.Name.."] ("..itemamt..")"
			else
				return self.Name.." ["..gblitem.Name.."]"
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