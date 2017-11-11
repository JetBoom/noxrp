local PANEL = {}

function PANEL:Init()
	local _w,_h = ScrW(),ScrH()
	
	self:SetPos(20, _h * 0.6)
	self:SetSize(500, 300)
	
	self.ScrollInv = vgui.Create("DScrollPanel", self)
		self.ScrollInv:SetPos(5, 5)
		self.ScrollInv:SetSize(self:GetWide() - 10, self:GetTall() * 0.8)
		
	self.itemList = vgui.Create( "DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide(), self.ScrollInv:GetTall())
		self.itemList:SetPos(0, 0)
		self.itemList:SetSpaceY(2)
		self.itemList:SetSpaceX(2)
		
	self.TextEntry = vgui.Create("RichText", self)
		self.TextEntry:SetPos(5, self:GetTall() - 30)
		self.TextEntry:SetSize(self:GetWide() - 10, 25)
		self.TextEntry:InsertColorChange(0, 0, 0, 255)
	self.TextEntry:Hide()
		
		
	self.History = {}
	self.Text = ""
	self.Spacing = 5
	self.Padding = 5
end

function PANEL:AddChat(...)
	local args = {...}
	
	local text = {}
				
	for k, v in pairs(args) do --parse players for total string length
		if type(v) == "table" then
			table.insert(text, v)
		elseif type(v) == "Player" then
			local col = team.GetColor(v:Team())
						
			table.insert(text, col)
			table.insert(text, v:Nick())
		elseif type(v) == "string" then
			table.insert(text, v)
		end
	end
				
	local str = ""
	for k, v in pairs(text) do
		if type(v) == "string" then
			str = str..v
		end
	end
	
	surface.SetFont("Xolonium16")
	local tw, th = surface.GetTextSize(str)

	local width = self:GetWide() - 10
	local height = 20
	while tw > width do
		height = height + 20
		tw = tw - width
	end
	
	local panel = vgui.Create("DPanel", self)
		panel:SetSize(width, height)
		panel.Text = text
		panel.Paint = function(pnl, w, h)
			draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 100))
		end
		
	local richtext = vgui.Create("RichText", panel)
		richtext:SetSize(panel:GetWide(), panel:GetTall())
		richtext:SetPos(0, 0)
		richtext:InsertColorChange(0, 0, 0, 255)
		richtext:SetFontInternal("Xolonium16")
		richtext.PerformLayout = function(rhtx)
			rhtx:SetFontInternal("Xolonium16")
			rhtx:SetBGColor(Color( 0, 0, 0, 0 ))
		end
		
		local prevx = 0
		local prevh = 0
		local col = Color(255, 255, 255)
				
		for _, item in pairs(text) do
			if type(item) == "table" then
				richtext:InsertColorChange(item.r, item.g, item.b, 255)
			else
				richtext:AppendText(item)
			end
		end
		panel.DieTime = CurTime() + 5
		panel.Think = function(pnl)
			if pnl.DieTime < CurTime() then
				if not self.State then
					pnl:Hide()
				end
			end
		end
		panel.ShouldPaint = true
		--self.itemList:Add(panel)
		--self:AddPanel(panel)
		table.insert(self.History, 1, panel)
		self:UpdatePositions()
end

function PANEL:UpdatePositions()
	local height = self:GetTall() - 30
	
	for i=1, #self.History do
		local pnl = self.History[i]
		if pnl then
			height = height - pnl:GetTall() - self.Spacing
		
			if height < 0 then
				if self.History[i] then
					if self.History[i]:IsValid() then
						self.History[i]:Remove()
					end
					self.History[i] = nil
				end
			else
				pnl:SetPos(5, height)
			end
		end
	end
end

function PANEL:OpenChat()
	self.State = true
	
	gui.EnableScreenClicker(true)
	
	local children = self.itemList:GetChildren()
	
	for k,v in pairs(children) do
		if pnl.DieTime < CurTime() then
			v:Show()
		end
	end
	
	self.TextEntry:Show()
	
	if #children > 0 then
		self.ScrollInv:ScrollToChild(children[#children])
	end
end

function PANEL:OnTextChanged(text)
	self.Text = text
	self.TextEntry:SetText(text)
end

function PANEL:CloseChat()
	self.State = false
	
	gui.EnableScreenClicker(false)
	for k,v in pairs(self.itemList:GetChildren()) do
		if pnl.DieTime < CurTime() then
			v:Hide()
		end
	end
	
	self.TextEntry:Hide()
end

function PANEL:Paint( w, h )
	if self.State then
		draw.RoundedBox(8, 0, 0, w, h, Color(10,10,10,200))
		
		--surface.SetDrawColor(240, 240, 240, 220)
		--surface.DrawRect(5, h - 25, w - 10, 20)
		
	--	draw.SimpleText(self.Text, "Xolonium16", 10, h - 15, Color(20, 20, 20, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function PANEL:CleanRemove()
	self:Remove()
end

vgui.Register("NCChatBox", PANEL, "EditablePanel")