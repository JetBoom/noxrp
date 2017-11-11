local PANEL = {}

local METHOD_TAKING = 0
local METHOD_GIVING = 1

function PANEL:Init()
	LocalPlayer().v_InventoryPanelOther = self
	
	AddOpenedVGUIElement(self)
	
	local w = self:GetWide()
	local h = self:GetTall()
	self.DoBackgroundBlur = false
	
	self.Closebutton = vgui.Create("DButton", self)
	self.Closebutton:SetSize(30, 25)
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
	
	self.Method = METHOD_TAKING
end

function PANEL:FlushRemove()
	LocalPlayer().v_InventoryPanelOther = nil
	self:Remove()
	
	RemoveVGUIElement(self)
	
	RunConsoleCommand("closeinventory")
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
	draw.SimpleText("Container", "hidden18", w * 0.25, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:SetupInventory(methodtoadd)
	local w = self:GetWide()
	local h = self:GetTall()
	
	if methodtoadd then
		w = w * 0.5
	end
	
	self.ScrollInv = vgui.Create("DScrollPanel",self)
		self.ScrollInv:SetPos(5,25)
		self.ScrollInv:SetSize(w - 10, h - 70)
		
	self.itemList = vgui.Create("DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide() - 30, self.ScrollInv:GetTall() - 60)
		self.itemList:SetPos(10, 10)
		self.itemList:SetSpaceY(10)
		self.itemList:SetSpaceX(5)
	
	local addbutn = vgui.Create("DButton", self)
		addbutn:SetPos(self:GetWide() - 140, 5)
		addbutn:SetSize(75, 20)
		addbutn:SetText("")
		addbutn.Paint = function(btn)
			draw.SlantedRectHorizOffset(0, 0, btn:GetWide() - 10, btn:GetTall(), 15, Color(0, 0, 0, 230), Color(50, 50, 50, 255), 2, 2)
			local col = Color(200, 200, 200, 255)
			if btn.Hovered then
				if btn:IsDown() then
					col = Color(255, 255, 255, 255)
				else
					col = Color(0, 150, 255, 255)
				end
			end
			draw.SimpleText("Give", "hidden14", btn:GetWide() * 0.5,btn:GetTall() * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		addbutn.DoClick = function()
			self.Method = METHOD_GIVING
			
			self:RefreshInventory()
		end
		
	local takebtn = vgui.Create("DButton", self)
		takebtn:SetPos(self:GetWide() - 210, 5)
		takebtn:SetSize(75, 20)
		takebtn:SetText("")
		takebtn.Paint = function(btn)
			draw.SlantedRectHorizOffset(0, 0, btn:GetWide() - 10, btn:GetTall(), 15, Color(0, 0, 0, 230), Color(50, 50, 50, 255), 2, 2)
			local col = Color(200, 200, 200, 255)
			if btn.Hovered then
				if btn:IsDown() then
					col = Color(255, 255, 255, 255)
				else
					col = Color(0, 150, 255, 255)
				end
			end
			draw.SimpleText("Take", "hidden14", btn:GetWide() * 0.5,btn:GetTall() * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		takebtn.DoClick = function()
			self.Method = METHOD_TAKING
			
			self:RefreshInventory()
		end
		
	self:RefreshInventory()
end

function PANEL:AddToInventory()
	for _, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
		local itemvgui = vgui.Create("dItemPanelOther")
			itemvgui:SetSize(self.itemList:GetWide() * 0.3, 65)
			itemvgui.ID = item
			itemvgui.Type = 1
			itemvgui:SetupItem()
			self.itemList:Add(itemvgui)
	end
end

function PANEL:TakeFromInventory()
	for k, item in pairs(self.Inventory) do
		local itemvgui = vgui.Create("dItemPanelOther")
			itemvgui:SetSize(self.itemList:GetWide() * 0.3, 65)
			itemvgui.ID = item
			itemvgui:SetupItem()
			self.itemList:Add(itemvgui)
	end
end

function PANEL:RefreshInventory()
	for _, pnl in pairs(self.itemList:GetChildren()) do
		pnl:Remove()
	end
	
	print("METHOD: ", self.Method)
	if self.Method == METHOD_TAKING then
		self:TakeFromInventory()
	else
		self:AddToInventory()
	end
end

function PANEL:PerformLayout()
	self.Closebutton:SetPos(self:GetWide() - 28, 0)
	self.Closebutton:SetSize(30, 25)
end

vgui.Register( "dInventoryContainer", PANEL, "Panel" )