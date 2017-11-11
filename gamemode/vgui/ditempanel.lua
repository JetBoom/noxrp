local function CheckDropItem(item)
	local gitem = GetGlobalItem(item:GetDataName())

	if ((gitem.MaxDrop and (gitem.MaxDrop or 0) == 1) or item:GetAmount() == 1) and not gitem.Mutatable then
		RunConsoleCommand("dropitem", item:GetIDRef())
	else
		local itemamt = item:GetAmount()

		local frame = vgui.Create("DFrame")
		frame:SetSize(400, 100)
		frame:SetPos(ScrW() * 0.5 - 120, ScrH() * 0.5 - 50)
		--frame:SetTitle("Dropping "..ITEMS[item.Name].Name)
		frame:SetTitle("")
		frame:SetDeleteOnClose(true)
		frame:ShowCloseButton(false)
		frame:SetDraggable(true)
		frame:SetMouseInputEnabled(true)
		frame:MakePopup()
		frame.Paint = function(pnl, pw, ph)
			draw.SlantedRectHorizOffset(5, 5, pw - 20, 25, 2, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 2, 2)
			draw.SlantedRectHorizOffset(5, 30, pw - 20, ph - 35, 2, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 2, 2)

			draw.NoTexture()
			--draw.SlantedRectHorizOffset(5, 5, pw - 30, 40, 10, Color(40, 40, 40, 220), Color(30, 30, 30, 255), 2, 2)

			draw.SimpleText("Dropping "..gitem.Name, "nulshock14", pw * 0.5, 15, Color(50, 150, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		frame.DropAmount = 1

		local slider = vgui.Create("Slider", frame)
		slider:SetPos(15, 30)
		slider:SetSize(frame:GetWide() - 10, 30)
		slider:SetMin(1)
		slider:SetMax(itemamt)
		slider:SetDecimals(0)
		slider:SetValue(1)
		slider.OnValueChanged = function(sld, val)
			frame.DropAmount = math.Round(val)
		end
		slider.TextArea:SetTextColor(Color(255, 255, 255, 255))

		local dropbtn = vgui.Create("DButton", frame)
		dropbtn:SetText("Drop")
		dropbtn:SetPos(15, frame:GetTall() - 33)
		dropbtn:SetSize(frame:GetWide() - 40, 20)
		dropbtn:SetTextColor(Color(255, 255, 255))
		dropbtn.DoClick = function(btn)
			RunConsoleCommand("dropitem", item:GetIDRef(), frame.DropAmount)
			frame:Close()
		end

		dropbtn.Paint = function(btn, bw, bh)
			draw.SlantedRectHorizOffset(0, 0, bw, bh, 2, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 2, 2)
		end

		local cancelbtn = vgui.Create("DButton", frame)
		cancelbtn:SetText("X")
		cancelbtn:SetPos(frame:GetWide() - 38, 5)
		cancelbtn:SetSize(20, 25)
		cancelbtn:SetTextColor(Color(255, 255, 255))
		cancelbtn.DoClick = function(btn)
			frame:Close()
		end

		cancelbtn.Paint = function(btn, bw, bh)
			--draw.SlantedRectHorizOffset(0, 0, bw, bh, 4, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 1, 1)
		end
	end
end

local PANEL = {}

function PANEL:Init()
	self.Pressed = false
end

function PANEL:Paint( w, h )
	local col = Color(40, 40, 40, 180)
	if self.Hovered then
		col = Color(60, 60, 60, 180)
	end
	--draw.SlantedRectHorizOffset(0, 0, w - 10, h - 4, 10, col, Color(0, 0, 0, 255), 2, 2)
	draw.ElongatedHexagonHorizontalOffset(0, 0, w - 2, h - 4, 8, Color(0, 0, 0, 255), Color(0, 0, 0, 200), 2, 2)

	if self.Item then
		local data = self.Item:GetData()
		local iteminfo = ITEMS[self.Item:GetDataName()]
		local itemamt = LocalPlayer():GetItemCountByID(self.Item:GetIDRef())
		local weight = self.Item:GetWeight()

		local totalweight = self.Item:GetTotalWeight()

		local namestr = self.Item:GetItemName()

		if string.len(namestr) > 20 then
			namestr = string.sub(namestr, 0, 20).."..."
		end

		if itemamt > 1 and (not iteminfo.NotStackable or not iteminfo.Mutatable) then
			namestr = namestr.."  ["..itemamt.."]"
		end

		draw.SimpleText(namestr, "Xolonium18", w * 0.5, 5, Color(50, 150, 255, 255), TEXT_ALIGN_CENTER)

		if iteminfo.ItemWeight > 0 then
			if itemamt > 1 and (not iteminfo.NotStackable or not iteminfo.Mutatable) then
				draw.DrawText("Weight: ["..weight.."|"..totalweight.."]","Xolonium14", w * 0.5, 25, Color(255, 200, 200, 255), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("Weight: ["..weight.."]","Xolonium14", w * 0.5, 25, Color(255, 200, 200, 255), TEXT_ALIGN_CENTER)
			end
		end

		local hasdurability = false
		local broke = false
		if data then
			if data.Durability then
				hasdurability = true
				if data.Durability == 0 then
					broke = true
				end
			end
		end

		if self.Equipped then
			if hasdurability and broke then
				draw.DrawText("[Equipped]", "hidden12", w * 0.4, 40, Color(200, 255, 200, 255), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("[Equipped]", "hidden12", w * 0.5, 40, Color(200, 255, 200, 255), TEXT_ALIGN_CENTER)
			end
		end

		if hasdurability and broke then
			draw.DrawText("[BROKEN]", "hidden12", w * 0.6, 40, Color(255, 100, 100, 255), TEXT_ALIGN_CENTER)
		end
	end
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:DoClick()
	surface.PlaySound("UI/buttonclick.wav")
	self:OpenOptions()
end

function PANEL:DoRightClick()
end

function PANEL:OpenOptions()
	if self.Item then
		local itemref = GetGlobalItem(self.Item:GetDataName())

		local menu = DermaMenu()
		--menu:AddOption(namestr)
		--menu:AddSpacer()

		local needspacer = false

		--Food
		if itemref.CanEat then
			if not itemref.CheckCanEat or itemref:CheckCanEat(LocalPlayer()) then
				menu:AddOption("Eat", function()
					surface.PlaySound("UI/buttonclick.wav")
					RunConsoleCommand("eatitem", self.Item:GetIDRef())
				end):SetIcon("icon16/cup.png")

				needspacer = true
				canquickslot = true
			end
		elseif itemref.CanDrink then
			if not itemref.CheckCanDrink or itemref:CheckCanDrink(LocalPlayer()) then
				menu:AddOption("Drink", function()
					surface.PlaySound("UI/buttonclick.wav")
					RunConsoleCommand("drinkitem", self.Item:GetIDRef())
				end):SetIcon("icon16/cup.png")

				needspacer = true
				canquickslot = true
			end
		elseif itemref.Weapon then
			menu:AddOption("Equip Weapon", function()
				surface.PlaySound("UI/buttonclick.wav")
				RunConsoleCommand("equipweapon", self.Item:GetIDRef())
			end):SetIcon("icon16/gun.png")

			local wep = weapons.Get(itemref.Weapon)
			if wep and (wep.AmmoItem or wep.Primary.ClipSize > 0) then
				menu:AddOption("Empty Weapon Mag", function()
					surface.PlaySound("UI/buttonclick.wav")
					RunConsoleCommand("emptyweapon", self.Item:GetIDRef())
				end):SetIcon("icon16/arrow_undo.png")
			end

			needspacer = true
			canquickslot = true
		elseif itemref.IsArmor then
			menu:AddOption("Equip Armor", function()
				surface.PlaySound("UI/buttonclick.wav")
				RunConsoleCommand("equiparmor", self.Item:GetIDRef())
			end):SetIcon("icon16/shield.png")

			needspacer = true
			canquickslot = true
		end

		if itemref.CanUseWithWorld then
			menu:AddOption("Use with World", function()
				RunConsoleCommand("usewithworld", self.Item:GetIDRef())
				LocalPlayer().c_UsingWithWorld = true
				LocalPlayer().v_InventoryPanel:FlushRemove()
			end):SetIcon("icon16/world.png")

			needspacer = true
		end

		if needspacer then
			menu:AddSpacer()
		end

		if itemref.AddOptionsUse then
			itemref:AddOptionsUse(menu, self)
		else
			if itemref.Usable then
				menu:AddOption("Use", function()
					surface.PlaySound("UI/buttonclick.wav")
					RunConsoleCommand("useitem", self.Item:GetIDRef())
				end):SetIcon("icon16/link.png")

				canquickslot = true
			end
		end

		menu:AddOption("Examine", function()
			surface.PlaySound("UI/buttonclick.wav")
			--itemref:InventoryItemExamine(self.Item)
			local examinepnl = vgui.Create("dExamineItem")
				examinepnl:SetSize(800, 200)
				examinepnl:SetPos(ScrW() * 0.5 - 300, ScrH() * 0.5 - 50)
				examinepnl.Item = self.Item

				examinepnl:SetupItem()
		end):SetIcon("icon16/zoom.png")

		menu:AddOption("Flash Item", function()
			RunConsoleCommand("flashitem", self.Item:GetIDRef())
			end):SetIcon("icon16/world.png")

		menu:AddOption("Drop", function() CheckDropItem(self.Item) end):SetIcon("icon16/arrow_down.png")

		menu:Open()
	end
end

function PANEL:SetupItem()
	if self.Item then
		local itemref = ITEMS[self.Item:GetDataName()]
		if itemref.ToolTip then
			self:SetTooltip(itemref.ToolTip)
		end

		local icon = vgui.Create("DModelPanel", self)
			icon:SetPos(15, 5)
			icon:SetSize(64, 58)
			icon:SetModel(self.Item:GetModel())

			if itemref.InventoryCameraPos then
				local campos = itemref.InventoryCameraPos

				icon:SetCamPos(campos)
			else
				local mn, mx = icon:GetEntity():GetRenderBounds()
				local middle = (mn + mx) * 0.5
				local size = 0

				size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
				size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
				size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

				local dir = middle:GetNormal()

				if ( size < 900 ) then
					size = size * (1 - ( size / 900 ))
				else
					size = size * (1 - ( size / 4096 ))
				end

				size = math.Clamp( size, 5, 1000 )

				icon:SetCamPos(middle + dir * size * -1)
			end

			if itemref.ItemPanelMaterial then
				icon.Entity:SetMaterial(itemref.ItemPanelMaterial)
			end

			if itemref.InventoryCameraAng then
				icon:SetLookAt(itemref.InventoryCameraAng)
			else
				icon:SetLookAt(Vector(0, 0, 0))
			end

			--If the item wants to modify the model drawn, then call that function
			if itemref.DermaMenuSetup then
				itemref:DermaMenuSetup(icon)
			end

		self.ModelIcon = icon

		if itemref.Weapon then
			for k,v in pairs(LocalPlayer():GetWeapons()) do
				if v.GetItemID then
					if v:GetItemID() == self.Item:GetIDRef() then
						self.Equipped = true
					end
				end
			end
		end
	end
end

function PANEL:Think()
	if (self.Hovered or self.ModelIcon.Hovered) and not self.Pressed then
		if input.IsMouseDown(MOUSE_LEFT) then
			self.Pressed = true
			self:DoClick()
		elseif input.IsMouseDown(MOUSE_RIGHT) then
			self.Pressed = true
			self:DoRightClick()
		end
	elseif not (self.Hovered or self.ModelIcon.Hovered) and self.Pressed then
		self.Pressed = false
	end

	local gitem = GetGlobalItem(self.Item:GetDataName())
	if gitem.BuildItemPanelColor then
		self.ModelIcon:SetColor(gitem:BuildItemPanelColor())
	end

	if self.Item then
		if LocalPlayer():GetItemCountByID(self.Item:GetIDRef()) <= 0 then
			self:Remove()

			if self.ParentPanel then
				self.ParentPanel:UpdateEquipped()
			end
			return
		end

		if ITEMS[self.Item:GetDataName()].Weapon then
			local haveweapon = false
			for k,v in pairs(LocalPlayer():GetWeapons()) do
				if v.GetItemID then
					if v:GetItemID() == self.Item:GetIDRef() then
						haveweapon = true
						break
					end
				end
			end

			if haveweapon then
				self.Equipped = true
			else
				self.Equipped = false
			end
		end
	end
--[[
	if LocalPlayer().m_Equipment then
		for k,v in pairs(LocalPlayer().m_Equipment) do
			if v == self.ID.IDRef and not self.Equipped then
				self.Equipped = true
				break
			end
		end
	end]]
end

vgui.Register( "dItemPanel", PANEL, "EditablePanel" )