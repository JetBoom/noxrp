function DropItemCon(pl, cmd, args)
	local itemid = tonumber(args[1])
	local itemref = pl:GetItemByID(itemid)

	if itemref then
		local item = ITEMS[itemref:GetDataName()]
		local amount = tonumber(args[2]) or 1
		if amount < 1 then amount = 1 end

		if item.Weapon then
			pl:DropWeapon(itemid, amount)
		else
			pl:DropItem(itemid, amount)
		end
	end
end
concommand.Add("dropitem", DropItemCon)

local meta = FindMetaTable("Player")
if not meta then return end

util.AddNetworkString( "sendInventory" )
util.AddNetworkString( "updateInventoryItem" )
util.AddNetworkString( "sendOtherInventory" )
util.AddNetworkString( "sendMerchantInventory" )
util.AddNetworkString("requestWeapons")

function meta:SendInventory()
	local str = self:GetInventory()

	--TODO: Incase the player inventory table ends up above 64kb over a net message (which is fucking huge but whatever)
	--basically add a system where it staggers the inventory string over multiple net messages

	net.Start("sendInventory")
		net.WriteTable(str)
	net.Send(self)
end

--Instead of updating the whole inventory, update only one item
function meta:UpdateInventoryItem(item)
	net.Start("updateInventoryItem")
		net.WriteTable(item)
	net.Send(self)
end

function meta:OpenMerchantMenu(ent)
	if ent and ent.Inventory then
		self.c_OpenedInventory = ent

		net.Start("sendMerchantInventory")
			net.WriteTable(ent.Inventory)
		net.Send(self)
	end
end

function meta:OpenOtherInventory(ent, inv)
	if ent then
		self.c_OpenedInventory = ent

		net.Start("sendOtherInventory")
			net.WriteTable(inv)
		net.Send(self)
	end
end

--basically what items new players should get
--add bonus items or something for new acct
function meta:GiveNewAccountItems()
	--self.c_Inventory = Item(nil, "container_playerinventory")

	--[[local item1 = Item("crowbar", 1)
		item1:GetData().Durability = 100
		item1:GetData().MaxDurability = 100
	self:InventoryAdd(item1, nil, false)]]

	--self:InventoryAdd({Name = "firework", Amount = 10}, nil, true)
end

--make sure if we have a weapon, we have the item it was being used with as well
function meta:RecalcWeapons(isinitspawn)
	for k,v in pairs(self:GetWeapons()) do
		if v:GetClass() ~= "weapon_melee_fists" then
			local ref = v:GetItemID()
			local item = self:GetItemByID(ref)

			if item == nil then
				--print("item is nil")
				self:StripWeapon(v.ClassName)
			elseif self:GetItemCountByID(ref) == 0 or item:GetDataName() ~= v.Item then
				--print("we don't have the item!", item:GetDataName(), v.Item)
				self:StripWeapon(v.ClassName)
			end
		end
	end

	if not self:HasWeapon("weapon_melee_fists") then
		self:Give("weapon_melee_fists", false)
	end

	if isinitspawn then return end

	local weps = self:GetWeapons()
	local slots = {}

	for index, wep in pairs(weps) do
		if wep:GetClass() ~= "weapon_melee_fists" then
		--	wep:SetNewSlot(index)
			table.insert(slots, wep.Slot)
		end
	end

	for _, item in pairs(self:GetInventory():GetContainer()) do
		local gitem = GetGlobalItem(item:GetDataName())
		if gitem.Weapon then
			local gwep = weapons.Get(gitem.Weapon)

			if not gwep.PreventAutoEquip then
				if not table.HasValue(slots, gwep.Slot) then
					SetupEquipPlayer(self, item)

					table.insert(slots, gwep.Slot)
				end
			end
		end
	end
end

--so we aren't dropping items into a wall
local function CheckDrop(pl)
	local trace = {}
		trace.start = pl:GetShootPos()
		trace.endpos = trace.start + pl:GetAimVector() * 70
		trace.mins = Vector(-4, -4, -4)
		trace.maxs = Vector(4, 4, 4)
		trace.filter = pl
	local tr = util.TraceHull(trace)

	return tr
end

--drop items
function meta:DropItem(id, amount)
	amount = amount or 1

	if not id then return end
	local itemref = self:GetItemByID(id)

	if not itemref:IsItem() then return end

	local globalitem = GetGlobalItem(itemref:GetDataName())

	if globalitem.IsArmor then
		if self:GetEquipmentSlot(globalitem.EquipCategory) == id then
			self:SendNotification("You cannot drop an item you are wearing!", 4, Color(255, 150, 150), "buttons/button14.wav", 2)
			return
		end
	end

	local tr = CheckDrop(self)
	if tr.Entity:IsValid() then
		if Vector(0, 0, 1):Dot(tr.HitNormal) <= 0.99 then
			self:SendNotification("There is something in the way!")
			return
		end
	end

	if globalitem.OnDrop then
		globalitem:OnDrop(self)
	end

	--If items can only drop one at a time, then just drop one
	if globalitem.DropIndividual then
		amount = 1
	end

	local todrop = 1
	if itemref:GetAmount() >= amount then
		todrop = amount
	elseif itemref:GetAmount() < amount then
		todrop = itemref:GetAmount()
	end

	local item = ents.Create("item_"..itemref:GetDataName())
		item:SetPos(tr.HitPos)
		item:SetAngles(self:GetAngles() + Angle(0, 90, 0))
		item:Spawn()

		if self:GetInfoNum("noxrp_dropprotection", 1) == 1 then
			item:SetTemporaryOwnerMain(self, 20)
		end

		local tab = {}
		for index, var in pairs(itemref:GetData()) do
			tab[index] = var
		end

		local newitem = itemref:GetCopy()
			newitem:SetAmount(todrop)

		item:SetData(newitem)

	self:DestroyItem(id, todrop)
end

--drop weapon, since it has to store the weapon data into the item (remaining rounds)
--probably a better way but
function meta:DropWeapon(id, amount)
	local itemref = self:GetItemByID(id)

	if not itemref:IsItem() then return end

	local globalitem = GetGlobalItem(itemref:GetDataName())

	local tr = CheckDrop(self)
	if tr.Entity:IsValid() then
		self:SendNotification("There is something in the way!")
		return
	end

	if globalitem.OnDrop then
		globalitem:OnDrop(self)
	end

	local fullitem = ITEMS[itemref.Name]
	local wep

	for _, weapon in pairs(self:GetWeapons()) do
		if weapon.GetItemID then
			if weapon:GetItemID() == itemref:GetIDRef() then
				itemref.Data.Clip1 = weapon:Clip1()

				self:StripWeapon(weapon:GetClass())
				break
			end
		end
	end

	local todrop = 1
	if itemref:GetAmount() >= amount then
		todrop = amount
	elseif itemref:GetAmount() < amount then
		todrop = itemref:GetAmount()
	end

	local item = ents.Create("item_"..itemref:GetDataName())
		item:SetPos(self:GetShootPos() + self:GetAimVector() * 70)
		item:SetAngles(self:GetAngles() + Angle(0, 90, 0))
		item:Spawn()

		item:SetItemCount(1)
		item:SetData(itemref)
		item.Data:SetAmount(todrop)
		if self:GetInfoNum("noxrp_dropprotection", 1) == 1 then
			item:SetTemporaryOwnerMain(self, 20)
		end

	self:DestroyItem(id, todrop)
end

function meta:CanHoldItem(item)
	if (self:GetCurWeight() + item:GetWeight()) > self:GetMaxWeight() then
		return false
	else
		return true
	end
end

--add an item
function meta:InventoryAdd(item, entity, message)
	if message == nil then message = true end

	local itemref = ITEMS[dataname]

	if not self:CanHoldItem(item) then
		self:SendNotification("You can't hold anymore!", 4, Color(255, 255, 255))
		return
	end

	local added = false
	local inv = self:GetInventory()

	--print("We are a container!")
	if inv.MaxItems and #inv.Items >= inv.MaxItems then
		return false
	end

	for index, tabitem in pairs(inv:GetContainer()) do
		if tabitem:GetDataName() == item:GetDataName() and tabitem:GetItemName() == item:GetItemName() and not item.IsContainer then
			if table.Compare(tabitem:GetData(), item:GetData()) then
				tabitem:SetAmount(tabitem:GetAmount() + item:GetAmount())

				self:UpdateInventoryItem(tabitem)

				added = true
				break
			end

			break
		end
	end

	if not added then
		item:SetIDRef(#inv.Items + 1)
		table.insert(inv.Items, item)

		self:UpdateInventoryItem(item)
	end

	--self:RecalcWeapons()

	if entity then
		entity:Remove()
	end

	if message then
		self:SendNotification("Picked up '"..item:GetItemName().."'", 4, Color(255, 255, 255))
	end
end

local function RequestWeaponUpdate(len, pl)
	pl:RecalcWeapons()
end
net.Receive("requestWeapons", RequestWeaponUpdate)

function meta:AddLocalItem(item, ent, notify, customtext)
end

--mostly just a spawn function, so we set the inventory as the entire table
function meta:SetInventory(inv, isinitspawn)
	self.c_Inventory = inv

	self:RecalcWeapons(isinitspawn)
	self:SendInventory()
end

--for testing
function meta:DestroyInventory()
	self:RemoveAllEquipment()

	table.Empty(self:GetInventory():GetContainer())
	self:SendInventory()

	self:StripWeapons()
end

function meta:DestroyItem(id, amount)
	amount = amount or 1
	local refresh = self:GetInventory():DestroyItem(id, amount)

	if refresh then
		for k, ref in pairs(self:GetInventory():GetContainer()) do
			ref.NewID = k

			local equip = self:GetEquipment()
			--If we're wearing the item we want to destroy, remove it
			for slot, idr in pairs(equip) do
				if idr == id then
					self:RemoveEquipment(slot, ref:GetIDRef())
					break
				end
			end
		end

		for k, item in pairs(self:GetInventory():GetContainer()) do
			for slot, idr in pairs(self:GetEquipment()) do
				if idr == item:GetIDRef() then
					self.c_Equipment[slot] = item.NewID
				end
			end

			for slot, wep in pairs(self:GetWeapons()) do
				if wep.GetItemID then
					if wep:GetItemID() == item:GetIDRef() then
						wep:SetItemID(item.NewID)
					end
				end
			end
		end

		for _, item in pairs(self:GetInventory():GetContainer()) do
			item:SetIDRef(item.NewID)
			item.NewID = nil
		end

		self:RecalcWeapons()
		self:SendInventory()
		self:SendEquipment(true)
	else
		self:UpdateInventoryItem(self:GetItemByID(id))
	end
end

function meta:DestroyItemByName(name, amount) --money or stuff that doesn't matter if we don't use the id
	amount = amount or 1
	local destroyedall = false

	local removeitems = {}

	for i, itemtab in pairs(self:GetInventory():GetContainer()) do
		if itemtab and itemtab:GetDataName() == name then
			if itemtab:GetAmount() <= amount then
				destroyedall = true
				amount = amount - itemtab:GetAmount()
				--table.remove(self:GetInventory():GetContainer(), i)
				table.insert(removeitems, i)
			else
				itemtab:SetAmount(itemtab:GetAmount() - amount)
				self:UpdateInventoryItem(itemtab)

				amount = 0
			end

			if amount <= 0 then
				break
			end
		end
	end

	for _, index in pairs(removeitems) do
		table.remove(self:GetInventory():GetContainer(), index)
		index = index - 1
	end

	for k, ref in pairs(self:GetInventory():GetContainer()) do
		ref.NewID = k
	end

	for k, item in pairs(self:GetInventory():GetContainer()) do
		for slot, idr in pairs(self:GetEquipment()) do
			if idr == item:GetIDRef() then
				self.c_Equipment[slot] = item.NewID
			end
		end

		for slot, wep in pairs(self:GetWeapons()) do
			if wep.GetItemID then
				if wep:GetItemID() == item:GetIDRef() then
					wep:SetItemID(item.NewID)
				end
			end
		end
	end

	for _, item in pairs(self:GetInventory():GetContainer()) do
		item:SetIDRef(item.NewID)
		item.NewID = nil
	end

	self:SendInventory()
	self:RecalcWeapons()
	self:SendEquipment(true)

	return destroyedall
end

function TakeInventoryItem(pl,cmd,args)
	local id = tonumber(args[1])

	if IsValid(pl.c_OpenedInventory) then
		pl.c_OpenedInventory:OnTakeItem(pl, id)
	end
end
concommand.Add("takeinventoryitem",TakeInventoryItem)

function AddInventoryItem(pl,cmd,args)
	--print("[NoXRP] - AddInventoryItem")
	if not IsValid(pl.c_OpenedInventory) then return end

	local id = tonumber(args[1])
	local plitem = pl:GetItemByID(id)

	if plitem then
		local globalitem = GetGlobalItem(plitem:GetDataName())
		if globalitem.Equipable then
			if pl:GetEquipmentSlot(globalitem.EquipCategory) == id then
				pl:SendNotification("You cannot store an item you are wearing!", 4, Color(255, 150, 150), "buttons/button14.wav", 2)
				return
			end
		end

		local item = plitem:GetCopy()
			item:SetAmount(1)

		if pl.c_OpenedInventory:AddItem(pl, item) then
			pl:DestroyItem(id, 1)
		end
	end
end
concommand.Add("addinventoryitem",AddInventoryItem)

function CloseInventory(pl)
	if pl.c_OpenedInventory then
		pl.c_OpenedInventory:RemoveOpener(pl)

		pl.c_OpenedInventory = nil
		pl:SendLua("CloseInventory()")
	end
end
concommand.Add("closeinventory", CloseInventory)

function meta:UseInventoryItem(item, args)
	if not item then self:ChatPrint("Invalid item.") return end

	if item.Usable then
		if item.OverrideUsage then
			item:OverrideUsage(self, args)
		else
			local used = item:ItemUse(self, args)
			if item.DestroyOnUse and used then
				self:DestroyItem(item:GetIDRef(), 1)
			end
		end
	end
end

function EmptyWeapon(pl, cmd, args)
	local id = tonumber(args[1])
	local plitem = pl:GetItemByID(id)
	if not plitem then return end

	if plitem:GetGlobalItem().Weapon then
		if pl:HasWeapon(plitem:GetGlobalItem().Weapon) then
			local wep = pl:GetWeapon(plitem:GetGlobalItem().Weapon)
			local ammo = wep:Clip1()

			if ammo > 0 then
				plitem:GetData().Clip1 = 0

				wep:SetClip1(0)

				pl:GiveAmmo(ammo, wep.Primary.Ammo, true)

				pl:UpdateInventoryItem(plitem)
			else
				pl:SendNotification("That weapon is already empty!")
			end
		else
			local ammo = plitem:GetData().Clip1

			if ammo then
				if ammo > 0 then
					plitem:GetData().Clip1 = 0

					pl:GiveAmmo(ammo, weapons.GetStored(plitem:GetGlobalItem().Weapon).Primary.Ammo, true)

					pl:UpdateInventoryItem(plitem)
				else
					pl:SendNotification("That weapon is already empty!")
				end
			else
				plitem:GetData().Clip1 = 0
				pl:SendNotification("That weapon is already empty!")
			end
		end
	end
end
concommand.Add("emptyweapon", EmptyWeapon)

function EatItem(pl, cmd, args)
	local id = tonumber(args[1])
	local plitem = pl:GetItemByID(id)
	if not plitem then return end

	local used = GetGlobalItem(plitem:GetDataName()):OnEaten(pl, plitem)
	if used then
		pl:DestroyItem(plitem:GetIDRef(), 1)
	end
end
concommand.Add("eatitem", EatItem)

function DrinkItem(pl, cmd, args)
	local id = tonumber(args[1])
	local plitem = pl:GetItemByID(id)
	if not plitem then return end

	local gitem = plitem:GetGlobalItem()

	if gitem.OverrideOnDrink then
		gitem:OverrideOnDrink(pl, plitem)
	else
		local used = gitem:OnDrink(pl, plitem)
		if used then
			pl:DestroyItem(plitem:GetIDRef(), 1)
		end
	end
end
concommand.Add("drinkitem", DrinkItem)

function BuyItem(pl, cmd, args)
	local itemname = tostring(args[1])
	local amt = tonumber(args[2]) or 1
	if amt < 1 then amt = 1 end

	if pl.c_OpenedInventory then
		local item = pl.c_OpenedInventory:HasItem(itemname)
		if item then
			if pl:CanTakeItem(item, amt) then
				if pl:HasItem("money", amt * item:GetData().Price) then
					pl:DestroyItemByName("money", amt * item:GetData().Price)

					local plitem = item:GetCopy()
					plitem:SetAmount(amt)
					plitem:GetData().Price = nil

					pl:InventoryAdd(plitem, nil, false)
					pl:SendNotification("Bought '"..plitem:GetItemName().."'", 4, Color(255, 255, 255))
					gamemode.Call("OnPlayerBuyItem", pl, item)
				end
			end
		end
	end
end
concommand.Add("buyitem", BuyItem)

function UseItem(pl, cmd, args)
	local id = tonumber(args[1])
	local item = pl:GetItemByID(id)
	if not item then pl:ChatPrint("Invalid item.") return end

	if item.CanEat then
		if not item.CheckCanEat or item:CheckCanEat(pl) then
			pl:EatItem(item, args)
		end
	elseif item.CanDrink then
		if not item.CheckCanDrink or item:CheckCanDrink(pl) then
			pl:DrinkItem(item, args)
		end
	elseif item.Usable then
		pl:UseInventoryItem(item, args)
	end
end
concommand.Add("useitem", UseItem)

function ApplyEChip(pl, cmd, args)
	local itemid = tonumber(args[1])
	local chipid = tonumber(args[2])
	local slot = tonumber(args[3])

	local weapon = pl:GetItemByID(itemid)
	if not weapon then return end

	local plitem = pl:GetItemByID(chipid)
	if not plitem then return end

	local globalitem = GetGlobalItem(plitem:GetDataName())
	if not globalitem then return end

	if not GetGlobalItem(weapon:GetDataName()).Weapon then return end

	globalitem:ApplyEChip(pl, weapon, plitem, slot)
end
concommand.Add("applyechip", ApplyEChip)

function RemoveEChip(pl, cmd, args)
	local id = tonumber(args[1])
	local slot = tonumber(args[2])

	local plitem = pl:GetItemByID(id)
	if not plitem then return end

	local globalitem = GetGlobalItem(plitem:GetDataName())
	if not globalitem then return end

	globalitem:DestroyChip(pl, plitem, slot)
end
concommand.Add("removeechip", RemoveEChip)

function UseItem(pl, cmd, args)
	local id = tonumber(args[1])
	local item = pl:GetItemByID(id)

	if item and item.CanUseWithWorld then
		pl.c_UsingWithWorld = item
		--gitem:UseWithWorld(pl, item)
	else
		pl:ChatPrint("Invalid item.")
	end
end
concommand.Add("usewithworld", UseItem)

function EmptyItem(pl, cmd, args)
	local id = tonumber(args[1])
	local plitem = pl:GetItemByID(id)

	if plitem then
		local gitem = plitem:GetGlobalItem()
		if gitem.IsLiquidContainer then
			plitem:EmptyItems()
			pl:UpdateInventoryItem(plitem)

			pl:SendInventory()
		end
	else
		pl:ChatPrint("Invalid item.")
		return
	end
end
concommand.Add("emptyitem", EmptyItem)

--was with the merchants, but those have been taken out for the moment
function SellItem(pl, cmd, args)
	local itemid = tonumber(args[1])
	local amt = tonumber(args[2]) or 1

	if amt < 1 then amt = 1 end

	if pl.c_OpenedInventory then
		local sellitem = pl:GetItemByID(itemid)

		if sellitem:GetGlobalItem().NoSell then return end

		if sellitem then
			if sellitem:GetAmount() >= amt then
				local isweapon = false
				for k,v in pairs(pl:GetWeapons()) do
					if v.GetItemID then
						if v:GetItemID() == sellitem:GetIDRef() then
							pl:StripWeapon(v:GetClass())
							isweapon = true
							break
						end
					end
				end

				if not isweapon then
					if pl:GetEquipmentSlot(EQUIP_ARMOR_BODY) == itemid then return end
				end

				pl:DestroyItem(itemid, amt)

				local item = Item("money")
					item:SetAmount(math.Round(amt * (sellitem:GetGlobalItem().BasePrice or 20) * 0.7))
				pl:InventoryAdd(item)

				gamemode.Call("OnPlayerSellItem", pl, sellitem)
			end
		end
	end
end
concommand.Add("sellitem", SellItem)

function FlashItem(pl, cmd, args)
	local itemid = tonumber(args[1])
	local item = pl:GetItemByID(itemid)
	--local itemref = ITEMS[item.Name]
	--local itemcount = pl:GetItemCountByID(itemid)

	local name = item:GetItemName()

	for k,v in pairs(player.GetAll()) do
		if v:GetPos():Distance(pl:GetPos()) <= 300 then
			v:ChatPrint(pl:Nick().." flashes the "..name..".")
		end
	end
end
concommand.Add("flashitem", FlashItem)

function EquipWeapon(pl, cmd, args)
	local itemid = tonumber(args[1])

	local itemref = pl:GetItemByID(itemid)
	if not itemref:IsItem() then return end

	local item = GetGlobalItem(itemref:GetDataName())
	if not item then return end
	if not item.Weapon then return end

	local wepinfo = weapons.Get(item.Weapon)
	--local curwep = pl:GetActiveWeapon()

	for _, wep in pairs(pl:GetWeapons()) do
		if (wep:GetClass() == item.Weapon or wep.Slot == wepinfo.Slot) then
			if wep.HeatLevel then
				if wep:HeatLevel() > 0 then
					--self:Remove() -- What?
					return
				end
			else
				for _, plitem in pairs(pl:GetInventory():GetContainer()) do
					if wep:GetItemID() == plitem:GetIDRef() then
						plitem:GetData().Clip1 = wep:Clip1()
					end
				end
			end
			pl:StripWeapon(wep.ClassName)
		end
	end

	SetupEquipPlayer(pl, itemref)
	pl:RecalcWeapons()
end
concommand.Add("equipweapon", EquipWeapon)

function EquipArmor(pl, cmd, args)
	local itemid = tonumber(args[1])

	local itemref = pl:GetItemByID(itemid)
	if not itemref:IsItem() then return end

	local item = GetGlobalItem(itemref:GetDataName())
	if not item then return end
	if not item.IsArmor then return end

	if item.Durability then
		if itemref:GetData().Durability then
			local stat = ents.Create("status_equipping")
			if stat:IsValid() then
				stat:Spawn()
				stat:SetDieTime(CurTime() + item.ItemWeight * 0.5)
				stat:SetPlayer(pl)

				stat.Category = item.EquipCategory
				stat.Item = itemref
				stat:SetItemID(itemid)
				stat.Type = 2
			end
		end
	else
		local stat = ents.Create("status_equipping")
		if stat:IsValid() then
			stat:Spawn()
			stat:SetDieTime(CurTime() + item.ItemWeight * 0.5)
			stat:SetPlayer(pl)

			stat.Category = item.EquipCategory
			stat.Item = itemref
			stat:SetItemID(itemid)
			stat.Type = 2
		end
	end
end
concommand.Add("equiparmor", EquipArmor)

function SetupEquipPlayer(pl, item)
	local glitem = GetGlobalItem(item:GetDataName())
	local plitem = pl:Give(glitem.Weapon, false)

	if pl:GetActiveWeapon():IsValid() then
		if not pl:GetActiveWeapon():GetHolstered() then
			pl:SelectWeapon(glitem.Weapon)
		end
	else
		pl:SelectWeapon(glitem.Weapon)
	end
	plitem:SetItemID(item:GetIDRef())

	if item:GetData().Clip1 then
		plitem:SetClip1(item:GetData().Clip1)
	end

	if plitem.SetupItemVariables then
		plitem:SetupItemVariables()--since weapon vars are stored in the instance of the item
	end

	timer.Simple(0, function() if IsValid(pl) then pl:SendLua("RefreshWeapons()") end end)
	pl:RecalcMoveSpeed()
end

function SelectWeapon(pl, cmd, args)
	local wep = pl:GetActiveWeapon()
	if wep:IsValid() and wep:GetHolstered() then return end

	local slot = tonumber(args[1])

	for k, v in pairs(pl:GetWeapons()) do
		if v.Slot == slot then
			if not wep or v.Slot ~= wep.Slot then
				--If we aren't in that slot
				pl:SelectWeapon(v.ClassName)
				break
			end
		end
	end
end
concommand.Add("select", SelectWeapon)