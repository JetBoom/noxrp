local PANEL = {}

function PANEL:Init()
	self.Pressed = false
	self.DoLayout = false
	
	self.Type = 0
end

function PANEL:Paint( w, h )
	local col = Color(40, 40, 40, 180)
	if self.Hovered then
		col = Color(60, 60, 60, 180)
	end
	//draw.SlantedRectHorizOffset(0, 0, w - 30, h - 4, 10, col, Color(0, 0, 0, 255), 2, 2)
	draw.ElongatedHexagonHorizontalOffset(0, 0, w - 2, h - 4, 8, Color(0, 0, 0, 255), Color(0, 0, 0, 200), 2, 2)
	
	local id = self.ID
	if id then
		local iteminfo = ITEMS[id:GetDataName()]
		local namestr = iteminfo.Name
		local itemamt = id:GetAmount()
		if itemamt > 1 then
			namestr = namestr.."   ["..itemamt.."]"
		end
		draw.SimpleText(namestr,"hidden18", w * 0.5, 5, Color(200, 200, 255, 255), TEXT_ALIGN_CENTER)
		
		if id:GetGlobalItem().SmeltTime and id:GetData().SmeltTime then
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(50, h - 30, w - 100, 20)
			
			surface.SetDrawColor(50, 50, 150, 255)
			surface.DrawRect(51, h - 29, (w - 98) * (math.Round((id:GetData().SmeltTime - CurTime()), 1) / id:GetGlobalItem().SmeltTime), 18)
			
			draw.SimpleText("Smelting Time Left: " .. math.Round((id:GetData().SmeltTime - CurTime()), 1).." Seconds", "nulshock14", w * 0.5, h - 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	end
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:DoClick()
end

function PANEL:SetupItem()
	local w = self:GetWide()
	local h = self:GetTall()
			
	if self.Type == 0 then
		local takebtn = vgui.Create("DButton",self)
			takebtn:SetPos(w - 120, 5)
			takebtn:SetSize(75, 30)
			takebtn:SetText("Take")
			takebtn.Paint = function(btn)
				draw.SlantedRectHorizOffset(0, 0, btn:GetWide() - 2, btn:GetTall() - 2, 15, Color(0, 0, 0, 220),Color(0, 0, 0, 255), 2, 2)
			end
			takebtn.DoClick = function(btn)
				if LocalPlayer():CanTakeItem(self.ID, self.ID:GetAmount()) then
					RunConsoleCommand("takeinventoryitem", self.ID:GetIDRef())
					self:Remove()
				end
			end
	else
		local addbtn = vgui.Create("DButton",self)
			addbtn:SetPos(w - 120, 5)
			addbtn:SetSize(75, 30)
			addbtn:SetText("Add")
			addbtn.Paint = function(btn)
				draw.SlantedRectHorizOffset(0, 0, btn:GetWide() - 2, btn:GetTall() - 2, 15, Color(0, 0, 0, 220),Color(0, 0, 0, 255), 2, 2)
			end
			addbtn.DoClick = function(btn)
				RunConsoleCommand("addinventoryitem", self.ID:GetIDRef())
			end
	end
end

function PANEL:Think()
	if self.Hovered and not self.Pressed then
		if input.IsMouseDown(MOUSE_LEFT) then
			self.Pressed = true
			self:DoClick()
		elseif input.IsMouseDown(MOUSE_RIGHT) then
			self.Pressed = true
			self:DoRightClick()			
		end
	elseif not self.Hovered and self.Pressed then
		if not input.IsMouseDown(MOUSE_LEFT) and input.IsMouseDown(MOUSE_RIGHT) then
			self.Pressed = false
		end
	end
end

vgui.Register( "dItemPanelOther", PANEL, "Panel" )