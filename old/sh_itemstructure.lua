-- TODO: Replace IDRef with UniqueID
-- TODO: Replace useless references to GetGlobalItem and ITEMS[
-- TODO: .ItemWeight -> .Weight
-- TODO: GetTotalWeight -> GetWeight and GetWeight -> GetWeightOne
-- TODO: .DataName -> ._TYPE
-- TODO: GetDataName -> GetType
-- TODO: Remove usage of Item.Data and GetData()
-- TODO: When an item is saved, check that its members don't equal the base members. And save those members.
-- TODO: Entities will have to have a ItemID variable attached to them.
	-- GetItem will return Items[self:GetItemID()].
	-- Clients will not know about these however. It's up to the entities themselves to network item variables outside of inventories.

-- This is a way to store all the currently ACTIVE items on the server in an easy-to-reference data structure.
-- All items, regardless of what they happen to be, have a unique ID from GetUID() when they're created.
-- Items stores an Item object and uses the UID (a number) as the key.
-- Whenever an Item OBJECT is created, it is added to this table. All values in the table are weak (__mode = "v").
-- The Item object in this table is garbage collected if it ceases to exist in the world ie, not anywhere except this table.

Items = {}
if SERVER then
	setmetatable(Items, {__mode = "v"})
end
-- The client just sort of has to absorb the resource hogging from this since lag and PVS can cause items to be garbage collected when they shouldn't be.
-- TODO: A better system that garbage collects correctly on both ends.

Item = {}

local meta = {__index = Item}

function Item.IsItem(object)
	return getmetatable(object) == meta
end

function meta:__tostring()
	return self.Name
end

function meta:__eq(other)
	return other ~= nil and Item.IsItem(other) and other.DataName == self.DataName and table.Compare(self:GetData(), other:GetData())
end

-- __index is for when you index a nil key. So if we index a nil key, return the value of our prototype.
-- If we do an assignment to a nil key, we only change the value of this instance, not the prototype.
function meta:__index(key)
	return self:GetGlobalItem()[key]
end

function Item:GetGlobalItem()
	return GetGlobalItem(self:GetDataName())
end

function Item:SetAmount(amt)
	self.Amount = amt
end

function Item:GetAmount()
	return self.Amount or 1
end

function Item:SetIDRef(id)
	self.IDRef = id
end

function Item:GetIDRef()
	return self.IDRef
end

function Item:GetType()
	return self._TYPE
end

function Item:GetItemName()
	if self:GetGlobalItem().GetItemName then
		return self:GetGlobalItem():GetItemName(self) or self:GetBaseName()
	end

	return self:GetBaseName()
end

function Item:GetBaseName()
	return self.Name or self._TYPE
end

function Item:SetItemName(name)
	self.Name = name
end

function Item:SetData(data)
	self.Data = data
end

function Item:GetData()
	return self.Data
end

function Item:SetWeight(weight)
	self.Weight = weight
end

function Item:GetWeight()
	return self.Weight or 1
end

function Item:GetTotalWeight()
	return self:GetWeight() * self:GetAmount()
end

function Item:GetModel()
	return self.Model or "models/error.mdl"
end

function Item:SetModel(mdl)
	self.Model = mdl
end

--This is pretty much just overridden
function Item:OnInteractWith(pl, ent2)
end

function Item:TransferLiquids(pl, to, froment, toent)
	if not self.IsLiquidContainer then return end

	pl.v_ContainerTransferAmount = pl.v_ContainerTransferAmount or 10

	local fromcontents = self:GetContainer() or {}
	local tocontents = to:GetContainer() or {}

	local totalvol1 = 0

	for k, v in pairs(fromcontents) do
		totalvol1 = totalvol1 + v:GetAmount()
	end

	local totalvol2 = 0

	for k, v in pairs(tocontents) do
		totalvol2 = totalvol2 + v:GetAmount()
	end

	local transfer = math.Round((pl.v_ContainerTransferAmount or 1) / #fromcontents, 4)

	--If we have more room than we need for the amount we're transferring, then transfer all of the liquid
	if (toent.ContainerVolume - totalvol2) >= pl.v_ContainerTransferAmount then
		for k, v in pairs(fromcontents) do
			local tab = Item(v:GetDataName())
				tab:SetAmount(math.min(transfer, v:GetAmount()))

			if toent:AcceptInteraction(tab) then
				toent:TransferLiquid(tab)
			end

			v:SetAmount(v:GetAmount() - tab:GetAmount())
		end

		pl:SendNotification("You transfer "..transfer.." units of the solution to the "..to:GetItemName()..".", 4, Color(255, 255, 255), nil, 1)
	elseif (toent.ContainerVolume - totalvol2) > 0 then
		local newamt = math.Round((pl.v_ContainerTransferAmount - totalvol2) / #fromcontents, 4)
		for k, v in pairs(fromcontents) do
			local tab = Item(v:GetDataName())
				tab:SetAmount(math.min(newamt, v.Volume))

			if toent:AcceptInteraction(tab) then
				toent:TransferLiquid(tab)
			end

			v:SetAmount(v:GetAmount() - tab:GetAmount())
		end

		pl:SendNotification("You transfer some of the solution to the "..to.Data:GetItemName()..".", 4, Color(255, 255, 255), nil, 1)
	else
		pl:SendNotification("The "..to:GetDisplayName().." is full.", 4, Color(255, 255, 255), nil, 1)
	end

	froment:SortContents()
	toent:SortContents()
end

-- TODO: needs to be rewritten
function Item:GetCopy()
	local item = Item(self:GetDataName())
	item:SetModel(self:GetModel())
	item:SetData(table.Copy(self:GetData()))
	item:SetItemName(self:GetItemName())
	item:SetAmount(self:GetAmount())
	if self.IsContainer or self.IsLiquidContainer then
		item:SetContainer(table.Copy(self:GetContainer()))
	end

	return item
end

function Item:GetContainer()
	if not self.Items then
		self.Items = {}
	end

	return self.Items
end

function Item:SetContainer(cont)
	self.Items = cont
end

function Item:CanAddItem(item)
	local gitem = GetGlobalItem(item:GetDataName())

	if not self.IsContainer and not self.IsLiquidContainer then return false end

	--TODO: Make it count total number of items rather than number of unique items
	if self.MaxItems then
		if #self.Items >= self.MaxItems then
			return false
		end
	end

	--If we're a liquid container and its a liquid, then make sure we have enough volume
	if self.IsLiquidContainer and gitem.IsLiquid then
		local totalvol = 0
		for _, child in pairs(self:GetContainer()) do
			totalvol = totalvol + child:GetAmount()
		end

		if totalvol + item:GetAmount() > self.Data.ContainerVolume then print("too much water 5/7") return false end

		return true
	end

	--If we're not a liquid container, then don't try to put liquids in it
	if not self.IsLiquidContainer and gitem.IsLiquid then return false end

	return true
end

--Return true if we added the item to our container of items
--Return false if we did not for some reason
function Item:AddItem(item)
	local added = false

	if self.IsContainer or self.IsLiquidContainer then

		if not self:CanAddItem(item) then return false end

		for index, tabitem in pairs(self:GetContainer()) do
			if tabitem:GetDataName() == item:GetDataName() and tabitem:GetItemName() == item:GetItemName() and not item.IsContainer then
				if table.Compare(tabitem:GetData(), item:GetData()) then
					tabitem:SetAmount(tabitem:GetAmount() + item:GetAmount())

					added = true
					break
				end
				added = false
				break
			end
		end

		if not added then
			item:SetIDRef(#self.Items + 1)
			table.insert(self.Items, item)
		end

		return true
	end

	return false
end

function Item:DestroyItem(id, amount)
	local refresh = false

	for i, itemtab in pairs(self:GetContainer()) do
		if itemtab and itemtab:GetIDRef() == id then
			if itemtab:GetAmount() <= amount then
				refresh = i
				break
			else
				itemtab:SetAmount(itemtab:GetAmount() - amount)
			end

			break
		end
	end

	if refresh then
		table.remove(self:GetContainer(), refresh)
		return true
	end

	return false
end

function Item:RemoveItem(id)
	local refresh = false

	for i, itemtab in pairs(self:GetContainer()) do
		if itemtab and itemtab:GetIDRef() == id then
			refresh = i
			break
		end
	end

	if refresh then
		table.remove(self:GetContainer(), refresh)
		return true
	end

	return false
end

function Item:SetItems(tab)
	if self.IsContainer or self.IsLiquidContainer then
		self.Items = tab
	end
end

function Item:EmptyItems()
	if self.IsContainer or self.IsLiquidContainer then
		self.Items = {}
	end
end

function Item:Serialize()
	-- TODO
end

function Item:Deserialize(data)
	-- TODO
end

function Item:new(dataname, amount, data)
	local item = {}
	setmetatable(item, meta)

	item._TYPE = dataname

	if not data then -- A brand new item
		item._ID = GetUID()

		local gitem = GetGlobalItem(dataname)
		if gitem then
			if gitem.IsContainer or gitem.IsLiquidContainer then
				item.Items = {}
			end

			if gitem.Durability then
				item.Durability = 0
				item.MaxDurability = 150
			end

			if item.OnItemCreation then
				item:OnItemCreation()
			end
		end
	end

	-- Plop it in to the global table of items
	Items[item._ID] = item

	return item
end

setmetatable(Item, {__call = Item.new})
