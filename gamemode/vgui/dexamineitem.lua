local PANEL = {}

local Coloring = {
	["Damage"] = true,
	["Range"] = true,
	["Cone"] = false,
	["Delay"] = false,
	["ClipSize"] = true,
	["NumShots"] = true
}
	
local cleaninfo = {
	["Damage"] = "Damage",
	["ClipSize"] = "Mag Size",
	["NumShots"] = "Bullets Fired",
	["Cone"] = "Spread",
	["Range"] = "Range",
	["Delay"] = "Delay"
}

function PANEL:Init()
	self:SetDraggable(true)
	self:SetTitle("")
	self:ShowCloseButton(false)
	
	LocalPlayer().v_ExaminePanel = self
	AddOpenedVGUIElement(self)
end

function PANEL:SetupItem()
	self.Weight = self.Item:GetTotalWeight()
	self.GlobalItem = GetGlobalItem(self.Item:GetDataName())
	self.PanelsToRemove = {}
	self.RefreshPanels = {}
	self.EChips = {}
	
	local exitb = vgui.Create("DButton", self)
		exitb:SetPos(self:GetWide() - 25, 5)
		exitb:SetSize(20, 20)
		exitb:SetText("")
		exitb.DoClick = function()
			self:OnClose()
				
			for _, pnl in pairs(self.PanelsToRemove) do
				pnl:Remove()
				pnl = nil
			end
				
			LocalPlayer().v_ExaminePanel = nil
		end
		exitb.Paint = function(btn, bw, bh)
			draw.SlantedRectHorizOffset(0, 0, bw, bh, 10, Color(60, 60, 60, 220), Color(30, 30, 30, 255), 2, 2)
			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(50, 150, 255, 255)
			end
			draw.SimpleText("X", "hidden14", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	local icon = vgui.Create("DModelPanel", self)
		icon:SetPos(5, 70)
		icon:SetSize(self:GetWide() - 10, 120)
		icon:SetModel(self.Item:GetModel())

		local campos = self.GlobalItem.ExamineCameraPos or Vector(0, 50, 5)
		icon:SetCamPos(campos)
		icon:SetLookAt(self.GlobalItem.ExamineCameraAng or Vector(0, 0, 0))
			
		if self.GlobalItem.DermaMenuSetup then
			self.GlobalItem:DermaMenuSetup(icon)
		end
		
	self.ModelIcon = icon
	
	self.Created = true
	self.IncrementHeight = 0
	
	self:Refresh()
end

function PANEL:Refresh()
	self:SetDraggable(true)
	self.Item = LocalPlayer():GetItemByID(self.Item:GetIDRef())
	
	self.IncrementHeight = 0
	self:SetTall(200)
	self.EChips = self.Item:GetData().Slots
			
	for _, panel in pairs(self.RefreshPanels) do
		panel:Remove()
	end
			
	if self.GlobalItem.Durability then
		self.IncrementHeight = self.IncrementHeight + 30
		self:SetTall(200 + self.IncrementHeight)
				
		local durapnl = vgui.Create("DPanel", self)
			durapnl:SetPos(self:GetWide() * 0.2, 200)
			durapnl:SetSize(self:GetWide() * 0.6, 25)
			durapnl.Paint = function(pnl, pw, ph)
				draw.SlantedRectHorizOffset(0, 0, pw, ph, 5, Color(30, 30, 30, 255), Color(50, 50, 50, 180), 1, 1)
						
				local dur = math.Round(self.Item:GetData().Durability, 2) or 0
				local maxdur = self.Item:GetData().MaxDurability or 100
				if dur > 0 then
					draw.SimpleText("Durability: "..dur.."/"..maxdur, "hidden10", pw * 0.5, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					surface.SetDrawColor(10, 10, 10, 255)
					surface.DrawRect(5, ph - 10, pw - 10, 8)
							
					surface.SetDrawColor(255 - 255 * (dur / maxdur), 255 * dur * 0.01, 10, 255)
					surface.DrawRect(6, ph - 9, (pw - 12) * (dur / maxdur), 6)
				else
					draw.SimpleText("[BROKEN]", "hidden14", pw * 0.5, 2, Color(255, 50, 50, 255), TEXT_ALIGN_CENTER)
				end
			end
				
		table.insert(self.RefreshPanels, dirapnl)
	end
			
	if self.GlobalItem.Weapon then
		if self.GlobalItem.MutatableList then
			local ScrollStats = vgui.Create("DScrollPanel", self)
				ScrollStats:SetPos(5, 230)
				ScrollStats:SetSize(self:GetWide() - 10, math.ceil(#self.GlobalItem.MutatableList / 2) * 35 + 20)
						
			table.insert(self.RefreshPanels, ScrollStats)
									
			local statsList = vgui.Create( "DIconLayout", ScrollStats)
				statsList:SetSize(ScrollStats:GetWide() - 25, ScrollStats:GetTall() - 10)
				statsList:SetPos(5, 10)
				statsList:SetSpaceY(5)
				statsList:SetSpaceX(10)
				
			table.insert(self.RefreshPanels, statsList)
						
			self.IncrementHeight = self.IncrementHeight + math.ceil(#self.GlobalItem.MutatableList / 2) * 35 + 30
			self:SetTall(200 + self.IncrementHeight)
					
			local newstats = {}
			for _, var in pairs(self.GlobalItem.MutatableList) do
				newstats[var] = self.GlobalItem[var]
			end
					
			if self.Item:GetData().Slots then
				for slot, chip in pairs(self.Item:GetData().Slots) do
					local gitem = GetGlobalItem(chip.Name)
											
					for _, tab in pairs(gitem:WeaponStats()) do
						local var, pos
								
						if tab[1] == ENHANCEMENT_TYPE_BULLETS then
							var = self.GlobalItem["NumShots"]
							pos = "NumShots"
						elseif tab[1] == ENHANCEMENT_TYPE_ACCURACY then
							var = self.GlobalItem["Cone"]
							pos = "Cone"
						elseif tab[1] == ENHANCEMENT_TYPE_DAMAGE then
							var = self.GlobalItem["Damage"]
							pos = "Damage"
						elseif tab[1] == ENHANCEMENT_TYPE_CLIPSIZE then
							var = self.GlobalItem["ClipSize"]
							pos = "ClipSize"
						else
							var = self.GlobalItem["Delay"]
							pos = "Delay"
						end
								
						if tab[2] == ENHANCEMENT_ADD then
							var = var + tab[3]
						elseif tab[2] == ENHANCEMENT_SUBTRACT then
							var = var - tab[3]
						elseif tab[2] == ENHANCEMENT_MULTIPLY then
							if pos == "ClipSize" or pos == "NumShots" then
								var = math.max(math.Round(var * tab[3]), 1)
							else
								var = var * tab[3]
							end
						else
							var = var / tab[3]
						end
								
						newstats[pos] = var
					end
				end
			end
					
			for _, var in pairs(self.GlobalItem.MutatableList) do
				if cleaninfo[var] then
					local base = self.GlobalItem[var]
						
					local infovgui = vgui.Create("DPanel")
						infovgui:SetSize(statsList:GetWide() * 0.5 - 5, 35)
						infovgui.Paint = function(pnl, w, h)
							local center = base
							local moddedval = newstats[var]
										
							draw.SlantedRectHorizOffset(0, 0, w, h, 5, Color(30, 30, 30, 255), Color(50, 50, 50, 180), 1, 1)
							draw.SimpleText(cleaninfo[var]..": "..(moddedval), "hidden10", w * 0.5, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
										
							local ends = {Lower = center * 0.75, Higher = center * 1.25}
										
							surface.SetDrawColor(10, 10, 10, 255)
							surface.DrawRect(5, h - 18, w - 10, 12)
											
							if moddedval > center then
								if Coloring[var] then
									surface.SetDrawColor(10, 255, 10, 255)
								else
									surface.SetDrawColor(255, 10, 10, 255)
								end
									--local scale = 
								surface.DrawRect(w * 0.5, h - 18, (w * 0.5 - 5) * math.min(((moddedval - center) / (ends.Higher - center)), 1), 12)
							elseif moddedval < center then
								if not Coloring[var] then
									surface.SetDrawColor(10, 255, 10, 255)
								else
									surface.SetDrawColor(255, 10, 10, 255)
								end
										
								local sizew = (w * 0.5 - 5) * ((center - moddedval) / ends.Lower)
								surface.DrawRect(w * 0.5 - sizew, h - 18, sizew, 12)
							else
								surface.SetDrawColor(10, 10, 255, 255)
								surface.DrawRect(w * 0.5 - 5, h - 18, 10, 12)
							end
						end	
								
					statsList:Add(infovgui)
				end
			end
		end
				
		print(self.Item:GetData().Slots)
		if self.Item:GetData().Slots then	
			local ChipsScroll = vgui.Create("DScrollPanel", self)
				ChipsScroll:SetPos(5, 200 + self.IncrementHeight)
				ChipsScroll:SetSize(self:GetWide() - 10, self.GlobalItem.MaxEChips * 60 + 10)
						
			self.IncrementHeight = self.IncrementHeight + self.GlobalItem.MaxEChips * 60 + 20
			self:SetTall(200 + self.IncrementHeight)
						
			table.insert(self.RefreshPanels, ChipsScroll)
									
			local ChipsList = vgui.Create( "DIconLayout", ChipsScroll)
				ChipsList:SetSize(ChipsScroll:GetWide() - 25, ChipsScroll:GetTall() - 10)
				ChipsList:SetPos(5, 5)
				ChipsList:SetSpaceY(5)
				ChipsList:SetSpaceX(10)
						
			table.insert(self.RefreshPanels, ChipsList)

			for i = 1, self.GlobalItem.MaxEChips do
				//If we have an echip in this slot, display it
				local panel = vgui.Create("DButton")
					panel:SetPos(0, 200 + self.IncrementHeight)
					panel:SetSize(ChipsList:GetWide(), 60)
					panel:SetText("")
							
				if self.EChips[i] then
					local gitem = ITEMS[self.EChips[i].Name]
							
					panel.Paint = function(pnl, pw, ph)
						draw.ElongatedHexagonHorizontalOffset(0, 0, pw, ph, 6, Color(40, 40, 40, 255), Color(30, 30, 30, 255), 2, 2)
						draw.SimpleText("E-Chip Slot 1:", "Xolonium14", pw * 0.5, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
								
						draw.SimpleText(gitem.Name, "Xolonium14", pw * 0.5, 25, gitem:GetLetterColor(), TEXT_ALIGN_CENTER)
						draw.SimpleText(gitem.Description, "Xolonium14", pw * 0.5, 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					end
					
					local icon = vgui.Create("DModelPanel", panel)
						icon:SetPos(5, 5)
						icon:SetSize(48, 48)
						icon:SetModel(gitem.Model)
						icon:SetCamPos(Vector(0, 0, 8))
						icon:SetLookAt(Vector(0, 0, 0))
				else
					panel.Paint = function(pnl, pw, ph)
						draw.ElongatedHexagonHorizontalOffset(0, 0, pw, ph, 6, Color(40, 40, 40, 255), Color(30, 30, 30, 255), 2, 2)
						draw.SimpleText("E-Chip Slot 1:", "Xolonium14", pw * 0.5, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
								
						draw.SimpleText("[Empty]", "Xolonium14", pw * 0.5, 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					end
				end
						
				panel.DoClick = function(btn)
					local chipsininventory = {}
							
					for _, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
						local globalchip = GetGlobalItem(item:GetDataName())
						if globalchip.IsEChip then
							if globalchip:CanApplyToWeapon(self.GlobalItem) then
								table.insert(chipsininventory, item)
							end
						end
					end
							
					if #chipsininventory > 0 then
						surface.PlaySound("UI/buttonclick.wav")
						local x, y = self:GetPos()
								
						local chiplist = vgui.Create("DPanel")
							chiplist:SetPos(x + self:GetWide(), y + self:GetTall() - 120)
							chiplist:SetSize(300, 50 + 30 * #chipsininventory)
									
							chiplist.Paint = function(pnl, pw, ph)
								x, y = self:GetPos()
								if self.Dragging then
									pnl:SetPos(x + self:GetWide(), y + self:GetTall() - 120)
								end
											
								draw.SlantedRectHoriz(0, 0, pw, ph, 0, Color(10, 10, 10, 180), Color(20, 20, 20, 220))
								draw.SimpleText("Swap E-Chip in Slot 1 to:", "Xolonium14", pw * 0.5, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
							end
									
						local ChipsScroll2 = vgui.Create("DScrollPanel", chiplist)
							ChipsScroll2:SetPos(5, 25)
							ChipsScroll2:SetSize(chiplist:GetWide(), chiplist:GetTall() - 30)
												
						local ChipsList2 = vgui.Create( "DIconLayout", ChipsScroll2)
							ChipsList2:SetSize(ChipsScroll2:GetWide() - 25, ChipsScroll2:GetTall() - 10)
							ChipsList2:SetPos(5, 5)
							ChipsList2:SetSpaceY(5)
							ChipsList2:SetSpaceX(10)
									
						for _, item in pairs(chipsininventory) do
							local chip = vgui.Create("DButton")
								chip:SetSize(ChipsList2:GetWide(), 30)
								chip:SetText("")
								chip.Paint = function(btn, bw, bh)
									draw.SlantedRectHorizOffset(0, 0, bw, bh, 2, Color(30, 30, 30, 180), Color(0, 0, 0, 255), 2, 2)
											
									draw.SimpleText(item:GetItemName(), "Xolonium14", bw * 0.5, bh * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end
										
								chip.DoClick = function()
									RunConsoleCommand("applyechip", self.Item:GetIDRef(), item:GetIDRef(), i)
											
									for index, pnl in pairs(self.PanelsToRemove) do
										if pnl == chip then
											table.remove(self.PanelsToRemove, index)
										end
									end
											
									chiplist:Remove()
								end
										
							ChipsList2:Add(chip)
						end
									
						table.insert(self.PanelsToRemove, chiplist)
					end
				end
						
				ChipsList:Add(panel)
			end
		end
	end
	
	if self.GlobalItem.CustomExamine then
		self.GlobalItem:CustomExamine(self, self.Item)
	end
end

function PANEL:Paint( w, h )
	if self.Created then
		local namestr = self.Item:GetItemName()
		if self.Item:GetAmount() > 1 and (not self.NotStackable or not self.Mutatable) then
			namestr = namestr.."  [".. self.Item:GetAmount().."]"
		end
		
		//draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 150))
		//draw.RoundedBox(8, 1, 1, w - 2, h - 2, Color(0, 0, 0, 200))
		//draw.RoundedBox(8, 2, 2, w - 4, h - 4, Color(20, 20, 20, 255))
		
		draw.SlantedRectHorizOffset(0, 0, w - 2, 70, 0, Color(10, 10, 10, 250), Color(0, 0, 0, 255), 2, 2)
		draw.SlantedRectHorizOffset(0, 70, w - 2, 120, 0, Color(10, 10, 10, 180), Color(0, 0, 0, 255), 2, 2)
		draw.SlantedRectHorizOffset(0, 190, w - 2, h - 192, 0, Color(10, 10, 10, 250), Color(0, 0, 0, 255), 2, 2)
		//draw.SlantedRectHorizOffset(5, 30, pw - 20, ph - 35, 2, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 2, 2)
					
		draw.NoTexture()

		draw.SlantedRectHorizOffset(5, 5, w - 30, 40, 10, Color(40, 40, 40, 220), Color(30, 30, 30, 255), 2, 2)
					
		draw.SimpleText(namestr, "hidden14", w * 0.5, 15, Color(50, 150, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self.GlobalItem.Description then
			draw.SimpleText(self.GlobalItem.Description, "hidden12", w * 0.5, 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
					
		draw.SlantedRectHorizOffset(w * 0.5 - 90, 50, 180, 20, 10, Color(40, 40, 40, 220), Color(30, 30, 30, 255), 2, 2)
		draw.SimpleText("Weight: "..self.Weight, "hidden12", w * 0.5, 60, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:Think()
	//Basically, if the color should be changing, then use this function BuildItemPanelColor. If it just needs to be set once, use DermaMenuSetup
	if self.GlobalItem.BuildItemPanelColor then
		self.ModelIcon:SetColor(self.GlobalItem:BuildItemPanelColor())
	end
	
	//Default Frame stuff for dragging mostly
	local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )
	end
	
	if ( self.Hovered && self:GetDraggable() && mousey < ( self.y + 24 ) ) then
		self:SetCursor( "sizeall" )
		return
	end
	
	self:SetCursor( "arrow" )
	
	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end
end

function PANEL:OnClose()
	LocalPlayer().v_ExaminePanel = nil
	RemoveVGUIElement(self)
	
	self:Remove()
end

vgui.Register( "dExamineItem", PANEL, "DFrame" )