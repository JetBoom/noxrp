ITEMS = {}

ITEM_MAXSTACK_DEFAULT = 1

function GetItemData(dataname, copy)
	if copy then
		return table.CopyNoUserdata(ITEMS[dataname])
	end

	return ITEMS[dataname]
end
ItemData = GetItemData
GetGlobalItem = GetItemData

--Basic item interaction with another item

--Creates the models for items if they are from a weapon (swep construction kit weapons)
function GenericSetupWeaponModels(self)
	local weptab = weapons.GetStored(self.Weapon)
	if weptab then
		self.ShowWorldModel = weptab.ShowWorldModel

		if weptab.WElements then
			self.WElements = table.FullCopy(weptab.WElements)
			self:CreateModels(self.WElements)
		end
	end
end

function GenericOnWelded(self, weapon, pl, tr)
end

function TransferItem(pl, from, to)
	local totalvol = 0
	local vol = (from.Volume or 1) * from:GetItemCount()

	for k, v in pairs(to.Data:GetData().Contents) do
		totalvol = totalvol + v.Volume
	end

	if (to.ContainerVolume - totalvol) >= vol then
		local tab = {}
			tab.Name = from.DataName
			tab.Volume = vol

		table.insert(to.Data:GetData().Contents, tab)

		pl:SendNotification("You put the "..from:GetDisplayName().." in the "..to:GetDisplayName()..".", 4, Color(255, 255, 255), nil, 1)

		from:Remove()
	else
		pl:SendNotification("There isn't enough room in the "..to:GetDisplayName()..".", 4, Color(255, 255, 255), nil, 1)
	end

	to:SortContents()
end

function RegisterHelmet(helm)
	local ENT = helm
	ENT.Type = "anim"
	ENT.Base = "status__base_helmet"

	scripted_ents.Register(ENT, ENT.Name)
end

ITEM_FLAG_CANNOTDROP = 1

--Going to have to improve this
local function TransferLiquid(pl, cmd, args)
	local amt = tonumber(args[1])

	if amt > 0 then
		pl.v_ContainerTransferAmount = amt
	end
end
concommand.Add("container_transfer", TransferLiquid)

if SERVER then
	function PlayerExamineWorld(pl, cmd, args)
		local ent1

		if args[1] then
			ent1 = Entity(tonumber(args[1]))
		end

		if ent1 then
			if ent1:IsValid() and ent1:GetPos():Distance(pl:GetPos()) < 150 then
				if ent1.OnExamined then
					ent1:OnExamined(pl)
				else
					pl:SendNotification("It is a "..ent1.Name..".", 4, Color(255, 255, 255), nil, 1)
					if ent1.Description then
						pl:SendNotification(ent1.Description, 4, Color(255, 255, 255), nil, 1)
					end
					local gitem = ITEMS[ent1.DataName]
					if gitem.Durability then
						if ent1.Data.Durability then
							local dur = ent1.Data:GetData().Durability
							if dur > 140 then
								pl:SendNotification("It looks in perfect condition.", 4, Color(150, 255, 100), nil, 1)
							elseif dur > 115 then
								pl:SendNotification("It looks in good condition.", 4, Color(180, 220, 100), nil, 1)
							elseif dur > 70 then
								pl:SendNotification("It looks in okay condition.", 4, Color(200, 200, 100), nil, 1)
							elseif dur > 35 then
								pl:SendNotification("It looks in bad condition.", 4, Color(220, 160, 100), nil, 1)
							elseif dur > 0 then
								pl:SendNotification("It looks in terrible condition.", 4, Color(255, 120, 100), nil, 1)
							else
								pl:SendNotification("It looks completely broken!", 4, Color(255, 100, 100), nil, 1)
							end
						else
							pl:SendNotification("It looks completely broken!", 4, Color(255, 100, 100), nil, 1)
						end
					end
				end
			end
		end
	end
	concommand.Add("noxrp_examine", PlayerExamineWorld)
end

function GM:RegisterItem()
	if SERVER then
		if ITEM.Durability then
			ITEM.OnWelded = GenericOnWelded
		end
	end

	if CLIENT then
		if not ITEM.InventoryItemExamine then
			ITEM.InventoryItemExamine = GenericItemExamine
		end

		if ITEM.Weapon then
			ITEM.PostClientInit = GenericSetupWeaponModels
		end
	end

	ITEM.DataName = ITEMNAME
	ITEM.Mass = ITEM.Mass or 1
	ITEM.Name = ITEM.Name or string.gsub(ITEMNAME, "_", " ")

	ITEMS[ITEMNAME] = ITEM

	if ITEM.PostRegister then
		ITEM:PostRegister()
	end

	--If its a liquid then we don't want to create an entity for it
	if ITEM.IsLiquid then return end

	ENT.Type = ENT.Type or "anim"
	ENT.Base = ENT.Base or ITEM.Base and "item_"..ITEM.Base or "item___base"

	ENT.Mass = ITEM.Mass or 5
	ENT.Moveable = ITEM.Moveable

	if ITEM.MaxStack == nil then
		ITEM.MaxStack = ITEM_MAXSTACK_DEFAULT
	end

	--[[if SERVER then
		ENT.Initialize = ENT.Initialize or GenericItemEntityInitialize
		ENT.Use = ENT.Use or GenericItemEntityUse
	end
	if CLIENT then
		ENT.ContextScreenClick = ENT.ContextScreenClick or ContextScreenClick
	end]]

	scripted_ents.Register(ENT, "item_"..ITEMNAME)
end

function GM:RegisterItems()
	ITEMS = {}

	local included = {}

	local itemfiles, itemdirectories = file.Find(self.FolderName.."/gamemode/items/*", "LUA")
	table.sort(itemfiles)
	table.sort(itemdirectories)

	for i, filename in ipairs(itemfiles) do
		if string.sub(filename, -4) == ".lua" then -- Just in case
			ITEM = {}
			ENT = {}
			ITEMNAME = filename:sub(1, -5)

			AddCSLuaFile("items/"..filename)
			include("items/"..filename)

			if ITEMNAME ~= "__base" then
				ITEM.Base = ITEM.Base or "__base"
			end

			self:RegisterItem()

			included[filename] = ITEM
			ITEM = nil
			ENT = nil
			ITEMNAME = nil
		end
	end

	for i, foldername in ipairs(itemdirectories) do
		-- TEMP
		if foldername == "shared" or foldername == "client" or foldername == "server" then continue end

		local basefn = "items/"..foldername.."/"

		ITEMNAME = foldername

		ITEM = {}
		if CLIENT then
			include(basefn.."client.lua")
		end
		if SERVER then
			AddCSLuaFile(basefn.."client.lua")
			include(basefn.."server.lua")
		end

		if ITEMNAME ~= "__base" then
			ITEM.Base = ITEM.Base or "__base"
		end

		self:RegisterItem()

		included[foldername..".lua"] = ITEM
		ITEM = nil
		ITEMNAME = nil
	end

	for k, v in pairs(ITEMS) do
		if k == "__base" then continue end

		local base = v.Base or "__base"
		base = base..".lua"
		if included[base] then
			table.Inherit(v, included[base])
		else
			ErrorNoHalt("ITEM "..tostring(v.Name).." uses base class "..base.." but it doesn't exist!")
		end
	end
end

GM:RegisterItems()
