WORLDRECIPES = {}
CHEMISTRYCOMBOS = {}

function RegisterWorldRecipe(INFO)
	WORLDRECIPES[#WORLDRECIPES + 1] = INFO
end

function RegisterChemistryRecipe(INFO)
	CHEMISTRYCOMBOS[#CHEMISTRYCOMBOS + 1] = INFO
end

function CheckWorldRecipe(entity)
end

function CheckChemistryRecipe(ent)
	for k, recipe in pairs(CHEMISTRYCOMBOS) do
		local items = ent.Data:GetContainer()
		
		//If the recipe requires the item to be a certain entity type, then check it
		if recipe.RequiredEntity then
			if ent:GetClass() != recipe.RequiredEntity then
				continue
			end
		end
		
		//If we have a temperature requirement, then make sure we're in the range
		if recipe.IsInTemperatureRange then
			if not recipe:IsInTemperatureRange(ent) then continue end
		end
		
		local didall = {}

		//Get the amount of all reagents that this recipe requires
		for item, volume in pairs(recipe.RequiredReagents) do
			for _, cont in pairs(items) do
				if cont:GetDataName() == item and cont:GetAmount() >= volume then
					didall[item] = cont:GetAmount()
					break
				end
			end
		end
		
		--We have to manually count because string indexes are not counted when we do #table
		local amt = 0
		for _, t in pairs(didall) do
			amt = amt + 1
		end
		
		local req = {}
		local reqamt = 0
		for item, vol in pairs(recipe.RequiredReagents) do
			req[item] = vol
			reqamt = reqamt + 1
		end

		if amt == reqamt then
			local scale = 999999999
					
			for item, vol in pairs(didall) do
				if math.floor(vol / recipe.RequiredReagents[item]) < scale then
					scale = math.floor(vol / recipe.RequiredReagents[item])
				end
			end
			
			local itemstocopy = {}
			local itemstokeep = {}
			for index, item in pairs(ent.Data:GetContainer()) do
				if req[item:GetDataName()] then
					//Subtract the amount that we need
					local amounttaken = scale * req[item:GetDataName()]
					print("We're taking "..amounttaken.." units for this recipe.")
					item:SetAmount(item:GetAmount() - amounttaken)
					
					local tab = Item(item:GetDataName())
						tab:SetAmount(amounttaken)
					table.insert(itemstocopy, tab)
					
					if item:GetAmount() > 0 then
						table.insert(itemstokeep, item)
					end
				else
					if item:GetAmount() > 0 then
						table.insert(itemstokeep, item)
					end
				end
			end
			
			ent.Data:SetItems(itemstokeep)
				
			//recipe:BuildRecipe(entity we checked the recipe in, the scale of the recipe, the items we used, the items we didn't use)
			recipe:BuildRecipe(ent, scale, itemstocopy, itemstokeep)
			
			if ent:IsValid() then
				--This is mostly to get rid of empty items, meaning if we make a recipe that uses all of the water we have (GetAmount() = 0), then just delete that item
				if ent.SortContents then
					ent:SortContents()
				end
			end
			
			break
		end
	end
end

local dataitems = file.Find("gamemodes/noxrp/gamemode/worldrecipes/*.lua", "GAME")
for k,v in pairs(dataitems) do
	include("worldrecipes/"..v)
end
