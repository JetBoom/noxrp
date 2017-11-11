local PANEL = {}

function PANEL:Init()
	self.Pressed = false
end

function PANEL:Paint( w, h )
--	surface.SetDrawColor(0,0,0,150)
--	surface.DrawRect(0,0,w,h)
--	draw.RoundedBox(8,0,0,w,h,Color(0,0,0,150))
	local col = Color(40,40,40,180)
	if self.Hovered then
		col = Color(60,60,60,180)
	end
	draw.SlantedRectHorizOffset(0,0,w-10,h-4,10,col,Color(0,0,0,255),2,2)
	
	if self.Item then
		local iteminfo = self.Item:GetGlobalItem()
		local itemamt = self.Item:GetAmount()
		local weight = self.Item:GetWeight()
		
		local namestr = self.Item:GetItemName()

		draw.SimpleText(namestr,"hidden18",w*0.16,5,Color(200,200,255,255),TEXT_ALIGN_LEFT)
		
		if iteminfo.Description then
			draw.DrawText(iteminfo.Description, "hidden12", w * 0.16, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end
		
		if iteminfo.BasePrice then
			draw.DrawText("Sell Price: "..math.Round((iteminfo.BasePrice or 20) * 0.7),"hidden12", w * 0.9,40,Color(200,255,200,255),TEXT_ALIGN_RIGHT)
		end
		if self.Equipped then
			draw.DrawText("Equipped","hidden12",w*0.04,40,Color(200,255,200,255),TEXT_ALIGN_LEFT)
		end
	end
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:DoClick()
	local menu = DermaMenu()
		menu:AddOption("Sell 1", function() 
				RunConsoleCommand("sellitem", self.Item:GetIDRef(), 1)
				
				self:OnClose()
				end)
				
		menu:AddOption("Sell 5", function() 
				RunConsoleCommand("sellitem", self.Item:GetIDRef(), 5)
				
				self:OnClose()
				end)
				
		menu:AddOption("Sell 25", function() 
				RunConsoleCommand("sellitem", self.Item:GetIDRef(), 25)
				
				self:OnClose()
				end)
				
		menu:AddOption("Sell 50", function() 
				RunConsoleCommand("sellitem", self.Item:GetIDRef(), 50)
				
				self:OnClose()
				end)
	menu:Open()
end

function PANEL:SetupItem()
	local w = self:GetWide()
	local h = self:GetTall()
			
	if self.Item then
		local itemref = self.Item:GetGlobalItem()
		if itemref.ToolTip then
			self:SetToolTip(itemref.ToolTip)
		end
	
		local icon = vgui.Create("DModelPanel", self)
			icon:SetPos(15,5)
			icon:SetSize(64,64)
			icon:SetModel(itemref.Model)
			icon:SetCamPos(Vector(50,0,0))
			icon:SetLookAt(Vector(0,0,0))
			
			
		if LocalPlayer().m_Equipment then
			for k,v in pairs(LocalPlayer().m_Equipment) do
				if v == self.Item:GetIDRef() then
					self.Equipped = true
					break
				end
			end
		end
		
		for k, v in pairs(LocalPlayer():GetWeapons()) do
			if v.GetItemID then
				if v:GetItemID() == self.Item:GetIDRef() then
					self.Equipped = true
					break
				end
			end
		end
	end
end

function PANEL:Think()
	if self.Hovered and not self.Pressed then
		if input.IsMouseDown(MOUSE_LEFT) then
			self.Pressed = true
			self:DoClick()	
		end
	elseif self.Pressed and not input.IsMouseDown(MOUSE_LEFT)then
		self.Pressed = false
	end
	
	if self.Item then
		if LocalPlayer():GetItemCountByID(self.Item:GetIDRef()) <= 0 then
			self:OnClose()
			return
		end
	end
end

vgui.Register( "dItemPanelMerchant_PL", PANEL, "EditablePanel" )