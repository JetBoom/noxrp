local PANEL = {}

function PANEL:Init()
	LocalPlayer().v_InventoryPanel = self
	
	AddOpenedVGUIElement(self)

	local w = self:GetWide()
	local h = self:GetTall()
	self.DoBackgroundBlur = false
	
	self.Closebutton = vgui.Create("DButton", self)
	self.Closebutton:SetSize(30,25)
	self.Closebutton:SetPos(w - 28, 1)
	self.Closebutton:SetText("")
	self.Closebutton.Paint = function(btn)
		draw.SlantedRectHorizOffset(0, 0, btn:GetWide() - 2, btn:GetTall(), 15, Color(0, 0, 0, 230), Color(50, 50, 50, 255), 2, 2)
		local col = Color(200, 200, 200, 255)
		if btn.Hovered then
			if btn:IsDown() then
				col = Color(255, 255, 255, 255)
			else
				col = Color(0, 150, 255, 255)
			end
		end
		draw.SimpleText("X", "hidden14", btn:GetWide() * 0.5, btn:GetTall() * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.Closebutton.DoClick = function()
		self:FlushRemove()
	end
	
	self.m_fCreateTime = SysTime()
	self.s_Filter = "All"
end

function PANEL:FlushRemove()
	LocalPlayer().v_InventoryPanel = nil
	self.v_EquipmentPanel:OnClose()
	
	RemoveVGUIElement(self)
	self:Remove()
end

function PANEL:ToggleBackgroundBlur()
	self.DoBackgroundBlur = not self.DoBackgroundBlur
end

function PANEL:Paint( w, h )
	local weight = LocalPlayer():GetCurWeight()
	
	if self.DoBackgroundBlur then
		Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
	end
	
	draw.SlantedRectHorizOffset(0, 0, w - 30, 25, 15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	draw.SlantedRectHorizOffset(10, h - 45, w - 30, 25, -15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	draw.SimpleText("Inventory", "hidden16", w * 0.25, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Weight: "..weight.."/"..LocalPlayer():GetMaxWeight(), "hidden18", self:GetWide() * 0.6, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	draw.SimpleText("Inventory Filter: ", "hidden14", self:GetWide() * 0.08, h - 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:SetupInventory()
	self.ScrollInv = vgui.Create("DScrollPanel",self)
		self.ScrollInv:SetPos(5, 25)
		self.ScrollInv:SetSize(self:GetWide() - 5, self:GetTall() - 70)
		
	self.itemList = vgui.Create( "DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide() - 10, self.ScrollInv:GetTall() - 60)
		self.itemList:SetPos(10, 10)
		self.itemList:SetSpaceY(10)
		self.itemList:SetSpaceX(5)
		
	for k, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
		local itemvgui = vgui.Create("dItemPanel")
			itemvgui:SetSize(self.itemList:GetWide() * 0.2 - 5, 65)
			itemvgui.Item = item
			itemvgui.ParentPanel = self
			itemvgui:SetupItem()
			itemvgui.OnEmpty = function()
				itemvgui:Remove()
				self:RefreshInventory()
			end
		self.itemList:Add(itemvgui)
	end
	
	local allcat = vgui.Create("DButton", self)
		allcat:SetPos(self:GetWide() * 0.14, self:GetTall() - 42)
		allcat:SetSize(60,20)
		allcat:SetText("")
		allcat.Paint = function(btn)
			draw.SlantedRectHorizOffset(0, 0, btn:GetWide() - 4, btn:GetTall(), 15, Color(0, 0, 0, 230), Color(0, 0, 0, 255), 2, 2)
			local col = Color(255, 100, 100, 255)
			if btn.Hovered then
				if btn:IsDown() then
					col = Color(255, 255, 255, 255)
				else
					col = Color(0, 150, 255, 255)
				end
			end
			draw.SimpleText("All", "hidden12", btn:GetWide() * 0.5, btn:GetTall() * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		allcat.DoClick = function(btn)
			for k,v in pairs(self.itemList:GetChildren()) do
				v:Remove()
			end
			
			for k,item in pairs(LocalPlayer():GetInventory():GetContainer()) do
				local itemvgui = vgui.Create("dItemPanel")
					itemvgui:SetSize(self.itemList:GetWide() * 0.2 - 5, 65)
					itemvgui.Item = item
					itemvgui:SetupItem()
					itemvgui.ParentPanel = self
				self.itemList:Add(itemvgui)
			end
			self.s_Filter = "All"
			
			surface.PlaySound("UI/buttonclick.wav")
		end
		
	local catbtn = vgui.Create("DButton", self)
		catbtn:SetPos(self:GetWide() * 0.14 + 60, self:GetTall() - 42)
		catbtn:SetSize(150,20)
		catbtn:SetText("")
		catbtn.Text = "Sorting"
		catbtn.Paint = function(btn)
			draw.SlantedRectHorizOffset(0, 0, btn:GetWide() - 4, btn:GetTall(), 15, Color(0, 0, 0, 230), Color(0, 0, 0, 255), 2, 2)
			local col 
			if btn.Hovered then
				if btn:IsDown() then
					col = Color(255, 255, 255, 255)
				else
					col = Color(0, 150, 255, 255)
				end
			end
			draw.SimpleText(btn.Text, "hidden12", btn:GetWide() * 0.5, btn:GetTall() * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		catbtn.DoClick = function(btn)
			local menu = DermaMenu()
			for k,v in pairs(ITEM_CATEGORIES) do
				menu:AddOption(v, function() 
					btn.Text = v
					self.s_Filter = v
					self:RefreshInventory()
				end)
			end
			menu:Open()
			
			surface.PlaySound("UI/buttonclick.wav")
		end
		
	local protection = vgui.Create("DCheckBoxLabel", self)
		protection:SetPos(self:GetWide() * 0.14 + 220, self:GetTall() - 40)
		protection:SetText("Allow Drop Protection")
		protection:SetConVar("noxrp_dropprotection")
		protection:SetValue(GetConVar("noxrp_dropprotection"):GetInt())
		protection:SizeToContents()
	
	self:UpdateEquipped()
end

function PANEL:RefreshInventory()
	for _,child in pairs(self.itemList:GetChildren()) do
		child:Remove()
	end
	
	for k, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
		if self.s_Filter then
			if self.s_Filter == "All" then
				local itemvgui = vgui.Create("dItemPanel")
					itemvgui:SetSize(self.itemList:GetWide() * 0.2 - 5, 65)
					itemvgui.Item = item
					itemvgui.ParentPanel = self
					itemvgui:SetupItem()
					itemvgui.OnEmpty = function()
						itemvgui:Remove()
						self:RefreshInventory()
					end
				self.itemList:Add(itemvgui)
			else
				local gitem = ITEMS[item:GetDataName()]

				if self.s_Filter == gitem.Category then
					local itemvgui = vgui.Create("dItemPanel")
						itemvgui:SetSize(self.itemList:GetWide() * 0.2 - 5, 65)
						itemvgui.Item = item
						itemvgui.ParentPanel = self
						itemvgui:SetupItem()
						itemvgui.OnEmpty = function()
							itemvgui:Remove()
							self:RefreshInventory()
						end
					self.itemList:Add(itemvgui)
				end
			end
		else
			local itemvgui = vgui.Create("dItemPanel")
				itemvgui:SetSize(self.itemList:GetWide() * 0.2 - 5, 65)
				itemvgui.Item = item
				itemvgui.ParentPanel = self
				itemvgui:SetupItem()
				itemvgui.OnEmpty = function()
					itemvgui:Remove()
					self:RefreshInventory()
				end
			self.itemList:Add(itemvgui)
		end
	end
	
	self:UpdateEquipped()
end

function PANEL:UpdateEquipped()
	local weps = LocalPlayer():GetWeapons()
	local equip = LocalPlayer():GetEquipment()
	
	for k, pnl in pairs(self.itemList:GetChildren()) do
		if pnl.Equipped then
			pnl.Equipped = false
		end
	end
	
	for k, v in pairs(weps) do
		if v.GetIDTag then --no fists, since they aren't a real weapon
			for _, pnl in pairs(self.itemList:GetChildren()) do
				if pnl.Item:GetIDRef() == v:GetIDTag() then
					pnl.Equipped = true
					break
				end
			end
		end
	end
	
	for k, v in pairs(equip) do
		for _, pnl in pairs(self.itemList:GetChildren()) do
			if pnl.Item:GetIDRef() == v then
				pnl.Equipped = true
				break
			end
		end
	end
end

function PANEL:PerformLayout()
	self.Closebutton:SetPos(self:GetWide() - 28, 0)
	self.Closebutton:SetSize(30, 25)
end

function PANEL:Think()
end

vgui.Register( "dInventory", PANEL, "Panel" )