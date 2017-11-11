local ITEM = {}
ITEM.DataName = "chemistrygrenade"

function ITEM:SortContents()
	local tab = {}

	//If the item does not have an amount of 0, then save the item
	for _, item in pairs(self.Data:GetContainer()) do
		if item:GetAmount() > 0 then
			--print("Sorting item: "..tostring(item), item:GetDataName())
			local added = false

			//See if we already added it to the tab table, if we have then add the amounts
			for index, tabitem in pairs(tab) do
				if tabitem:GetDataName() == item:GetDataName() then
					tabitem:SetAmount(tabitem:GetAmount() + item:GetAmount())
					added = true

					break
				end
			end

			//If it wasn't already in the tab table, then add it
			if not added then
				table.insert(tab, item)
			end
		end
	end

	table.Empty(self.Data:GetContainer())

	self.Data:SetItems(tab)
end

RegisterItem(ITEM)