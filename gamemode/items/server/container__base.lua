local ITEM = {}
ITEM.DataName = "container__base"
ITEM.IsBase = true

function ITEM:PostSetData()
	self.Openers = {}
	--	self:CheckWeight()
end
	
function ITEM:OnTakeItem(pl, itemid)
	local sync = false
	
	for k, v in pairs(self.Data:GetContainer()) do
		if v:GetIDRef() == itemid then
			if pl:CanTakeItem(v, v:GetAmount()) then
				pl:InventoryAdd(v)
				
				sync = true
				
				table.remove(self.Data:GetContainer(), k)
			end
		end
	end

	if sync then
		pl.c_OpenedInventory:SyncToOpeners()
	end
	
	self:CheckWeight()
end
	
function ITEM:CheckWeight()
	local weight = self.ItemWeight
	for _, item in pairs(self.Data:GetContainer()) do
		weight = weight + item:GetWeight()
	end
		
	self.Data:SetWeight(weight)
end

function ITEM:AddItem(pl, item)
	local amount = 0
	for _, item in pairs(self.Data:GetContainer()) do
		amount = amount + item:GetAmount()
	end
	
	if amount + item:GetAmount() <= self.MaxItems then
		self.Data:AddItem(item)
		
		self:SyncToOpeners()
		
		return true
	end
	
	return false
end
	
function ITEM:SyncToOpeners()
	net.Start("sendOtherInventory")
		net.WriteTable(self.Data:GetContainer())
	net.Send(self:GetOpenedBy())
end

function ITEM:SyncToOpener(pl)
	net.Start("sendOtherInventory")
		net.WriteTable(self.Containers[pl]:GetContainer())
	net.Send(pl)
end

function ITEM:IsPlayerAnOpener(pl)
	for _, opener in pairs(self.Openers) do
		if opener == pl then return true end
	end
	
	return false
end

function ITEM:CloseAllOpeners()
	for _, pl in pairs(self:GetOpenedBy()) do
		CloseInventory(pl)
	end
end

function ITEM:OnUseLocked(pl)
	if pl:IsPlayer() then
		self:AddOpener(pl)
		pl:OpenOtherInventory(self, self.Data:GetContainer())
	end
end
	
function ITEM:AddOpener(pl)
	table.insert(self.Openers, pl)
end
	
function ITEM:RemoveOpener(pl)
	for index, play in pairs(self.Openers) do
		if play == pl then
			table.remove(self.Openers, index)
		end
	end
end
	
function ITEM:GetOpenedBy()
	return self.Openers
end

RegisterItem(ITEM)