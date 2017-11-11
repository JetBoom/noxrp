local PANEL = {}

function PANEL:Init()
--	gui.EnableScreenClicker(true)
	self.m_fCreateTime = SysTime()
	local w = ScrW()
	local h = ScrH()
	
	self:SetPos(w * -1, 0)
	self:SetSize(w, h)
	self:MoveTo(0, 0, 0.25, 0, 0.5)	
	
	AddOpenedVGUIElement(self)
	
	self:Setup()
end

function PANEL:Paint( w, h )
	Derma_DrawBackgroundBlur( self, 0 )
	
	draw.SimpleText("Skill List", "hidden18", w * 0.5, 35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Setup()
	local skills = LocalPlayer():GetSkills()

	self.ChosenSkill = -1
	self.ChosenEffect = ""
	
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
		scroll:SetSize(self:GetWide() - 5, self:GetTall() * 0.3 - 10)
		
	self.SkillList = vgui.Create( "DIconLayout", scroll)
		self.SkillList:SetSize(scroll:GetWide() - 10, scroll:GetTall() - 60)
		self.SkillList:SetPos(10, 10)
		self.SkillList:SetSpaceY(10)
		self.SkillList:SetSpaceX(5)
	
	for skill, skillamt in pairs(skills) do
		print(skill, skillamt)
		local scale = skillamt / SKILL_MAX_SINGLE
		
		local panel = vgui.Create("DButton")
			panel:SetSize(300, 75)
			panel:SetText("")
			panel.Skill = skill
			
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
				
				draw.NoTexture()
				surface.DrawRect(20, 35, 300, 15)
				
				surface.SetDrawColor(50, 255, 50, 180)
				surface.DrawRect(21, 36, 298 * scale, 13)
				
				draw.SimpleText(SKILLS[skill].Name..":  "..skillamt.."/"..SKILL_MAX_SINGLE, "hidden18", 5, 5, Color(pnl.TCol.r, pnl.TCol.g, pnl.TCol.b, 255), TEXT_ALIGN_LEFT)
			end
			
			panel.DoClick = function(pnl)
				--TODO
				surface.PlaySound("buttons/button9.wav")
				
				self.ChosenSkill = pnl.Skill
				self.ChosenEffect = ""
				self:UpdateSkillNotes(pnl.Skill)
			end
		
		self.SkillList:Add(panel)
	end
	
	local effectpanel = vgui.Create("DPanel", self)
		effectpanel:SetPos(5, self:GetTall() * 0.3 + 45)
		effectpanel:SetSize(self:GetWide() - 10, self:GetTall() * 0.6 + 55)
		effectpanel.Paint = function(pnl, pw, ph)
			if self.ChosenSkill != -1 then
				for i = 0, 1000, 100 do
					draw.SimpleText(i, "hidden14", 50 + (ScrW() - 100) * (i / SKILL_MAX_SINGLE), 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				end
				
				if self.ChosenEffect != "" then
					local tab = SkillNotes[self.ChosenSkill][self.ChosenEffect]
					
					if tab.Icon then
						surface.SetMaterial(tab.Icon)
						surface.SetDrawColor(255, 255, 255, 255)
						surface.DrawTexturedRect(pw * 0.5 - 16, pnl:GetTall() * 0.5 + 5, 32, 32)
					end
					
					draw.SimpleText(tab.Title, "hidden16", pw * 0.5, pnl:GetTall() * 0.5 + 40, Color(180, 180, 255, 255),  TEXT_ALIGN_CENTER)
					draw.SimpleText(tab.Description, "hidden14", pw * 0.5, pnl:GetTall() * 0.5 + 60, Color(255, 255, 255, 255),  TEXT_ALIGN_CENTER)
					local col = Color(255, 200, 200, 255)
					local lvl = LocalPlayer():GetSkill(self.ChosenSkill)
					if lvl >= tab.SkillLevel then
						col = Color(200, 255, 200, 255)
					end
					draw.SimpleText("Required Level: "..tab.SkillLevel.. " [Current: "..lvl.."]", "hidden14", pw * 0.5, pnl:GetTall() * 0.5 + 80, col,  TEXT_ALIGN_CENTER)
				end
			end
		end
	self.NotesList = effectpanel
end

function PANEL:UpdateSkillNotes(skill)
	if #self.NotesList:GetChildren() > 0 then
		for _, v in pairs(self.NotesList:GetChildren()) do
			v:Remove()
		end
	end
	
	//0 would be 50
	//1000 would be ScrW() - 50
	if SkillNotes[skill] then
		for ref, tab in pairs(SkillNotes[skill]) do
			local panel = vgui.Create("DButton", self.NotesList)
				panel:SetSize(160, 50)
				panel:SetText("")
				panel:SetPos(50 + (ScrW() - 100) * (tab.SkillLevel / SKILL_MAX_SINGLE) - panel:GetWide() * 0.5, 50)
				
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
			--	surface.SetTexture(gradient)
				
			--	surface.DrawTexturedRect(0, 0, pw, ph)
				draw.RoundedBox(6, 0, 0, pw, ph, Color(0, 0, 0, 40))
				
				if tab.Icon then
					surface.SetDrawColor(255, 255, 255, pnl.GAlpha)
					surface.SetMaterial(tab.Icon)
					surface.DrawTexturedRect(pw * 0.5 - 16, ph - 34, 32, 32)
				else
					surface.SetDrawColor(0, 0, 0, pnl.GAlpha)
					surface.DrawRect(pw * 0.5 - 16, ph - 34, 32, 32)
				end
				
				draw.SimpleText(tab.Title, "hidden12", pw * 0.5, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			panel.DoClick = function(pn)
				self.ChosenEffect = ref
			end
			
			self.NotesList:Add(panel)
		end
	end
end

function PANEL:DoRemove()
	LocalPlayer().v_SkillMenu = nil
	
	RemoveVGUIElement(self)
	
	if self.FromMainMenu then
		LocalPlayer().v_MainMenu = vgui.Create("dMainMenu")
	elseif not self.Opening then
--		gui.EnableScreenClicker(false)
	end
	self:Remove()
end

function PANEL:DoClick()
end

vgui.Register( "dSkillPanel", PANEL, "EditablePanel" )