local PANEL = {}
function PANEL:Init()
	if LocalPlayer().m_CraftingMenu then self:Remove() return end
	LocalPlayer().m_CraftingMenu = self
	self.CanClose = true
	
	AddOpenedVGUIElement(self)
	local w = ScrW()
	local h = ScrH()
	self.DoBackgroundBlur = true
	
	self:SetSize(w,h)
	
	local closebtn = vgui.Create("DButton", self)
	closebtn:SetPos(w - 35, 25)
	closebtn:SetSize(30, 25)
	closebtn:SetText("")
	closebtn.DoClick = function(btn)
		if self.CanClose then
			self:OnRemove()
		end
	end
	
	closebtn.Paint = function(btn, bw, bh)
		draw.SlantedRectHorizOffset(0, 0, bw, bh, 15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("X", "hidden14", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	self.m_fCreateTime = SysTime()
	
	self.OpenX = 30
	self.OpenY = 30
	
	self.CompletedOpen = false
end

local recipes = RECIPEES

function PANEL:SetupInventory()

	local w = self:GetWide()
	local h = self:GetTall()
	
	self.Infopanel = vgui.Create("DPanel", self)
	local infopanel = self.Infopanel
	infopanel:SetPos(w * 0.3, 60)
	infopanel:SetSize(w * 0.7 - 40, h - 130)
	infopanel.ID = -1
	infopanel.Amount = 1
	
	infopanel.Paint = function(pnl, pnlw, pnlh)
		--draw.RoundedBox(8,0,0,pnlw, pnlh,Color(20,20,20,90))
		--draw.RoundedBox(8,0,0,pnlw, pnlh,Color(40,40,40,90))
		draw.SlantedRectHorizOffset(0, 0, pnlw - 4, pnlh - 4, 1, Color(40, 40, 40, 180), Color(0, 0, 0, 255), 2, 2)
		
		if recipes[pnl.ID] then
			local idrecipe = recipes[infopanel.ID]
			local text = idrecipe.Display.."  [x"..infopanel.Amount.."]"
			draw.SimpleText(text, "hidden18", pnlw * 0.5, 35, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			local resultitemid = idrecipe.FinishedItems[1][1]
			local resultitem = ITEMS[resultitemid]
			draw.SimpleText(resultitem.Description, "hidden14", pnlw * 0.5, 55,Color(220,220,255,255),TEXT_ALIGN_CENTER)
			
			if idrecipe.Skill then
				local req = idrecipe.Skill
				local reqamt = idrecipe.Difficulty
				local skill = LocalPlayer():GetSkill(req)
				
				draw.SimpleText("Required Skill: "..SKILLS[req].Name,"hidden16", pnlw * 0.5, pnlh * 0.13,Color(220,220,255,255),TEXT_ALIGN_CENTER)
				draw.SimpleText("Difficulty: "..reqamt, "hidden16", pnlw * 0.5, pnlh * 0.13 + 20, Color(255,255,255,255),TEXT_ALIGN_CENTER)
				draw.SimpleText("Skill: "..skill, "hidden16", pnlw * 0.5, pnlh * 0.13 + 40, Color(255,255,255,255),TEXT_ALIGN_CENTER)
			else
				
			end
			
			draw.SimpleText("Required Items: ", "hidden16", pnlw * 0.5, pnlh * 0.4 - 20,Color(220,255,220,255),TEXT_ALIGN_CENTER)
		end
	end
	
	local pnlw = infopanel:GetWide()
	local pnlh = infopanel:GetTall()
	
	infopanel.ScrollInv = vgui.Create("DScrollPanel",infopanel)
		infopanel.ScrollInv:SetPos(10, pnlh * 0.4)
		infopanel.ScrollInv:SetSize(pnlw - 20, pnlh * 0.2)
		
	infopanel.itemList = vgui.Create( "DIconLayout", infopanel.ScrollInv)
		infopanel.itemList:SetSize(infopanel.ScrollInv:GetWide() - 10, infopanel.ScrollInv:GetTall() - 10)
		infopanel.itemList:SetPos(10, 25)
		infopanel.itemList:SetSpaceY(10)
		infopanel.itemList:SetSpaceX(5)
		
		
	infopanel.RScrollInv = vgui.Create("DScrollPanel",infopanel)
		infopanel.RScrollInv:SetPos(10, pnlh * 0.72)
		infopanel.RScrollInv:SetSize(pnlw - 20, pnlh * 0.2)
		
	infopanel.RitemList = vgui.Create( "DIconLayout", infopanel.RScrollInv)
		infopanel.RitemList:SetSize(infopanel.RScrollInv:GetWide() - 10, infopanel.RScrollInv:GetTall() - 60)
		infopanel.RitemList:SetPos(10,25)
		infopanel.RitemList:SetSpaceY(10)
		infopanel.RitemList:SetSpaceX(5)
		
	infopanel.OpenRecipeInfo = function(pnl)
		if pnl.itemList:HasChildren() then
			for k,v in pairs(pnl.itemList:GetChildren()) do
				v:Remove()
			end
		end
		if pnl.RitemList:HasChildren() then
			for k,v in pairs(pnl.RitemList:GetChildren()) do
				v:Remove()
			end
		end
		if pnl.FinishedItem then
			pnl.FinishedItem:Remove()
			pnl.FinishedItem = nil
		end
		
		if pnl.SkillReq then
			pnl.SkillReq:Remove()
			pnl.SkillReq = nil
		end
		
		if recipes[pnl.ID] then
			local idrecipe = recipes[pnl.ID]
			for k,v in pairs(idrecipe.Requirements) do
				local tab = {}
					tab.Name = v[1]
					
					local int = LocalPlayer():GetStat(STAT_INTELLIGENCE)
					if int >= 17 then
						tab.Amount = math.ceil(v[2] * infopanel.Amount * 0.8)
					elseif int >= 12 then
						tab.Amount = math.ceil(v[2] * infopanel.Amount * 0.9)
					elseif int <= 5 then
						tab.Amount = math.ceil(v[2] * infopanel.Amount * 1.3)
					elseif int <= 7 then
						tab.Amount = math.ceil(v[2] * infopanel.Amount * 1.1)
					else
						tab.Amount = v[2] * infopanel.Amount
					end
					
				local iteminf = vgui.Create("dItemPanelSimple")
					iteminf:SetSize(pnl.itemList:GetWide() * 0.3, 65)
					iteminf.ID = tab
					iteminf:SetupItem()
					iteminf.HeaderColor = Color(180, 255, 180, 255)
					
				pnl.itemList:Add(iteminf)
			end

		local tab = {}
			tab.Name = recipes[pnl.ID].FinishedItems[1][1]
			tab.Amount = recipes[pnl.ID].FinishedItems[1][2] * infopanel.Amount
			
		local itemref = ITEMS[tab.Name]
			
		pnl.FinishedItem = vgui.Create("DModelPanel", pnl)
			pnl.FinishedItem:SetSize(pnl:GetWide() * 0.8 - 5, 500)
			pnl.FinishedItem:SetPos(pnl:GetWide() * 0.1, pnl:GetTall() * 0.5)
			pnl.FinishedItem:SetModel(itemref.Model)
			
			local size = pnl.FinishedItem:GetEntity():GetModelBounds()
				size.x = size.x * -3
				size.y = size.y * -3
				size.z = size.z * -3
			
			pnl.FinishedItem:SetCamPos(Vector(size.x + 20, size.y + 20, size.z + 20))
			pnl.FinishedItem:SetLookAt(Vector(0, 0, 0))
			
			if itemref.ItemPanelMaterial then
				pnl.FinishedItem.Entity:SetMaterial(itemref.ItemPanelMaterial)
			end
			
			if itemref.DermaMenuSetup then
				itemref:DermaMenuSetup(pnl.FinishedItem)
			end
		end
	end
	
	self.ScrollInv = vgui.Create("DScrollPanel",self)
		self.ScrollInv:SetPos(5,35)
		self.ScrollInv:SetSize(self:GetWide() * 0.29 - 4,self:GetTall()-70)
		
	self.itemList = vgui.Create( "DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide() - 10, self.ScrollInv:GetTall() - 60)
		self.itemList:SetPos(10, 25)
		self.itemList:SetSpaceY(5)
		self.itemList:SetSpaceX(5)
		
		
	for sortby, sortstr in pairs(RECIPEES_SORTBY) do --Adds the sorting lists
		local madespacer = false

		for k, v in pairs(recipes) do
			if v.Category == self.SFilter then
				if sortby == v.SortBy and not madespacer then
					if LocalPlayer():KnowRecipe(v.Name) then
						local spacer = vgui.Create("DButton")
							spacer:SetSize(self.itemList:GetWide(), 35)
							spacer:SetText("")
						spacer.SortBy = sortby
						spacer.IsSorted = false
						spacer.Paint = function(spc, w, h)
							local bgcol = Color(10, 10, 10, 230)
							local txtcol = Color(200, 200, 255, 255)
								
							if spc.IsSorted then
								bgcol = Color(40, 40, 40, 230)
								txtcol = Color(200, 255, 200, 255)
							end
							draw.SlantedRectHorizOffset(0, 0, w - 20, h - 2, 5, bgcol, Color(0, 0, 0, 255), 2, 2)
												
							draw.SimpleText(RECIPEES_SORTBY[spc.SortBy], "hidden14", w * 0.5, h * 0.5, txtcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end
							
						spacer.DoClick = function(btn)
							surface.PlaySound("UI/buttonclick.wav")
								
							for _, child in pairs(self.itemList:GetChildren()) do
								if not child.SortBy then
									child:Remove()
								else
									child.IsSorted = false
								end
							end
								
							btn.IsSorted = true
								
							for var, recipe in pairs(recipes) do
								if LocalPlayer():KnowRecipe(recipe.Name) then
									if recipe.Category == self.SFilter then
										if recipe.SortBy == btn.SortBy then
											local recvgui = vgui.Create("dItemPanelCrafting")
												recvgui:SetSize(self.itemList:GetWide(), 35)
												recvgui.InfoP = self.Infopanel
												recvgui.ID = var
												self.itemList:Add(recvgui)
										end
									end
								end
							end
						end
						
						madespacer = true
						self.itemList:Add(spacer)
					end
				end
			end
		end
	end
	
	if #self.itemList:GetChildren() == 0 then
		local spacer = vgui.Create("DButton")
			spacer:SetSize(self.itemList:GetWide(), 35)
			spacer:SetText("")
			spacer.Paint = function(spc, w, h)
				local bgcol = Color(10, 10, 10, 230)
				local txtcol = Color(200, 200, 255, 255)
									
				draw.SlantedRectHorizOffset(0, 0, w - 20, h - 2, 5, bgcol, Color(0, 0, 0, 255), 2, 2)
				draw.SimpleText("No recipes!", "hidden14", w * 0.5, h * 0.5, txtcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		self.itemList:Add(spacer)
	end
	
	local craftbutton = vgui.Create("DButton", self)
	craftbutton:SetPos(self:GetWide() * 0.5, self:GetTall() - 120)
	craftbutton:SetSize(250, 35)
	craftbutton:SetText("")
	craftbutton.Paint = function(btn, w, h)
	--	draw.RoundedBox(6, 0, 0, w, h, Color(40, 40, 40, 230))
	--	draw.RoundedBox(6, 1, 1, w - 2, h - 2, Color(60, 60, 60, 230))
		draw.SlantedRectHorizOffset(0, 0, w - 4, h - 4, 10, Color(10, 10, 10, 220), Color(0, 0, 0, 255), 2, 2)
			
		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("Craft", "hidden18", w * 0.5, h * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	craftbutton.DoClick = function()
		if recipes[infopanel.ID] then
			self:CheckRecipe(infopanel.ID, infopanel.Amount)
		end
	end
	
	local subbutton = vgui.Create("DButton", self)
	subbutton:SetPos(self:GetWide() * 0.5 + 250, self:GetTall() - 120)
	subbutton:SetSize(40, 35)
	subbutton:SetText("")
	subbutton.Paint = function(btn, w, h)
		draw.SlantedRectHorizOffset(0, 0, w - 4, h - 4, 10, Color(10, 10, 10, 220), Color(0, 0, 0, 255), 2, 2)
			
		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("-", "hidden18", w * 0.5 - 2, h * 0.5 - 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	subbutton.DoClick = function()
		if infopanel.Amount > 1 then
			infopanel.Amount = infopanel.Amount - 1
			
			for _, pnl in pairs(infopanel.itemList:GetChildren()) do
				local base = RECIPEES[infopanel.ID].Requirements
				
				for _, item in pairs(base) do
					if pnl.ID.Name == item[1] then
						pnl.ID.Amount = item[2] * infopanel.Amount
					end
				end
			end
		end
	end
	
	local addbutton = vgui.Create("DButton", self)
	addbutton:SetPos(self:GetWide() * 0.5 + 290, self:GetTall() - 120)
	addbutton:SetSize(40, 35)
	addbutton:SetText("")
	addbutton.Paint = function(btn, w, h)
		draw.SlantedRectHorizOffset(0, 0, w - 4, h - 4, 10, Color(10, 10, 10, 220), Color(0, 0, 0, 255), 2, 2)
			
		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("+", "hidden18", w * 0.5 - 2, h * 0.5 - 2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	addbutton.DoClick = function()
		infopanel.Amount = infopanel.Amount + 1
		
		for _, pnl in pairs(infopanel.itemList:GetChildren()) do
			local base = RECIPEES[infopanel.ID].Requirements
			
			for _, item in pairs(base) do
				if pnl.ID.Name == item[1] then
					pnl.ID.Amount = item[2] * infopanel.Amount
				end
			end
		end
	end
end

function PANEL:CheckRecipe(id, amount)
	local reqa = true
	local reqb = true
	
	local ply = LocalPlayer()
	local rec = RECIPEES[id]
	
	local int = LocalPlayer():GetStat(STAT_INTELLIGENCE)
	local scale = 1
	if int >= 17 then
		scale = 0.8
	elseif int >= 12 then
		scale = 0.9
	elseif int <= 5 then
		scale = 1.3
	elseif int <= 7 then
		scale = 1.1
	end
	
	for k, v in pairs(rec.Requirements) do
		if ply:GetItemCount(v[1]) < (v[2] * amount * scale) then
			reqa = false
			break
		end
	end
--[[	
	if reqa then
		if ply:GetSkill(rec.RequiredSkill[1]) < rec.RequiredSkill[2] then
			reqb = false
		end
	end]]
	
	if reqa and reqb then
		RunConsoleCommand("craftrecipe", id, amount)
	else
	--	if not reqa then
			self:CraftFailure(1)
	--	else
	--		self:CraftFailure(CRAFTINGFAIL_SKILL)
	--	end
	end
end

function PANEL:SetFilter(filter)
	local knownrecipes = LocalPlayer():GetRecipes()
	
	for k,v in pairs(self.itemList:GetChildren()) do
		v:Remove()
	end
		
	for k,v in pairs(recipes) do
		for _,req in pairs(v.RequiredSkills) do
			if req[1] == filter then
				local recvgui = vgui.Create("dItemPanelCrafting")
					recvgui:SetSize(self.itemList:GetWide() * 0.5 - 5, 35)
					recvgui.ID = k
					recvgui.InfoP = self.Infopanel
				self.itemList:Add(recvgui)
				break
			end
		end
	end
end

function PANEL:Paint( w, h )
	if ( self.DoBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	
	surface.SetDrawColor(0,0,0,180)
	
	draw.SlantedRectHorizOffset(5, 25, w - 40, 25, 15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	draw.SlantedRectHorizOffset(5, h - 60, w - 30, 25, -15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	
	--draw.SlantedRectHorizOffset(5, 25, self.OpenX, 25, 15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	--draw.SlantedRectHorizOffset(5, self.OpenY + 30, self.OpenX + 10, 25, -15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	
	if self.SFilter then
		draw.SimpleText(CRAFTING_STRING[self.SFilter], "hidden18", w * 0.5, 38, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:Think()
--[[	if self.OpenX < (ScrW() - 40) then
		if math.Round(self.OpenX + 1) >= (ScrW() - 40) then
			print("greater!")
			self.OpenX = ScrW() - 40
		else
			self.OpenX = Lerp(FrameTime() * 6, self.OpenX, ScrW() - 40)
		end
		print(self.OpenX)
	end
	
	if self.OpenY < (ScrH() - 60) then
		if math.Round(self.OpenY + 1) >= (ScrH() - 60) then
			self.OpenY = ScrH() - 60
		else
			self.OpenY = Lerp(FrameTime() * 6, self.OpenY, ScrH() - 60)
		end
	end
	
	if self.OpenX == (ScrW() - 40) and self.OpenY == (ScrH() - 60) and not self.CompletedOpen then
		self.CompletedOpen = true
		
		self:SetupInventory()
	end]]
end

function PANEL:CraftSuccess(id)
	local knownrecipes = LocalPlayer():GetRecipes()
	
	self.CanClose = false
	local idrecipe = recipes[self.Infopanel.ID]		
		
	local str = ""
	for k,v in pairs(idrecipe.FinishedItems) do
		local resultitem = ITEMS[v[1]]
		str = str..resultitem.Name..(v[2] > 1 and ("["..v[2].."]") or "")..(v[2] > 1 and "," or "")
	end
			
	local frame = vgui.Create("DPanel")
		frame:SetPos(ScrW() * 0.3, ScrH() * 0.45)
		frame:SetSize(ScrW() * 0.4, ScrH() * 0.1)
		frame.Paint = function(frm, w, h)
			draw.RoundedBox(6, 0, 0, w, h, Color(40, 40, 40, 255))
			draw.RoundedBox(6, 2, 2, w - 4, h - 4, Color(30, 30, 30, 255))
			draw.SimpleText("You crafted: ", "hidden14", w * 0.5, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.SimpleText(str, "hidden14", w * 0.5, 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	local btn = vgui.Create("DButton", frame)
		btn:SetText("Close")
		btn:SetSize(frame:GetWide() - 10, 25)
		btn:SetPos(5, frame:GetTall() - 30)
		btn.DoClick = function()
			self.CanClose = true
			frame:Remove()
		end
end

function PANEL:CraftFailure(reason)
	local knownrecipes = LocalPlayer():GetRecipes()
	
	self.CanClose = false
	local idrecipe = recipes[self.Infopanel.ID]		
		
	local str = ""
	print(reason)
	if reason == 1 then
		str = "You do not have enough materials!"
	elseif reason == 2 then
		str = "You fail, but you do not waste any items."
	elseif reason == 3 then
		str = "You fail and waste some items."
	end
			
	local frame = vgui.Create("DPanel")
		frame:SetPos(ScrW() * 0.3, ScrH() * 0.45)
		frame:SetSize(ScrW() * 0.4, ScrH() * 0.1)
		frame.Paint = function(frm, w, h)
			draw.RoundedBox(6, 0, 0, w, h, Color(40, 40, 40, 255))
			draw.RoundedBox(6, 2, 2, w - 4, h - 4, Color(30, 30, 30, 255))
			draw.SimpleText(str, "hidden14", w * 0.5, h * 0.2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	local btn = vgui.Create("DButton", frame)
		btn:SetText("Close")
		btn:SetSize(frame:GetWide() - 10, 25)
		btn:SetPos(5, frame:GetTall() - 30)
		btn.DoClick = function()
			self.CanClose = true
			frame:Remove()
		end
end

function PANEL:OnRemove(bool)
	LocalPlayer().m_CraftingMenu = nil
	RemoveVGUIElement(self)
	self:Remove()
end

vgui.Register( "dCraftingMenu", PANEL, "Panel" )