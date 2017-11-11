local PANEL = {}

function PANEL:Init()
	self.m_fCreateTime = SysTime()
	local w = ScrW()
	local h = ScrH()
	
	AddOpenedVGUIElement(self)
	
	self:SetPos(w * -1, 0)
	self:SetSize(w, h)
	self:MoveTo(0, 0, 0.25, 0, 0.5)	
	
	self:Setup()
end

function PANEL:Paint( w, h )
	Derma_DrawBackgroundBlur( self, 0 )
	
	draw.SimpleText("Known Recipes", "hidden18", w * 0.5, 35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Setup()
	local backbtn = vgui.Create("dMainMenuButton", self)
		backbtn:SetSize(120, 25)
		backbtn:SetPos(5, 5)
		backbtn.v_Text = "Back"
		backbtn:SetIcon("icon16/arrow_left.png")
		backbtn:Setup()
		backbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			self:DoRemove()
		end
	
	local scroll = vgui.Create("DScrollPanel", self)
		scroll:SetPos(5, 55)
		scroll:SetSize(self:GetWide() * 0.4, self:GetTall() - 70)
		
	self.RecipeList = vgui.Create( "DIconLayout", scroll)
		self.RecipeList:SetSize(scroll:GetWide() - 10, scroll:GetTall() - 60)
		self.RecipeList:SetPos(10, 10)
		self.RecipeList:SetSpaceY(10)
		self.RecipeList:SetSpaceX(5)
	
	local krecipes = LocalPlayer():GetRecipes()
	for sortindex, sortby in pairs(RECIPEES_SORTBY) do
		local madesort = false
		for _, recipe in pairs(krecipes) do
			local grecipe = RECIPEES[recipe]
			
			if grecipe.SortBy == sortindex then
				if not madesort then
					local panel = vgui.Create("DButton")
						panel:SetSize(400, 30)
						panel:SetText("")
						
						panel.GAlpha = 180
						panel.TCol = Color(180, 255, 180)
						
						panel.Paint = function(pnl, pw, ph)
							surface.SetTexture(gradient)
							surface.SetDrawColor(0, 0, 0, 200)
							
							surface.DrawTexturedRect(0, 0, pw, ph)
											
						--	surface.DrawTexturedRect(0, 0, 200, 30)
							
							draw.SimpleText(sortby, "hidden18", pw * 0.5, 5, Color(pnl.TCol.r, pnl.TCol.g, pnl.TCol.b, 255), TEXT_ALIGN_CENTER)
						end
					self.RecipeList:Add(panel)
					
					madesort = true
				end
				
				local panel = vgui.Create("DButton")
					panel:SetSize(self.RecipeList:GetWide() - 5, 30)
					panel:SetText("")
					
					panel.GAlpha = 180
					panel.TCol = Color(255, 255, 255)
					panel.Think = function(pnl)
						if pnl.Hovered then
							if pnl.GAlpha < 240 then
								pnl.GAlpha = math.min(pnl.GAlpha + 6, 240)
							end
							
							if pnl.TCol.r > 180 then
								pnl.TCol.r = math.min(pnl.TCol.r - 6, 180)
								pnl.TCol.g = math.min(pnl.TCol.g - 6, 180)
							end
						else
							if pnl.GAlpha > 180 then
								pnl.GAlpha = math.max(pnl.GAlpha - 6, 180)
							end
							
							if pnl.TCol.r < 255 then
								pnl.TCol.r = math.min(pnl.TCol.r + 6, 255)
								pnl.TCol.g = math.min(pnl.TCol.g + 6, 255)
							end
						end
					end
					
					panel.Paint = function(pnl, pw, ph)
						surface.SetTexture(gradient)
						surface.SetDrawColor(0, 0, 0, pnl.GAlpha)
						
						surface.DrawTexturedRect(0, 0, 200, 30)
						
						draw.SimpleText(grecipe.Display, "hidden18", 5, 5, Color(pnl.TCol.r, pnl.TCol.g, pnl.TCol.b, 255), TEXT_ALIGN_LEFT)
					end
					
					panel.DoClick = function(pnl)
						--TODO
						surface.PlaySound("buttons/button9.wav")
					end
				
				self.RecipeList:Add(panel)
			end
		end
	end
end

function PANEL:DoRemove()
	LocalPlayer().v_RecipeMenu = nil
	
	RemoveVGUIElement(self)
	
	if self.FromMainMenu then
		LocalPlayer().v_MainMenu = vgui.Create("dMainMenu")
	end
	self:Remove()
end

function PANEL:DoClick()
end

vgui.Register( "dRecipeMenu", PANEL, "EditablePanel" )