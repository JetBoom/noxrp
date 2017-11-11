local PANEL = {}

function PANEL:BuyItemX()
	local frame = vgui.Create("DFrame")
		frame:SetSize(200,100)
		frame:SetPos(ScrW()/2-100, ScrH()/2-50)
		frame:SetTitle("How many?")
		frame:SetDeleteOnClose(true)
		frame:ShowCloseButton(true)
		frame:SetDraggable(true)
		frame:SetMouseInputEnabled(true)
		frame:MakePopup()
		
		frame.BuyAmount = 1
		
	local entry = vgui.Create("DTextEntry",frame)
		entry:SetPos(5,frame:GetTall()-50)
		entry:SetSize(frame:GetWide()-10,20)
		entry:SetNumeric(true)
		entry:SetUpdateOnType(true)
		
	local buybtn = vgui.Create("DButton", frame)
		buybtn:SetText("Buy")
		buybtn:SetPos(5,frame:GetTall()-25)
		buybtn:SetSize(frame:GetWide()-10,20)
		buybtn.DoClick = function(btn)
			self:BuyItem(tonumber(entry:GetValue()))
			frame:Close()
		end
end


function PANEL:Init()
	self.Pressed = false
	self.DoLayout = false
end

function PANEL:Paint( w, h )
--	surface.SetDrawColor(0,0,0,150)
--	surface.DrawRect(0,0,w,h)
--	draw.RoundedBox(8,0,0,w,h,Color(0,0,0,150))
	local col = Color(20, 20, 20, 200)
	if self.Hovered then
		col = Color(50, 50, 50, 180)
	end
	--draw.SlantedRectHorizOffset(0, 0, w - 30, h - 4, 10, col, Color(0, 0, 0, 255), 2, 2)
	draw.ElongatedHexagonHorizontalOffset(0, 0, w - 2, h - 4, 8, Color(0, 0, 0, 255), col, 2, 2)
	
	local id = self.Item
	if id then
		local iteminfo = ITEMS[id:GetDataName()]
	--	surface.SetDrawColor(0,0,0,200)
	--	surface.DrawRect(w*0.25,5,w*0.5,20)
		local namestr = id:GetItemName()
		draw.SimpleText(namestr, "hidden18", w * 0.2, 5, Color(200, 200, 255, 255), TEXT_ALIGN_LEFT)
		if self.Item:GetData().Price then
			draw.DrawText("Buy Price: "..self.Item:GetData().Price,"hidden16",w*0.2,25,Color(200,255,200,255),TEXT_ALIGN_LEFT)
		end
		if iteminfo.Description then
			draw.DrawText(iteminfo.Description,"hidden12",w*0.2,45,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		end
	end
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:BuyItem(amt)
	if not LocalPlayer():HasItem("money", amt * self.Item:GetData().Price) then
		self.MainParent:OpenFlagInfo(MERCH_FLAG_NOMONEY)
	elseif not LocalPlayer():CanTakeItem(self.Item, amt) then
		self.MainParent:OpenFlagInfo(MERCH_FLAG_TOOHEAVY)
	else
		RunConsoleCommand("buyitem", self.Item:GetDataName(),amt)
	end
end

function PANEL:DoClick()
	local menu = DermaMenu()
		menu:AddOption("Buy 1", function() self:BuyItem(1) end)
		menu:AddOption("Buy 5", function() self:BuyItem(5) end)
		menu:AddOption("Buy 10",function() self:BuyItem(10) end)
		menu:AddOption("Buy X", function() self:BuyItemX() end)
	menu:Open()
end

function PANEL:SetupItem()
	local w = self:GetWide()
	local h = self:GetTall()
			
	local icon = vgui.Create("DModelPanel", self)
		icon:SetPos(15,5)
		icon:SetSize(64,64)
		icon:SetModel(self.Item:GetModel())
		icon:SetCamPos(Vector(50,0,0))
		icon:SetLookAt(Vector(0,0,0))
end

function PANEL:Think()
	if self.Hovered and not self.Pressed then
		if input.IsMouseDown(MOUSE_LEFT) then
			self.Pressed = true
			self:DoClick()
		end
	elseif not self.Hovered and self.Pressed then
		if not input.IsMouseDown(MOUSE_LEFT) then
			self.Pressed = false
		end
	end
end

vgui.Register( "dItemPanelMerchant", PANEL, "Panel" )