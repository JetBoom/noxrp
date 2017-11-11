local ITEM = {}
ITEM.DataName = "recipe_blueprintp"

function ITEM:PostSetData()
	if self.Data.Recipe then
		local gblitem = ITEMS[RECIPEES[self.Data.Recipe].FinishedItems[1][1]]
		self:SetDisplayName("Recipe ["..gblitem.Name.."]")
	end
end


function ITEM:ItemUse(pl, id)
	if id.Data.Recipe and id.Data.RecipeAmount then
		if not pl:KnowRecipe(id.Data.Recipe) then
			pl:LearnRecipe(id.Data.Recipe)
			return true
		else
			pl:SendInventory("You already know this recipe.")
		end
		return false
	end
	return false
end

RegisterItem(ITEM)