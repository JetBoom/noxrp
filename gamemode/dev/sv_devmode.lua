mapedit = {}

util.AddNetworkString("createEntityDev")

local function ReceiveCreateEntityDev(len, pl)
	if not pl:IsSuperAdmin() then return end
	
	local tab = net.ReadTable()
	local tr = util.TraceLine({start = pl:GetShootPos(), endpos = pl:GetShootPos() + pl:GetAimVector() * 9999, filter=pl})
	
	local entity = ents.Create(tab.Type)
		entity:SetPos(tr.HitPos)
		entity:Spawn()
		
	for var, value in pairs(tab.Vars) do
		if DEV_ENTITIES[tab.Type][var] then
			DEV_ENTITIES[tab.Type][var]:Func(entity, value)
		end
	end
end
net.Receive("createEntityDev", ReceiveCreateEntityDev)

function mapedit.Spawn(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	
	local ent = tostring(args[1])
	if ent then
		local item = ents.Create(ent)
		item:SetPos(pl:GetEyeTrace(9999).HitPos)
		item:Spawn()
		
		noxrp.SaveMapFile()
	end
end
concommand.Add("noxrp_dev_spawn", mapedit.Spawn, nil, "Same as ent_create without needing sv_cheats.")

function mapedit.CreateLockedDownItem(pl,cmd,args)
	if not pl:IsSuperAdmin() then return end
	
	local pos = pl:GetEyeTrace(500).HitPos
	
	local ent = tostring(args[1])
	if ent then
		local item = ents.Create(ent)
		item:SetPos(pos)
		item:Spawn()
		item:SetData()
		
		item:SetLockedDown(true)
		
		local phys = item:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
		
		noxrp.SaveMapFile()
	end
end
concommand.Add("noxrp_dev_createlockeddownitem", mapedit.CreateLockedDownItem, nil, "Creates an item that is already locked down at the trace pos. [<string> Item Class]")

function mapedit.EditItemAngles(pl,cmd,args)
	if not pl:IsSuperAdmin() then return end
	
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 9999
	trace.filter = pl
	local tr = util.TraceLine(trace)
	
	local targ = tr.Entity
	if targ:IsValid() then
		local p = tonumber(args[1])
		local y = tonumber(args[2])
		local r = tonumber(args[3])
			
		tr.Entity:SetAngles(tr.Entity:GetAngles() + Angle(p,y,r))
	end
end
concommand.Add("noxrp_dev_edititemang",mapedit.EditItemAngles, nil, "Edits the angles of the entity. <[Double] P/Y/R>")

function mapedit.EditItemPosition(pl,cmd,args)
	if not pl:IsSuperAdmin() then return end
	
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 9999
	trace.filter = pl
	local tr = util.TraceLine(trace)
	
	local targ = tr.Entity
	if targ:IsValid() then
		local x = tonumber(args[1])
		local y = tonumber(args[2])
		local z = tonumber(args[3])
			
		targ:SetPos(targ:GetPos()+Vector(x,y,z))
	end
end
concommand.Add("noxrp_dev_edititempos",mapedit.EditItemPosition, nil, "Edits the position of the entity. <[Double] X/Y/Z>")

function mapedit.RemoveItem(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	
	local tr = pl:GetEyeTrace(9999)
	
	local targ = tr.Entity
	if targ:IsValid() then
		targ:Remove()
	end
end
concommand.Add("noxrp_dev_removeitem",mapedit.RemoveItem, nil, "Removes the entity.")

function AdminRemoveItems(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	
	local class = tostring(args[1])
	if class == "" or args[1] == nil then return end
	local radius = tonumber(args[2])
	if radius == 0 or args[2] == nil then return end
	
	local tr = pl:GetEyeTrace(9999)
	if tr.Hit then
		for k, v in pairs(ents.FindInSphere(tr.HitPos, radius)) do
			if v:GetClass() == class then
				print("Removed "..tostring(v))
				v:Remove()
			end
		end
	end
end
concommand.Add("noxrp_dev_removeitems", AdminRemoveItems, nil, "Removes the given entity in a given radius. [<string> Entity Name | <integer> Radius]")

function GiveItem(pl,cmd,args)
	if not pl:IsSuperAdmin() then return end
	
	local item = tostring(args[1])
	local amt = tonumber(args[2]) or 1
	
	if ITEMS[item] then
		pl:InventoryAdd(Item(item, amt))
	end
end
concommand.Add("noxrp_dev_giveitem", GiveItem)

function GiveStatusCmd(pl,cmd,args)
	if not pl:IsSuperAdmin() then return end
	
	local sts = tostring(args[1])
	pl:GiveStatus(sts)
end
concommand.Add("noxrp_dev_givestatus",GiveStatusCmd)

function RemoveStatusCmd(pl,cmd,args)
	if not pl:IsSuperAdmin() then return end
	
	local sts = tostring(args[1])
	pl:RemoveStatus(sts, true, true)
end
concommand.Add("noxrp_dev_removestatus",RemoveStatusCmd)

function MerchantAddItem(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	local item = tostring(args[1])
	
	local tr = pl:GetEyeTrace(200)
	
	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "npc_merchant" then
			local gblitem = ITEMS[item]
			
			if gblitem then
				local item = Item(item)
				tr.Entity:AddLocalItem(item)
				
				pl:ChatPrint("[ADMIN]: Added '"..gblitem.Name.."' to the merchant.")
			end
		end
	end
end
concommand.Add("noxrp_dev_addmerchantitem", MerchantAddItem)

function MerchantRemoveItem(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	local number = tonumber(args[1])
	local tr = pl:GetEyeTrace(200)
	
	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "npc_merchant" then
			if tr.Entity.Inventory[number] then
				pl:ChatPrint("[ADMIN]: Removed '"..tr.Entity.Inventory[number]:GetItemName().."' from the merchant.")
				
				table.remove(tr.Entity.Inventory, number)
			end
		end
	end
end
concommand.Add("noxrp_dev_removemerchantitem", MerchantRemoveItem)

function MerchantSetName(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	local title = ""
	for _, txt in pairs(args) do
		title = title..tostring(txt).." "
	end
	local tr = pl:GetEyeTrace(200)
	
	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "npc_merchant" then
			tr.Entity:SetMerchantTitle(title)
		end
	end
end
concommand.Add("noxrp_dev_merchantsetname", MerchantSetName)

function ClearMerchantInventory(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	local item = tostring(args[1])
	
	local tr = pl:GetEyeTrace(200)
	
	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "npc_merchant" then
			table.Empty(tr.Entity.Inventory:GetContainer())
			pl:ChatPrint("[ADMIN]: Cleared merchant "..tostring(tr.Entity).." inventory.")
		end
	end
end
concommand.Add("noxrp_dev_merchantclearinventory", ClearMerchantInventory)

function UpdateMerchantPrices(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	local item = tostring(args[1])
	
	local tr = pl:GetEyeTrace(200)
	
	if tr.Entity:IsValid() then
		if tr.Entity:GetClass() == "npc_merchant" then
			tr.Entity:RefreshPrices()
			pl:ChatPrint("[ADMIN]: Refreshed merchant "..tostring(tr.Entity).." prices.")
		end
	end
end
concommand.Add("noxrp_dev_merchantupdateprices", UpdateMerchantPrices)