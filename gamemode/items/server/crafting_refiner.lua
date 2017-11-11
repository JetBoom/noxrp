local ITEM = {}
ITEM.DataName = "crafting_refiner"

function ITEM:SetupLocalVars()
	self.Openers = {}
	self.Containers = {}
end

function ITEM:CloseAllOpeners()
	for _, pl in pairs(self:GetOpenedBy()) do
		CloseInventory(pl)
	end
end

function ITEM:AddOpener(pl)
	table.insert(self.Openers, pl)
end
	
function ITEM:RemoveOpener(pl)
	for index, play in pairs(self.Openers) do
		if play == pl then
			pl:SendLua("if LocalPlayer().v_InventoryPanelOther then LocalPlayer().v_InventoryPanelOther:FlushRemove() end")
			table.remove(self.Openers, index)
		end
	end
end

function ITEM:IsIDAnOpener(id)
	for _, opener in pairs(self.Openers) do
		if opener:IsValid() then
			if opener:GetAccountID() == id then return true end
		end
	end
	
	return false
end

function ITEM:IsPlayerAnOpener(pl)
	for _, opener in pairs(self.Openers) do
		if opener:IsValid() then
			if opener == pl then return true end
		end
	end
	
	return false
end

function ITEM:OnUseLocked(pl)
	if pl:IsPlayer() then
		if not self.Containers[pl:GetAccountID()] then
			self.Containers[pl:GetAccountID()] = Item("container__base")
		end
		
		self:AddOpener(pl)
		pl:OpenOtherInventory(self, self.Containers[pl:GetAccountID()]:GetContainer())
	end
end

function ITEM:OnTakeItem(pl, itemid)
	local sync = false
	
	if not self.Containers[pl:GetAccountID()] then
		self.Containers[pl:GetAccountID()] = Item("container__base")
		return
	end
	
	for k, v in pairs(self.Containers[pl:GetAccountID()]:GetContainer()) do
		if v:GetIDRef() == itemid then
			if pl:CanTakeItem(v, v:GetAmount()) then
			
				if v:GetData().SmeltTime then
					v:GetData().SmeltTime = nil
				end
				
				pl:InventoryAdd(v)
				
				sync = true
				
				table.remove(self.Containers[pl:GetAccountID()]:GetContainer(), k)
			end
		end
	end
	
	for k, ref in pairs(self.Containers[pl:GetAccountID()]:GetContainer()) do
		ref:SetIDRef(k)
	end

	if sync then
		pl.c_OpenedInventory:SyncToOpener(pl)
	end
	
	//self:CheckWeight()
end

function ITEM:SyncToOpener(pl)
	net.Start("sendOtherInventory")
		net.WriteTable(self.Containers[pl:GetAccountID()]:GetContainer())
	net.Send(pl)
end

function ITEM:SyncToIDOpener(id)
	local pl
	for _, v in pairs(self.Openers) do
		if v:GetAccountID() == id then pl = v break end
	end
	
	if pl then
		net.Start("sendOtherInventory")
			net.WriteTable(self.Containers[id]:GetContainer())
		net.Send(pl)
	end
end

function ITEM:GetOpenedBy()
	return self.Openers
end

function ITEM:AddItem(pl, item)
	local amount = 0
	for _, item in pairs(self.Containers[pl:GetAccountID()]:GetContainer()) do
		amount = amount + item:GetAmount()
	end
	
	if amount + item:GetAmount() <= 10 then
		if item:GetGlobalItem().Metal then
			item:GetData().SmeltTime = CurTime() + item:GetGlobalItem().SmeltTime
		end
		
		self.Containers[pl:GetAccountID()]:AddItem(item)
		
		if self:IsPlayerAnOpener(pl) then
			self:SyncToOpener(pl)
		end
		
		return true
	end
	
	return false
end

function ITEM:LocalThink()
	local updatecontainers = {}
	
	for id, container in pairs(self.Containers) do
		for i, item in pairs(container:GetContainer()) do
			if item:GetData().SmeltTime then
				if item:GetData().SmeltTime < CurTime() then
					table.insert(updatecontainers, id)
					
					local metal = Item(item:GetGlobalItem().Metal)
						metal:SetAmount(1)
						
					self.Containers[id]:AddItem(metal)
					item:SetAmount(item:GetAmount() - 1)
					
					self:EmitSound("ambient/fire/mtov_flame2.wav")

					if item:GetAmount() <= 0 then
						container:RemoveItem(item:GetIDRef())
						//table.remove(self.Containers[pl], i)
					end
				end
			elseif item:GetGlobalItem().Metal then
				item:GetData().SmeltTime = CurTime() + item:GetGlobalItem().SmeltTime
			end
		end
	end
	
	if #updatecontainers > 0 then
		for _, id in pairs(updatecontainers) do
			for i, item in pairs(self.Containers[id]:GetContainer()) do
				item:SetIDRef(i)
			end
			
			if self:IsIDAnOpener(id) then
				self:SyncToIDOpener(id)
			end
		end
	end
end

RegisterItem(ITEM)