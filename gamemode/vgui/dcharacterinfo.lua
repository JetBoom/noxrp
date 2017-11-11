local PANEL = {}

function PANEL:Init()
	self.m_fCreateTime = SysTime()
	local w = ScrW()
	local h = ScrH()
	
	self:SetPos(w * -1, 0)
	self:SetSize(w, h)
	self:MoveTo(0, 0, 0.25, 0, 0.5)	
	
	self:Setup()
	
	surface.SetFont("hidden18")
	local lenw, lenh = surface.GetTextSize("Character Info")
	
	AddOpenedVGUIElement(self)
	
	self.TextLenW = lenw
	self.TextLenH = lenh

	self.StatusReductions = {}
	self:UpdatePlayerReductions()
end

function PANEL:UpdatePlayerReductions()
	local ply = LocalPlayer()
	
	local red = ply:GetDamageReduction(DMG_BULLET)
	if red > 0 then
		self.StatusReductions[DMG_BULLET] = {Color(150, 255, 150), "Bullet Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_BULLET] = {Color(255, 150, 150), "Bullet Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_BULLET] = {Color(255, 255, 255), "Bullet Damage: 0%"}
	end
	
	red = ply:GetDamageReduction(DMG_BURN)
	if red > 0 then
		self.StatusReductions[DMG_BURN] = {Color(150, 255, 150), "Burning Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_BURN] = {Color(255, 150, 150), "Burning Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_BURN] = {Color(255, 255, 255), "Burning Reduction: 0%"}
	end
	
	red = ply:GetDamageReduction(DMG_SLASH)
	if red > 0 then
		self.StatusReductions[DMG_SLASH] = {Color(150, 255, 150), "Cutting Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_SLASH] = {Color(255, 150, 150), "Cutting Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_SLASH] = {Color(255, 255, 255), "Cutting Reduction: 0%"}
	end

	red = ply:GetDamageReduction(DMG_CLUB)
	if red > 0 then
		self.StatusReductions[DMG_CLUB] = {Color(150, 255, 150), "Bashing Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_CLUB] = {Color(255, 150, 150), "Bashing Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_CLUB] = {Color(255, 255, 255), "Bashing Reduction: 0%"}
	end
	
	red = ply:GetDamageReduction(REDUCTION_SPEED)
	if red > 0 then
		self.StatusReductions[REDUCTION_SPEED] = {Color(255, 150, 150), "Speed Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[REDUCTION_SPEED] = {Color(150, 255, 150), "Speed Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[REDUCTION_SPEED] = {Color(255, 255, 255), "Speed Reduction: 0%"}
	end
end

local burn = Material("noxrp/statusicons/status_onfire.png")
local bullet = Material("noxrp/statusicons/status_bulletimpact.png")
local cutting = Material("noxrp/statusicons/status_bleed.png")
local blunt = Material("noxrp/statusicons/status_bluntimpact.png")
local speed = Material("noxrp/statusicons/status_speed.png")
function PANEL:Paint( w, h )
	Derma_DrawBackgroundBlur( self, 0 )
	
	local ply = LocalPlayer()
	
	draw.SlantedRectHoriz(w * 0.5 - self.TextLenW * 0.5 - 20, 35 - self.TextLenH * 0.5 - 5, self.TextLenW + 40, self.TextLenH + 10, 5, Color(20, 20, 20, 180), Color(0, 0, 0, 255))
	draw.SimpleText("Character Info", "hidden18", w * 0.5, 35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	surface.SetDrawColor(20, 20, 20, 150)
	surface.DrawRect(5, h * 0.65, 400, 25)
	surface.DrawRect(5, h * 0.65 + 30, 400, 25)
	
	surface.DrawRect(5, h * 0.7 + 10, 400, h * 0.3 - 15)
			
	draw.SimpleText("Max Health: "..ply:GetMaxHealth(), "Xolonium16", 205, h * 0.65 + 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Max Inventory: "..ply:GetMaxWeight(), "Xolonium16", 205, h * 0.65 + 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	draw.SimpleText("Status Effects", "Xolonium16", 205, h * 0.7 + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(bullet)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(5, h * 0.7 + 40, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_BULLET][2], "Xolonium16", 40, h * 0.7 + 50, self.StatusReductions[DMG_BULLET][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(burn)
	surface.DrawTexturedRect(5, h * 0.7 + 80, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_BURN][2], "Xolonium16", 40, h * 0.7 + 90, self.StatusReductions[DMG_BURN][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(cutting)
	surface.DrawTexturedRect(5, h * 0.7 + 120, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_SLASH][2], "Xolonium16", 40, h * 0.7 + 130, self.StatusReductions[DMG_SLASH][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetMaterial(blunt)
	surface.DrawTexturedRect(5, h * 0.7 + 160, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_CLUB][2], "Xolonium16", 40, h * 0.7 + 170, self.StatusReductions[DMG_CLUB][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(speed)
	surface.DrawTexturedRect(5, h * 0.7 + 200, 30, 30)
	draw.SimpleText(self.StatusReductions[REDUCTION_SPEED][2], "Xolonium16", 40, h * 0.7 + 210, self.StatusReductions[REDUCTION_SPEED][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	draw.NoTexture()
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Setup()
	local ply = LocalPlayer()
	local skills = ply:GetSkills()
	local w = ScrW()
	local h = ScrH()
	
	local baseline = 7
	local dist = 150
	local scale = dist / STATS_MAXPERSTAT
	
	local stats = LocalPlayer():GetStats()
	
	local center = {x = w * 0.5, y = h * 0.35}
--[[	
	local basepoints = {
		[1] = {x = center.x + 50 * math.cos(math.rad(45)), y = center.y - 50 * math.sin(math.rad(45))},
		[2] = {x = center.x + 50 * math.cos(math.rad(135)), y = center.y - 50 * math.sin(math.rad(135))},
		[3] = {x = center.x + 50 * math.cos(math.rad(225)), y = center.y - 50 * math.sin(math.rad(225))},
		[4] = {x = center.x + 50 * math.cos(math.rad(315)), y = center.y - 50 * math.sin(math.rad(315))},
	}
					
	local maxpoints = {
		[1] = {x = center.x + (50 + dist) * math.cos(math.rad(45)), y = center.y - (50 + dist) * math.sin(math.rad(45))},
		[2] = {x = center.x + (50 + dist) * math.cos(math.rad(135)), y = center.y - (50 + dist) * math.sin(math.rad(135))},
		[3] = {x = center.x + (50 + dist) * math.cos(math.rad(225)), y = center.y - (50 + dist) * math.sin(math.rad(225))},
		[4] = {x = center.x + (50 + dist) * math.cos(math.rad(315)), y = center.y - (50 + dist) * math.sin(math.rad(315))},
	}]]
	
	local basepoints = {
		[1] = {x = center.x, y = center.y - 50},
		[2] = {x = center.x + 50, y = center.y},
		[3] = {x = center.x, y = center.y + 50},
		[4] = {x = center.x - 50, y = center.y},
	}
	
	local midpoints = {
		[1] = {x = center.x, y = center.y - (50 + dist * 0.5)},
		[2] = {x = center.x + (50 + dist * 0.5), y = center.y},
		[3] = {x = center.x, y = center.y + (50 + dist * 0.5)},
		[4] = {x = center.x - (50 + dist * 0.5), y = center.y},
	}
	
	local maxpoints = {
		[1] = {x = center.x, y = center.y - (50 + dist)},
		[2] = {x = center.x + (50 + dist), y = center.y},
		[3] = {x = center.x, y = center.y + 50 + dist},
		[4] = {x = center.x - (50 + dist), y = center.y},
	}
	
	local mainpanel = vgui.Create("DPanel", self)
		mainpanel:SetPos(0, 0)
		mainpanel:SetSize(w, h)
		mainpanel.Paint = function(pnl, pw, ph)
			
			surface.SetDrawColor(50, 255, 50, 100)
			surface.DrawRect(center.x - 10, center.y - 10, 20, 20)
			
			local points = {
				[1] = {x = center.x, y = center.y - (50 + scale * stats[STAT_STRENGTH].Base)},
				[2] = {x = center.x + (50 + scale * stats[STAT_AGILITY].Base), y = center.y},
				[3] = {x = center.x, y = center.y + (50 + scale * stats[STAT_INTELLIGENCE].Base)},
				[4] = {x = center.x - (50 + scale * stats[STAT_ENDURANCE].Base), y = center.y},
			}
			
			surface.SetDrawColor(20, 20, 20, 180)
			surface.DrawPoly(maxpoints)
				
			surface.SetDrawColor(255, 50, 50, 100)
			
			for k, point in pairs(basepoints) do
				local t = k + 1
				if k == #basepoints then
					t = 1
				end
				surface.DrawLine(point.x, point.y, basepoints[t].x, basepoints[t].y)
			end
			
			for k, point in pairs(basepoints) do
				local t = k + 1
				if k == #basepoints then
					t = 1
				end
				surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
			end
			
			surface.SetDrawColor(50, 150, 255, 100)
			for k, point in pairs(midpoints) do
				local t = k + 1
				if k == #midpoints then
					t = 1
				end
				surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
			end
			
			for k, point in pairs(maxpoints) do
				local t = k + 1
				if k == #maxpoints then
					t = 1
				end
				surface.SetDrawColor(255, 255, 255, 100)
				surface.DrawLine(basepoints[k].x, basepoints[k].y, point.x, point.y)
				
				surface.SetDrawColor(50, 255, 50, 100)
				surface.DrawLine(point.x, point.y, maxpoints[t].x, maxpoints[t].y)
			end
			
			for k, point in pairs(maxpoints) do
				local t = k + 1
				if k == #maxpoints then
					t = 1
				end
				surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
			end
			
			surface.SetDrawColor(255, 255, 255, 100)
			
			for k, point in pairs(points) do
				local t = k + 1
				if k == #points then
					t = 1
				end
				surface.DrawLine(point.x, point.y, points[t].x, points[t].y)
			end
			
			for k, point in pairs(points) do
				local t = k + 1

				surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
			end

		--	draw.SimpleText(STATS[STAT_INTELLIGENCE].Name, "hidden18", maxpoints[1].x, maxpoints[1].y - 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--	draw.SimpleText(STATS[STAT_STRENGTH].Name, "hidden18", maxpoints[2].x + 15, maxpoints[2].y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		--	draw.SimpleText(STATS[STAT_AGILITY].Name, "hidden18", maxpoints[3].x, maxpoints[3].y + 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--	draw.SimpleText(STATS[STAT_ENDURANCE].Name, "hidden18", maxpoints[4].x - 15, maxpoints[4].y, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
		
	local barpos = {x = 25, y = 550}
	
	local panel1 = vgui.Create("DPanel", mainpanel)
		panel1:SetSize(280, 25)
		panel1:SetPos(maxpoints[1].x - 140, maxpoints[1].y - 35)
		panel1.StatID = 1
		panel1:SetToolTip(STATS[STAT_STRENGTH].Description)
		
		panel1.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 150)
			surface.DrawRect(0, 0, pw, ph)
			
			draw.SimpleText(STATS[STAT_STRENGTH].Name..": "..stats[STAT_STRENGTH].Base, "hidden14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	local panel2 = vgui.Create("DPanel", mainpanel)
		panel2:SetSize(280, 25)
		panel2:SetPos(maxpoints[2].x + 15, maxpoints[2].y - 13)
		panel2.StatID = 2
		panel2:SetToolTip(STATS[STAT_AGILITY].Description)
		
		panel2.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 150)
			surface.DrawRect(0, 0, pw, ph)
			
			draw.SimpleText(STATS[STAT_AGILITY].Name..": "..stats[STAT_AGILITY].Base, "hidden14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	local panel3 = vgui.Create("DPanel", mainpanel)
		panel3:SetSize(280, 25)
		panel3:SetPos(maxpoints[3].x - 140, maxpoints[3].y + 35)
		panel3.StatID = 3
		panel3:SetToolTip(STATS[STAT_INTELLIGENCE].Description)
		
		panel3.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 150)
			surface.DrawRect(0, 0, pw, ph)
			
			draw.SimpleText(STATS[STAT_INTELLIGENCE].Name..": "..stats[STAT_INTELLIGENCE].Base, "hidden14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	local panel4 = vgui.Create("DPanel", mainpanel)
		panel4:SetSize(280, 25)
		panel4:SetPos(maxpoints[4].x - 315, maxpoints[4].y - 13)
		panel4.StatID = 4
		panel4:SetToolTip(STATS[STAT_ENDURANCE].Description)
		
		panel4.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 150)
			surface.DrawRect(0, 0, pw, ph)
			
			draw.SimpleText(STATS[STAT_ENDURANCE].Name..": "..stats[STAT_ENDURANCE].Base, "hidden14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
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
end

function PANEL:DoRemove()
	LocalPlayer().v_CharacterInfo = nil
	
	RemoveVGUIElement(self)
	
	if self.FromMainMenu then
		LocalPlayer().v_MainMenu = vgui.Create("dMainMenu")
	elseif not self.Opening then
--		gui.EnableScreenClicker(false)
	end
	self:Remove()
	
	RemoveVGUIElement(self)
end

function PANEL:DoClick()
end

vgui.Register( "dCharacterInfo", PANEL, "EditablePanel" )