local PANEL = {}

function PANEL:Init()
	LocalPlayer().v_InventoryPanelMerch = self
	
	AddOpenedVGUIElement(self)

	local w = self:GetWide()
	local h = self:GetTall()
	self.DoBackgroundBlur = false
	self.Method = 1
	--0 is buy
	--1 is sell
	
	
	self.Closebutton = vgui.Create("DButton", self)
	self.Closebutton:SetSize(30,25)
	self.Closebutton:SetPos(w - 28,1)
	self.Closebutton:SetText("")
	self.Closebutton.Paint = function(btn)
		draw.SlantedRectHorizOffset(0,0,btn:GetWide()-2,btn:GetTall(),15,Color(0,0,0,230),Color(50,50,50,255),2,2)
		local col = Color(200,200,200,255)
		if btn.Hovered then
			if btn:IsDown() then
				col = Color(255,255,255,255)
			else
				col = Color(0,150,255,255)
			end
		end
		draw.SimpleText("X","hidden14",btn:GetWide()/2,btn:GetTall()/2,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	self.Closebutton.DoClick = function()
		if self.CanClose then
			self:FlushRemove()
		end
	end
	
	self.Buybutton = vgui.Create("DButton", self)
	self.Buybutton:SetSize(75,25)
	self.Buybutton:SetPos(w*0.4,1)
	self.Buybutton:SetText("")
	self.Buybutton.Paint = function(btn)
		draw.SlantedRectHorizOffset(0,0,btn:GetWide()-2,btn:GetTall(),15,Color(0,0,0,230),Color(50,50,50,255),2,2)
		local col = Color(200,200,200,255)
		if btn.Hovered then
			if btn:IsDown() then
				col = Color(255,255,255,255)
			else
				col = Color(0,150,255,255)
			end
		end
		draw.SimpleText("Buy","hidden14",btn:GetWide()/2,btn:GetTall()/2,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	self.Buybutton.DoClick = function()
		if self.Method == 0 then
			self.Method = 1
			self:SetupInventory_Buy()
		end
	--	self:FlushRemove()
	end
	
	self.Sellbutton = vgui.Create("DButton", self)
	self.Sellbutton:SetSize(75,25)
	self.Sellbutton:SetPos(w*0.6,1)
	self.Sellbutton:SetText("")
	self.Sellbutton.Paint = function(btn)
		draw.SlantedRectHorizOffset(0,0,btn:GetWide()-2,btn:GetTall(),15,Color(0,0,0,230),Color(50,50,50,255),2,2)
		local col = Color(200,200,200,255)
		if btn.Hovered then
			if btn:IsDown() then
				col = Color(255,255,255,255)
			else
				col = Color(0,150,255,255)
			end
		end
		draw.SimpleText("Sell","hidden14",btn:GetWide()/2,btn:GetTall()/2,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	self.Sellbutton.DoClick = function()
		if self.Method == 1 then
			self.Method = 0
			self:SetupInventory_Sell()
		end
	--	self:FlushRemove()
	end
	
	self.CanClose = true
end

function PANEL:OpenFlagInfo(id)
	self.CanClose = false
	
	local idlepanel = vgui.Create("DPanel")
	idlepanel:SetSize(700, 200)
	idlepanel:SetPos(self:GetWide() * 0.5 - 350,self:GetTall() * 0.4)
	idlepanel.Paint = function(pnl)
		local w = pnl:GetWide()
		local h = pnl:GetTall()
		
		draw.RoundedBox(6,0,0,w,h,Color(0,0,0,150))

		draw.DrawText(MERCH_REASON_TRANSLATE[id],"nulshock26",w * 0.5,15, Color(255, 200, 200, 255), TEXT_ALIGN_CENTER)
	end
	
	local continuebtn = vgui.Create("DButton",idlepanel)
	continuebtn:SetSize(idlepanel:GetWide()-30,25)
	continuebtn:SetPos(15,idlepanel:GetTall()-35)
	continuebtn:SetText("")
	continuebtn.Paint = function(btn)
		local w = btn:GetWide()
		local h = btn:GetTall()
		draw.RoundedBox(6,0,0,w,h,Color(0,0,0,150))
		
		local col = Color(255,255,255,255)
		if btn.Hovered then
			col = Color(50,150,255,255)
		end
		draw.SimpleText("Continue", "nulshock22", w * 0.5, 12, col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	continuebtn.DoClick = function(btn)
		self.CanClose = true
		idlepanel:Remove()
	end
end

function PANEL:RefreshChildren()
	for k,v in pairs(self:GetChildren()) do
		if v ~= self.Sellbutton and v ~= self.Buybutton and v ~= self.Closebutton and v ~= self.ItemExaminePanel then
			v:Remove()
		end
	end
end

function PANEL:FlushRemove()
	LocalPlayer().v_InventoryPanelMerch = nil
	self:Remove()
	
	RemoveVGUIElement(self)

	RunConsoleCommand("closeinventory")
end

function PANEL:ToggleBackgroundBlur()
	self.DoBackgroundBlur = not self.DoBackgroundBlur
end

function PANEL:Paint( w, h )
	if ( self.DoBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	
	local money = LocalPlayer():GetItemCount("money")
	draw.SlantedRectHorizOffset(0,0,w-30,25,15,Color(0,0,0,220),Color(0,0,0,255),2,2)
	draw.SlantedRectHorizOffset(10,h-45,w-30,25,-15,Color(0,0,0,220),Color(0,0,0,255),2,2)
	draw.SimpleText("Merchant","hidden18",w*0.25,12,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	
	draw.SimpleText("Money: "..money,"hidden18",w*0.25,h-30,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
end

function PANEL:SetupInventory_Buy()
	self:RefreshChildren()
	local w = self:GetWide()
	local h = self:GetTall()
	
	self.ScrollInv = vgui.Create("DScrollPanel",self)
		self.ScrollInv:SetPos(5,25)
		self.ScrollInv:SetSize(w * 0.5, h - 30)
		
	self.itemList = vgui.Create( "DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide() - 10, self.ScrollInv:GetTall() - 10)
		self.itemList:SetPos(5, 5)
		self.itemList:SetSpaceY(10)
		self.itemList:SetSpaceX(5)

	for k, item in pairs(self.Inventory:GetContainer()) do
		local itemvgui = vgui.Create("dItemPanelMerchant")
			itemvgui:SetSize(self.itemList:GetWide() - 10, 75)
			itemvgui.Item = item
			itemvgui:SetupItem()
			itemvgui.MainParent = self
			self.itemList:Add(itemvgui)
	end
end

function PANEL:SellInventory_Refresh()
	for k,v in pairs(self.itemList:GetChildren()) do
		v:Remove()
	end
	
	for k, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
		local itemref = item:GetGlobalItem()
		if not itemref.NoSell then
			local itemvgui = vgui.Create("dItemPanelMerchant_PL")
				itemvgui:SetSize(self.itemList:GetWide() - 10, 75)
				itemvgui.Item = item
				itemvgui:SetupItem()
				itemvgui.OnClose = function()
					self:SellInventory_Refresh()
				end
				self.itemList:Add(itemvgui)
		end
	end
end

function PANEL:SetupInventory_Sell()
	self:RefreshChildren()
	local w = self:GetWide()
	local h = self:GetTall()
	
	self.ScrollInv = vgui.Create("DScrollPanel",self)
		self.ScrollInv:SetPos(5,25)
		self.ScrollInv:SetSize(w-10,h-30)
		
	self.itemList = vgui.Create( "DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide() * 0.5 - 10, self.ScrollInv:GetTall() - 10)
		self.itemList:SetPos(5,5)
		self.itemList:SetSpaceY( 10 )
		self.itemList:SetSpaceX( 5 )

	for k, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
		local itemref = item:GetGlobalItem()
		if not itemref.NoSell then
			local itemvgui = vgui.Create("dItemPanelMerchant_PL")
				itemvgui:SetSize(self.itemList:GetWide() - 10, 75)
				itemvgui.Item = item
				itemvgui:SetupItem()
				itemvgui.OnClose = function()
					self:SellInventory_Refresh()
				end
				self.itemList:Add(itemvgui)
		end
	end
end

function PANEL:OnClickedItem(pnl)
	self.SelectedItem = pnl.Item
end

function PANEL:PerformLayout()
	local w = self:GetWide()
	local h = self:GetTall()
	self.Closebutton:SetPos( w - 28,0)
	
	self.Buybutton:SetPos(w*0.4,1)
	self.Sellbutton:SetPos(w*0.6,1)
end

vgui.Register( "dInventoryMerchant", PANEL, "Panel" )