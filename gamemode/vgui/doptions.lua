local PANEL = {}

CreateClientConVar("noxrp_crosshair_r", 0, true, true)
CreateClientConVar("noxrp_crosshair_g", 120, true, true)
CreateClientConVar("noxrp_crosshair_b", 255, true, true)
CreateClientConVar("noxrp_worldsubtitles", 2, true, true)
CreateClientConVar("noxrp_ragdoll_deathtime", 5, true, true)
CreateClientConVar("noxrp_drawweather", 1, true, true)
CreateClientConVar("noxrp_drawhud", 1, true, true)
CreateClientConVar("noxrp_enablehints", 1, true, true)
CreateClientConVar("noxrp_effectlevel", 0, true, true)
CreateClientConVar("noxrp_enablebloom", 1, true, true)
CreateClientConVar("noxrp_enabledlight", 1, true, true)
CreateClientConVar("noxrp_enablecolor", 1, true, true)
CreateClientConVar("noxrp_radius3dtext", 512, true, true)
CreateClientConVar("noxrp_stickyironsights", 0, true, true)
CreateClientConVar("noxrp_toggleradio", 0, true, false)
CreateClientConVar("noxrp_radiovolume", 100, true, false)

CreateClientConVar("noxrp_dropprotection", 1, true, true)

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
end

local gradient = surface.GetTextureID("gui/gradient")
local dot = surface.GetTextureID("sprites/dot")
function PANEL:Setup()
	local backbtn = vgui.Create("dMainMenuButton", self)
		backbtn:SetSize(120, 25)
		backbtn:SetPos(5, 5)
		if self.FromMainMenu then
			backbtn.v_Text = "Back"
		else
			backbtn.v_Text = "Exit"
		end
		backbtn:SetIcon("icon16/arrow_left.png")
		backbtn:Setup()
		backbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			self:DoRemove()
		end
		
		
	--MAIN PANEL LIST
	local scroll = vgui.Create("DScrollPanel", self)
		scroll:SetPos(5, 45)
		scroll:SetSize(self:GetWide() * 0.4, self:GetTall() - 70)
		
	local mainitemList = vgui.Create( "DIconLayout", scroll)
		mainitemList:SetSize(scroll:GetWide() - 25, scroll:GetTall() - 20)
		mainitemList:SetSpaceY(5)
		mainitemList:SetSpaceX(5)
		
		
		
		
	--=================GAMEPLAY OPTIONS===================================
	local gameplayheader = vgui.Create("DPanel")
		gameplayheader:SetSize(mainitemList:GetWide() - 10,30)
		gameplayheader:SetPos(5,40)
		gameplayheader.Paint = function(pnl, pw, ph)
			--draw.RoundedBox(4, 0, 0, pw, ph, Color(20, 20, 20, 150))
			--draw.RoundedBox(4, 1, 1, pw - 2, ph - 2, Color(40, 40, 40, 210))
			surface.SetTexture(gradient)
			surface.SetDrawColor(50, 50, 100, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			
			draw.SimpleText("Gameplay Options", "hidden14", pw * 0.5, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	mainitemList:Add(gameplayheader)
	
	--World Subtitles
	local worldsubtitles = vgui.Create("DPanel")
		worldsubtitles:SetSize(mainitemList:GetWide() - 10,30)
		worldsubtitles:SetPos(5,40)
		worldsubtitles.Paint = function(pnl, pw, ph)
		--	draw.RoundedBox(8,0,0, pw, ph, Color(20, 20, 20, 150))
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("World Subtitles", "hidden14", 210, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
	local subtitlevar = GetConVarNumber("noxrp_worldsubtitles")
	local subtitle_optionbox = vgui.Create("DComboBox", worldsubtitles)
		subtitle_optionbox:SetPos(5,5)
		subtitle_optionbox:SetSize(200, 20)
		subtitle_optionbox:AddChoice("None")
		subtitle_optionbox:AddChoice("Only Voice")
		subtitle_optionbox:AddChoice("Voice and Environment")
		subtitle_optionbox:ChooseOptionID(math.Clamp(subtitlevar + 1, 1, 3))
		subtitle_optionbox.OnSelect = function( panel, index, value, data )
			if index == 1 then
				RunConsoleCommand("noxrp_worldsubtitles", 0)
			elseif index == 2 then
				RunConsoleCommand("noxrp_worldsubtitles", 1)
			else
				RunConsoleCommand("noxrp_worldsubtitles", 2)
			end
		end
	
	mainitemList:Add(worldsubtitles)
	
	--Gameplay Hints
	local hintspnl = vgui.Create("DPanel")
		hintspnl:SetSize(mainitemList:GetWide() - 10,30)
		hintspnl:SetPos(5,40)
		hintspnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enable/Disable Game hints", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
	local hintbox = vgui.Create("DCheckBoxLabel", hintspnl)
		hintbox:SetPos(5, 8)
		hintbox:SetText("")
		hintbox:SetConVar("noxrp_enablehints")
		hintbox:SetValue(1)
		hintbox:SizeToContents()
	
	mainitemList:Add(hintspnl)
	
	local ironsightpnl = vgui.Create("DPanel")
		ironsightpnl:SetSize(mainitemList:GetWide() - 10,30)
		ironsightpnl:SetPos(5,40)
		ironsightpnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enable/Disable Sticky Ironsights", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
	local ironsightbox = vgui.Create("DCheckBoxLabel", ironsightpnl)
		ironsightbox:SetPos(5, 8)
		ironsightbox:SetText("")
		ironsightbox:SetConVar("noxrp_stickyironsights")
		ironsightbox:SetToolTip("Enable/Disable sticky ironsights.\nDisabled requires holding the alternate fire to hold ironsights.\nEnabled makes ironsights a toggle.")
		ironsightbox:SetValue(GetConVarNumber("noxrp_stickyironsights"))
		ironsightbox:SizeToContents()
	
	mainitemList:Add(ironsightpnl)	

	
	local deathpnl = vgui.Create("DPanel")
		deathpnl:SetSize(mainitemList:GetWide() - 10,30)
		deathpnl:SetPos(5,40)
		deathpnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Ragdoll Death Time", "hidden14", 5, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
	local timeslider = vgui.Create("DNumSlider", deathpnl)
		timeslider:SetPos(5, 0)
		timeslider:SetSize(deathpnl:GetWide() - 10, 30)
		timeslider:SetMin(0)
		timeslider:SetMax(60)
		timeslider:SetDecimals(0)
		timeslider:SetValue(GetConVarNumber("noxrp_ragdoll_deathtime"))
		timeslider:SetToolTip("Set the deathtime for ragdolls.\n0 for no ragdolls.")
		timeslider:SetConVar("noxrp_ragdoll_deathtime")
		timeslider.TextArea:SetTextColor(Color(255, 255, 255, 255))
	
	mainitemList:Add(deathpnl)
	
	
	
	
	--======================GRAPHIC OPTIONS===================
	local graphheader = vgui.Create("DPanel")
		graphheader:SetSize(mainitemList:GetWide() - 10,30)
		graphheader:SetPos(5,40)
		graphheader.Paint = function(pnl, pw, ph)
			--draw.RoundedBox(4, 0, 0, pw, ph,Color(20, 20, 20, 150))
			--draw.RoundedBox(4, 1, 1, pw - 2, ph - 2, Color(40, 40, 40, 210))
			
			surface.SetTexture(gradient)
			surface.SetDrawColor(50, 50, 100, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Graphics Options", "hidden14", pw * 0.5, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	mainitemList:Add(graphheader)
	
	local effectpanel = vgui.Create("DPanel")
	effectpanel:SetSize(mainitemList:GetWide() - 10,30)
	effectpanel.Paint = function(self, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
		draw.SimpleText("Particle Effect Level","hidden14",110,15,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	mainitemList:Add(effectpanel)
	
	local GRAPHICS_EFFECTS = GetConVarNumber("noxrp_effectlevel")
	
	local effect_optionbox = vgui.Create("DComboBox", effectpanel)
	effect_optionbox:SetPos(5,5)
	effect_optionbox:SetSize(100,20)
	effect_optionbox:AddChoice("Low")
	effect_optionbox:AddChoice("Medium")
	effect_optionbox:AddChoice("High")
	effect_optionbox:AddChoice("Very High")
	if GRAPHICS_EFFECTS == 0 then
		effect_optionbox:SetValue("Low")
	elseif GRAPHICS_EFFECTS == 1 then
		effect_optionbox:SetValue("Medium")
	elseif GRAPHICS_EFFECTS == 2 then
		effect_optionbox:SetValue("High")
	elseif GRAPHICS_EFFECTS == 3 then
		effect_optionbox:SetValue("Very High")
	end
	effect_optionbox.OnSelect = function( panel, index, value, data )
		if index == 1 then
			RunConsoleCommand("noxrp_effectlevel", 0)
		elseif index == 2 then
			RunConsoleCommand("noxrp_effectlevel", 1)
		elseif index == 3 then
			RunConsoleCommand("noxrp_effectlevel", 2)
		else
			RunConsoleCommand("noxrp_effectlevel", 3)
		end
	end
	
	local colpnl = vgui.Create("DPanel")
	colpnl:SetSize(mainitemList:GetWide() - 10, 240)
	colpnl.Paint = function(pnl, pw, ph)
		surface.SetTexture(gradient)
		surface.SetDrawColor(0, 0, 0, 200)
			
		surface.DrawTexturedRect(0, 0, pw, ph)
		draw.SimpleText("Crosshair Color", "hidden16", pw * 0.5, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		local x = pw * 0.75
		local y = ph * 0.3
		local length = 16
		
		local cr = GetConVar("noxrp_crosshair_r"):GetInt()
		local cg = GetConVar("noxrp_crosshair_g"):GetInt()
		local cb = GetConVar("noxrp_crosshair_b"):GetInt()
		
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect( x - 1, y - 1, 3, 3)
		
		surface.DrawRect( x - length - 8, y - 1, length, 3)
		surface.DrawRect( x + 8, y - 1, length, 3)
		
		surface.DrawRect( x - 1, y - length - 8, 3, length)
		surface.DrawRect( x - 1, y + 8, 3, length)
		
		surface.SetDrawColor(cr, cg, cb)
		
		surface.DrawRect( x, y, 1, 1)

		surface.DrawRect( x - length - 7, y, length - 2, 1)
		surface.DrawRect( x + 9, y, length - 2, 1)
		
		surface.DrawRect( x, y - length - 7, 1, length - 2)
		surface.DrawRect( x, y + 9, 1, length - 2)
		
		surface.SetTexture(dot)
		surface.DrawTexturedRect(x - 8, ph * 0.6, 16, 16)
	end
	
	local colorbox_col = vgui.Create("DColorCube", colpnl)
	colorbox_col:SetSize(180,200)
	colorbox_col:SetPos(45, 30)
	colorbox_col.OnUserChanged = function()
		local color = colorbox_col:GetRGB()
		RunConsoleCommand("noxrp_crosshair_r", color.r)
		RunConsoleCommand("noxrp_crosshair_g", color.g)
		RunConsoleCommand("noxrp_crosshair_b", color.b)
	end
	
	local colorbox = vgui.Create("DRGBPicker", colpnl)
	colorbox:SetSize(25, 200)
	colorbox:SetPos(15, 30)
	colorbox.OnChange = function()
		colorbox_col:SetColor(colorbox:GetRGB())
	end
	
	mainitemList:Add(colpnl)
	
	local text3drad = vgui.Create("DPanel")
	text3drad:SetSize(mainitemList:GetWide() - 10, 30)
	text3drad:SetToolTip("Set the radius for visible 3D texts. Default is 512.")
	text3drad.Paint = function(pnl, pw, ph)
		surface.SetTexture(gradient)
		surface.SetDrawColor(0, 0, 0, 200)
			
		surface.DrawTexturedRect(0, 0, pw, ph)
		draw.SimpleText("3D Text Radius", "hidden14", 5, ph * 0.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
		
	local slider = vgui.Create("DNumSlider", text3drad)
		slider:SetPos(5, 0)
		slider:SetSize(text3drad:GetWide() - 10, 30)
		slider:SetMin(0)
		slider:SetMax(1024)
		slider:SetDecimals(0)
		slider:SetValue(GetConVar("noxrp_radius3dtext"):GetInt())
		slider:SetToolTip("Set the radius for visible 3D texts. Default is 512.")
		slider:SetConVar("noxrp_radius3dtext")
		slider.TextArea:SetTextColor(Color(255, 255, 255, 255))
		
	mainitemList:Add(text3drad)
	

	local bloompnl = vgui.Create("DPanel")
		bloompnl:SetSize(mainitemList:GetWide() - 10,30)
		bloompnl:SetPos(5,40)
		bloompnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enable/Disable Bloom", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
	local bloombox = vgui.Create("DCheckBoxLabel", bloompnl)
		bloombox:SetPos(5, 8)
		bloombox:SetText("")
		bloombox:SetConVar("noxrp_enablebloom")
		bloombox:SetValue(GetConVar("noxrp_enablebloom"):GetInt())
		bloombox:SizeToContents()
	
	mainitemList:Add(bloompnl)
	
	
	local dynlightpnl = vgui.Create("DPanel")
		dynlightpnl:SetSize(mainitemList:GetWide() - 10,30)
		dynlightpnl:SetPos(5,40)
		dynlightpnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enable/Disable Dynamic Lights", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
	local dynlightbox = vgui.Create("DCheckBoxLabel", dynlightpnl)
		dynlightbox:SetPos(5, 8)
		dynlightbox:SetText("")
		dynlightbox:SetConVar("noxrp_enabledlight")
		dynlightbox:SetValue(GetConVar("noxrp_enabledlight"):GetInt())
		dynlightbox:SizeToContents()
	
	mainitemList:Add(dynlightpnl)
	
	
	local colmodpnl = vgui.Create("DPanel")
		colmodpnl:SetSize(mainitemList:GetWide() - 10,30)
		colmodpnl:SetPos(5,40)
		colmodpnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enable/Disable Color Modulation", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	
	local colmodbox = vgui.Create("DCheckBoxLabel", colmodpnl)
		colmodbox:SetPos(5, 8)
		colmodbox:SetText("")
		colmodbox:SetConVar("noxrp_enablecolor")
		colmodbox:SetValue(GetConVar("noxrp_enablecolor"):GetInt())
		colmodbox:SizeToContents()
	
	mainitemList:Add(colmodpnl)
	

	local weatherpnl = vgui.Create("DPanel")
		weatherpnl:SetSize(mainitemList:GetWide() - 10,30)
		weatherpnl:SetPos(5, 40)
		weatherpnl:SetToolTip("Enable/Disable extra weather effects such as rain and snow particles.")
		weatherpnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enable/Disable Weather Effects", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
	local weatherbox = vgui.Create("DCheckBoxLabel", weatherpnl)
		weatherbox:SetPos(5, 8)
		weatherbox:SetText("")
		weatherbox:SetConVar("noxrp_drawweather")
		weatherbox:SetValue(GetConVarNumber("noxrp_drawweather"))
		weatherbox:SetToolTip("Enable/Disable extra weather effects such as rain and snow particles.")
		weatherbox:SizeToContents()
	
	mainitemList:Add(weatherpnl)
	
	
	local drawhudpnl = vgui.Create("DPanel")
		drawhudpnl:SetSize(mainitemList:GetWide() - 10,30)
		drawhudpnl:SetPos(5, 40)
		drawhudpnl:SetToolTip("Enable/Disable the HUD.")
		drawhudpnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enable/Disable main HUD elements.", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
	local hudbox = vgui.Create("DCheckBoxLabel", drawhudpnl)
		hudbox:SetPos(5, 8)
		hudbox:SetText("")
		hudbox:SetConVar("noxrp_drawhud")
		hudbox:SetValue(GetConVarNumber("noxrp_drawhud"))
		hudbox:SetToolTip("Enable/Disable main HUD elements.")
		hudbox:SizeToContents()
	
	mainitemList:Add(drawhudpnl)
	
	
	
	--=========================Radio Options=======================
	local radioheader = vgui.Create("DPanel")
		radioheader:SetSize(mainitemList:GetWide() - 10,30)
		radioheader:SetPos(5,40)
		radioheader.Paint = function(pnl, pw, ph)
			--draw.RoundedBox(4, 0, 0, pw, ph,Color(20, 20, 20, 150))
			--draw.RoundedBox(4, 1, 1, pw - 2, ph - 2, Color(40, 40, 40, 210))
			
			surface.SetTexture(gradient)
			surface.SetDrawColor(50, 50, 100, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			
			draw.SimpleText("Online Radio Options", "hidden14", pw * 0.5, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	mainitemList:Add(radioheader)
	
	local radiotogglepnl = vgui.Create("DPanel")
		radiotogglepnl:SetSize(mainitemList:GetWide() - 10, 60)
		radiotogglepnl:SetPos(5, 40)
		radiotogglepnl:SetToolTip("Enable the radio.")
		radiotogglepnl.Paint = function(pnl, pw, ph)
			surface.SetTexture(gradient)
			surface.SetDrawColor(0, 0, 0, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			draw.SimpleText("Enables the music stream. Plays music from different channels.", "hidden14", 40, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Set the volume of the music stream.", "hidden12", 5, 45, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
	local toggleradio = vgui.Create("DCheckBoxLabel", radiotogglepnl)
		toggleradio:SetPos(5, 8)
		toggleradio:SetText("")
		toggleradio:SetConVar("noxrp_toggleradio")
		toggleradio:SetValue(GetConVarNumber("noxrp_toggleradio"))
		toggleradio:SetToolTip("Enable the radio.")
		toggleradio:SizeToContents()
		toggleradio.OnChange = function(toggle, val)
			//If we turn it on, then create the station
			print("we toggled the box to: ", val)
			if val then
				sound.PlayURL( "http://stream.techno.fm/techno.mp3", "", function( station, errorid, errorstring )
					if IsValid( LocalPlayer().g_URLMusicStream ) then
						LocalPlayer().g_URLMusicStream:Stop()
					end
					
					print("Is the station valid?", IsValid(station))
					if IsValid(station) then
						station:SetPos( Vector(0,0,0) )
						station:SetVolume(1 * (GetConVar("noxrp_radiovolume"):GetInt() / 100))
						station:Play()
						LocalPlayer().g_URLMusicStream = station -- save the handle somewhere, so it doesn't get gc'd.
					end
				end)
			else
				if ( IsValid( LocalPlayer().g_URLMusicStream ) ) then
					LocalPlayer().g_URLMusicStream:Stop()
					LocalPlayer().g_URLMusicStream = nil
				end
			end
		end
		
	local volslider = vgui.Create("DNumSlider", radiotogglepnl)
		volslider:SetPos(5, 30)
		volslider:SetSize(radiotogglepnl:GetWide() - 10, 30)
		volslider:SetMin(0)
		volslider:SetMax(100)
		volslider:SetValue(GetConVar("noxrp_radiovolume"):GetInt())
		volslider:SetDecimals(0)
		volslider:SetConVar("noxrp_radiovolume")
		volslider:SetToolTip("Set the volume for the music stream.")
		volslider.TextArea:SetTextColor(Color(255, 255, 255, 255))
		volslider.OnValueChanged = function(slider, val)
			if ( IsValid( LocalPlayer().g_URLMusicStream ) ) then
				LocalPlayer().g_URLMusicStream:SetVolume(1 * (val / 100))
			end
		end
	
	mainitemList:Add(radiotogglepnl)
	
	
	
	
	--=============ALPHA TESTING============
	local alphaheader = vgui.Create("DPanel")
		alphaheader:SetSize(mainitemList:GetWide() - 10,30)
		alphaheader:SetPos(5,40)
		alphaheader.Paint = function(pnl, pw, ph)
			--draw.RoundedBox(4, 0, 0, pw, ph,Color(20, 20, 20, 150))
			--draw.RoundedBox(4, 1, 1, pw - 2, ph - 2, Color(40, 40, 40, 210))
			
			surface.SetTexture(gradient)
			surface.SetDrawColor(50, 50, 100, 200)
			
			surface.DrawTexturedRect(0, 0, pw, ph)
			
			draw.SimpleText("ALPHA Options", "hidden14", pw * 0.5, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	mainitemList:Add(alphaheader)
end

function PANEL:DoRemove()
	LocalPlayer().v_OptionsMenu = nil
	
	RemoveVGUIElement(self)
	
	if self.FromMainMenu then
		LocalPlayer().v_MainMenu = vgui.Create("dMainMenu")
	end
	self:Remove()
end

function PANEL:DoClick()
end

vgui.Register( "dOptionsMenu", PANEL, "EditablePanel" )