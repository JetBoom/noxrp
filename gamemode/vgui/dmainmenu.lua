local PANEL = {}

function PANEL:Init()
	self.m_fCreateTime = SysTime()
	
	AddOpenedVGUIElement(self)
	
	local w = ScrW()
	local h = ScrH()
	
	self:SetPos(w * -1, 0)
	self:SetSize(w, h)
	
	self:MoveTo(0, 0, 0.25, 0, 0.5)
	self.Opening = false
	
	local width = self:GetWide() * 0.5 - 20
	
	local ypos = 65
		
	local skillbtn = vgui.Create("dMainMenuButton", self)
		skillbtn:SetSize(width, 35)
		skillbtn:SetPos(15, ypos)
		skillbtn.v_Text = "Skills [WIP]"
		skillbtn:Setup()
		skillbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			if not LocalPlayer().v_SkillMenu then
				LocalPlayer().v_SkillMenu = vgui.Create("dSkillPanel")
				LocalPlayer().v_SkillMenu.FromMainMenu = true
				self.Opening = true
			end
			self:DoRemove()
		end
		skillbtn:SetIcon("icon16/book.png")
		
	ypos = ypos + 45
	
	local recipesbtn = vgui.Create("dMainMenuButton", self)
		recipesbtn:SetSize(width, 35)
		recipesbtn:SetPos(15, ypos)
		recipesbtn.v_Text = "Known Recipes [WIP]"
		recipesbtn:SetIcon("icon16/chart_organisation.png")
		recipesbtn:Setup()
		recipesbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			if not LocalPlayer().v_RecipeMenu then
				LocalPlayer().v_RecipeMenu = vgui.Create("dRecipeMenu")
				LocalPlayer().v_RecipeMenu.FromMainMenu = true
				self.Opening = true
			end
			self:DoRemove()
		end
		
	ypos = ypos + 45

	local optionsbtn = vgui.Create("dMainMenuButton", self)
		optionsbtn:SetSize(width, 35)
		optionsbtn:SetPos(15, ypos)
		optionsbtn.v_Text = "Options [WIP]"
		optionsbtn:SetIcon("icon16/cog.png")
		optionsbtn:Setup()
		optionsbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			if not LocalPlayer().v_OptionsMenu then
				LocalPlayer().v_OptionsMenu = vgui.Create("dOptionsMenu")
				LocalPlayer().v_OptionsMenu.FromMainMenu = true
				self.Opening = true
			end
			self:DoRemove()
		end

	ypos = ypos + 45
	
	
	local helpbtn = vgui.Create("dMainMenuButton", self)
		helpbtn:SetSize(width, 35)
		helpbtn:SetPos(15, ypos)
		helpbtn.v_Text = "Help [WIP]"
		helpbtn:SetIcon("icon16/folder_link.png")
		helpbtn:Setup()
		helpbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			if not LocalPlayer().v_HelpMenu then
				LocalPlayer().v_HelpMenu = vgui.Create("dHelpMenu")
				LocalPlayer().v_HelpMenu.FromMainMenu = true
				self.Opening = true
			end
			self:DoRemove()
		end
		
	ypos = ypos + 45
		
	local updatesbtn = vgui.Create("dMainMenuButton", self)
		updatesbtn:SetSize(width, 35)
		updatesbtn:SetPos(15, ypos)
		updatesbtn.v_Text = "Updates [WIP]"
		updatesbtn:SetIcon("icon16/database_refresh.png")
		updatesbtn:Setup()
		updatesbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			if not LocalPlayer().v_UpdateList then
				LocalPlayer().v_UpdateList = vgui.Create("dUpdateList")
				self.Opening = true
			end
			self:DoRemove()
		end
		
	ypos = ypos + 45
	
	local closebtn = vgui.Create("dMainMenuButton", self)
		closebtn:SetSize(self:GetWide() * 0.5 - 20, 35)
		closebtn:SetPos(15, ypos)
		closebtn.v_Text = "Close"
		closebtn:Setup()
		closebtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			self:DoRemove()
		end
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Paint( w, h )
	Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	
	surface.SetTexture(gradient)
	surface.SetDrawColor(20, 20, 20, 200)
	
	surface.DrawTexturedRect(0, 0, w * 0.4, h)
	
	surface.SetDrawColor(0, 0, 0, 250)
	surface.DrawTexturedRect(0, 10, 240, 30)
	draw.SimpleText("Main Menu", "hidden18", 15, 25, Color(180, 180, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:DoRemove()
	RemoveVGUIElement(self)
	
	LocalPlayer().v_MainMenu = nil
	self:Remove()
end


vgui.Register( "dMainMenu", PANEL, "EditablePanel" )