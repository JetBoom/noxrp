local PANEL = {}

function PANEL:Init()
	gui.EnableScreenClicker(true)
	local scrnw = ScrW()
	local scrnh = ScrH()

	Derma_DrawBackgroundBlur( self, CurTime() )

	self:SetSize(scrnw,scrnh)
	self:MainWaitMenu()

	self.TransitionTime = 0

	surface.PlaySound("music/hl2_song10.mp3")
end

function PANEL:MainWaitMenu()
	local idlepanel = vgui.Create("DPanel",self)
	idlepanel:SetSize(self:GetWide() * 0.2, self:GetTall() * 0.2)
	idlepanel:SetPos(self:GetWide() * 0.4, self:GetTall() * 0.4)
	idlepanel.Paint = function(pnl)
		local w = pnl:GetWide()
		local h = pnl:GetTall()

		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))

		draw.SimpleText("Waiting...", "hidden18", w * 0.5, h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	idlepanel.Think = function()
		if LocalPlayer().c_AccountInfo then
			self:OpenCharacterMenu()
		end
	end
end

function PANEL:RefreshMenu()
	for k,v in pairs(self:GetChildren()) do
		v:Remove()
	end
end


function PANEL:OpenFlagMenu()
	if self.FlagList then return end

	local scrnh = ScrH()
	local scrnw = ScrW()

	self.FlagList = vgui.Create("DPanel")
	self.FlagList:SetPos(scrnw * 0.25, scrnh * 0.25)
	self.FlagList:SetSize(scrnw * 0.5, scrnh * 0.25)
	self.FlagList.Paint = function(pnl)
		local w = pnl:GetWide()
		local h = pnl:GetTall()

		draw.RoundedBox(6, 0, 0, w, h, Color(70, 70, 70, 220))
		draw.RoundedBox(6, 1, 1, w - 2, h - 2, Color(0, 0, 0, 180))

		if #LocalPlayer().c_AccountInfo.RPFlags == 0 then
			draw.SimpleText("There are no outstanding notices.", "nulshock32", w * 0.5, h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	self.ScrollInv = vgui.Create("DScrollPanel", self.FlagList)
		self.ScrollInv:SetPos(5, 25)
		self.ScrollInv:SetSize(self.FlagList:GetWide() - 5, self.FlagList:GetTall() - 30)

	self.itemList = vgui.Create("DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide() - 10, self.ScrollInv:GetTall() - 10)
		self.itemList:SetPos(5, 5)
		self.itemList:SetSpaceY(10)
		self.itemList:SetSpaceX(5)

	for _,flag in pairs(LocalPlayer().c_AccountInfo.RPFlags) do
		local pan = vgui.Create("DPanel")
		pan:SetSize(self.itemList:GetWide(), 50)
		pan.Paint = function(dpnl, pw, ph)
			draw.RoundedBox(6, 0, 0, pw, ph, Color(120, 120, 120, 220))
			draw.DrawText(ACCT_FLAG_TRANSLATE[flag], "nulshock26", pw * 0.5, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		self.itemList:Add(pan)
	end

	local exitbtn = vgui.Create("DButton", self.FlagList)
	exitbtn:SetSize(75, 25)
	exitbtn:SetPos(self.FlagList:GetWide() - 100, 5)
	exitbtn:SetText("")
	exitbtn.Paint = function(btn,w,h)
		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 220))

		local textcol = Color(255, 255, 255, 255)
		if self.Hovered then
			textcol = Color(50, 150, 255, 255)
		end

		draw.SimpleText("Close", "hidden12", w * 0.5, h * 0.5, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	exitbtn.DoClick = function()
		self.FlagList:Remove()
		self.FlagList = nil
	end
end

local gradient_left = surface.GetTextureID("noxrp/gradient_left")
local glow = Material("sprites/light_glow02_add")
function PANEL:OpenCharacterMenu()
	local ply = LocalPlayer()
	self:RefreshMenu()
	local scrnw = ScrW()
	local scrnh = ScrH()

	self.TransitionTime = CurTime() + 3

	local forcenewchar = false
	for k,v in pairs(LocalPlayer().c_AccountInfo.RPFlags) do
		if v == ACCT_FLAG_REQUIRE_CHARSETUP then
			forcenewchar = true
			break
		end
	end

	local playercharacter = LocalPlayer().c_AccountInfo

	local charpanel = vgui.Create("DPanel",self)
	charpanel:SetPos(0, scrnh * 0.1)
	charpanel:SetSize(scrnw, scrnh)
	charpanel.Paint = function(pnl, w, h)
		local textalpha = 255

		if self.TransitionTime > CurTime() then
			textalpha = (3 - (self.TransitionTime - CurTime())) * 255
		end

		if forcenewchar then
			draw.DrawText("Welcome to NoxRP, an in-dev\na Garry's Mod RP/RPG.", "nulshock26", w * 0.6, h * 0.1, Color(200, 255, 200, textalpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.DrawText("Click on the 'New Character Button'\nat the bottom to continue.", "nulshock22", w * 0.6, h * 0.3, Color(255, 255, 255, textalpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SlantedRectHorizOffset(0, 0, w - 3, h - 3, 0, Color(20, 20, 20, 180), Color(30, 30, 30, 180), 3, 3)

			draw.SimpleText(LocalPlayer():Nick(), "nulshock38", w * 0.5, 10, Color(200, 255, 200, textalpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			local amt = 0
			if playercharacter.Skills then
				for k,v in pairs(playercharacter.Skills) do
					amt = amt + v
				end
			end

			local timet = playercharacter.PlayTime

			draw.SimpleText("Total Skill Points: "..amt, "nulshock22", w * 0.3, h * 0.2, Color(255, 255, 255, textalpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Current Playtime: "..string.NiceTime(timet), "nulshock22", w * 0.3, h * 0.2 + 70, Color(255, 255, 255, textalpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Karma: "..(playercharacter.Karma or 0), "nulshock22", w * 0.3, h * 0.2 + 105, Color(255, 255, 255, textalpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end

	local mdl = vgui.Create( "DModelPanel", charpanel)
	mdl:SetSize(scrnw * 0.5, scrnh)
	mdl:SetPos(5, 5)
	mdl:SetFOV(36)

	local scale = ScrW() / ScrH()

	mdl:SetCamPos(Vector(-65 * scale, -65, 32))
	mdl:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 50))
	mdl:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 50))
	mdl:SetAmbientLight(Vector( 64, 64, 64 ))
	local bodyitemmodel
	if ply:GetEquipment() then
		local bodyit = ply:GetEquipmentSlot(EQUIP_ARMOR_BODY)
		if bodyit then
			bodyit = ply:GetItemByID(bodyit)
			if bodyit then
				local bodyitem = ITEMS[bodyit:GetDataName()]
				if bodyitem and bodyitem.GetPlayerModel then
					model = bodyitem:GetPlayerModel(ply, playercharacter.Model)
				end
			end
		end
	end
	mdl:SetModel(bodyitemmodel or playercharacter.Model or "models/player/group01/male_0"..math.random(9)..".mdl")
	mdl:SetAnimated( true )
	mdl:SetLookAt(Vector(0, -10, 26))
	mdl.OnRemove = function()
		if ( IsValid( mdl.Entity ) ) then
			mdl.Entity:Remove()
		end

		if mdl.Emitter then
			mdl.Emitter:Finish()
		end
	end

	mdl.Emitter = ParticleEmitter(mdl.Entity:GetPos())
	mdl.NextEmit = 0

	--This bit here lets us render particles in a dmodelpanel
	mdl.DrawModel = function(pnl)
		local curparent = pnl
		local rightx = pnl:GetWide()
		local leftx = 0
		local topy = 0
		local bottomy = pnl:GetTall()
		local previous = curparent
		while(curparent:GetParent() != nil) do
			curparent = curparent:GetParent()
			local x,y = previous:GetPos()
			topy = math.Max(y, topy+y)
			leftx = math.Max(x, leftx+x)
			bottomy = math.Min(y+previous:GetTall(), bottomy + y)
			rightx = math.Min(x+previous:GetWide(), rightx + x)
			previous = curparent
		end
		render.SetScissorRect(leftx,topy,rightx, bottomy, true)
		--From this point to the end of the render, we can do any drawing methods. that includes render stuff
		pnl.Entity:DrawModel()

		render.SetMaterial(glow)
		render.DrawQuadEasy(pnl.Entity:GetPos(), Vector(0, 0, 1), 30 + 20 * math.cos(CurTime() * 4), 30 + 20 * math.cos(CurTime() * 4), Color(255, 255, 255, 255), 0)

		--In this section, create the particles like you normally would
		if pnl.NextEmit < CurTime() then
			pnl.NextEmit = CurTime() + 0.04
			render.SetBlend( 0.1 )
				local particle = pnl.Emitter:Add("particle/smokestack", pnl.Entity:GetPos() + pnl.Entity:GetRight() * 2 + pnl.Entity:GetForward() * -50 + Vector(0, 0, math.random(20)))
					particle:SetDieTime(4)
					particle:SetStartAlpha(50)
					particle:SetEndAlpha(0)
					particle:SetStartSize(6)
					particle:SetEndSize(6)
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-1, 1))
					particle:SetColor(100, 100, 100)
					particle:SetVelocity(pnl.Entity:GetForward() * 20)
					--particle:SetAirResistance(math.random(10, 50))
					--particle:SetLighting(true)

				particle = pnl.Emitter:Add("effects/fire_cloud"..math.random(1, 2), pnl.Entity:GetPos() + pnl.Entity:GetRight() * -2 + pnl.Entity:GetForward() * -50 + Vector(0, 0, math.random(50)))
					particle:SetDieTime(4)
					particle:SetStartAlpha(150)
					particle:SetEndAlpha(0)
					particle:SetStartSize(1)
					particle:SetEndSize(1)
					particle:SetRoll(math.Rand(0, 360))
					particle:SetRollDelta(math.Rand(-1, 1))
					particle:SetColor(100, 100, 100)
					particle:SetVelocity(pnl.Entity:GetForward() * 20)
					particle:SetGravity(Vector(0, 0, math.Rand(-1, 1) * 1))
					--particle:SetThinkFunction( function( pa )
					--	pa:SetVelocity(pa:GetVelocity() + Vector(0, 0, math.Rand(-1, 1)))
					--	pa:SetNextThink( 1 )
					--end)
					particle:SetAirResistance(math.random(0, 10))
					--particle:SetLighting(true)

			render.SetBlend( pnl.colColor.a/255 )
		end

		--The main thing is we have to manually draw the emitter every time
		if mdl.Emitter then
			mdl.Emitter:Draw()
		end
		render.SetScissorRect(0,0,0,0, false)
	end
	mdl:SetCursor("arrow")
		function mdl:LayoutEntity(Entity)
			local seq = Entity:LookupSequence("pose_standing_01")
			Entity:SetSequence(seq)
			Entity:SetAngles(Angle(0, -90, 0))
			Entity:SetEyeTarget(Vector(0, 0, 64))
		end

	--If we haven't ever made a character, then lets set it up
	if forcenewchar then
		self.ForceNewChar = true
		--Stores all the info we have, until we send it
		self.NewCharInfo = {}

		local createbtn = vgui.Create("DButton", charpanel)
		createbtn:SetSize(scrnw * 0.4, 35)
		createbtn:SetPos(scrnw * 0.4, scrnh * 0.75)
		createbtn:SetText("")
		createbtn.Paint = function(btn, bw, bh)
			--draw.RoundedBox(6, 0, 0, bw, bh, Color(40, 40, 40, 150))
			draw.ElongatedHexagonHorizontalOffset(0, 0, bw, bh, 4, Color(30, 30, 30, 160), Color(20, 20, 20, 180), 3, 3)

			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(50, 150, 255, 255)
			end
			draw.SimpleText("New Character", "nulshock22", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		createbtn.DoClick = function()
			self.NewCharInfo = {}
			self.NewCharInfo.SelectedSkills = {}
			self:AcknowledgeWIPGame()
			--self:OpenNewCharacter_Model()
		end
	else
		local playbtn = vgui.Create("DButton", charpanel)
		playbtn:SetSize(scrnw * 0.4, 35)
		playbtn:SetPos(scrnw * 0.6, scrnh * 0.4)
		playbtn:SetText("")
		playbtn.Paint = function(btn, bw, bh)
			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(50, 150, 255, 255)
			end

			surface.SetTexture(gradient_left)
			surface.SetDrawColor(20, 20, 20, 200)
			surface.DrawTexturedRect(0, 0, bw, bh)
			draw.SimpleText("Play", "nulshock32", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		playbtn.DoClick = function()
			RunConsoleCommand("nox_play")

			LocalPlayer().c_InGame = true
			gui.EnableScreenClicker(false)
			self:Remove()
		end

		local optionbtn = vgui.Create("DButton", charpanel)
		optionbtn:SetSize(scrnw * 0.4, 35)
		optionbtn:SetPos(scrnw * 0.6, scrnh * 0.4 + 40)
		optionbtn:SetText("")
		optionbtn.Paint = function(btn, bw, bh)
			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(50, 150, 255, 255)
			end

			surface.SetTexture(gradient_left)
			surface.SetDrawColor(20, 20, 20, 200)
			surface.DrawTexturedRect(0, 0, bw, bh)
			draw.SimpleText("Options", "nulshock32", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		optionbtn.DoClick = function()
			vgui.Create("dOptionsMenu")
		end

		local noticebtn = vgui.Create("DButton", charpanel)
		noticebtn:SetSize(scrnw * 0.4, 35)
		noticebtn:SetPos(scrnw * 0.6, scrnh * 0.4 + 80)
		noticebtn:SetText("")
		noticebtn.Paint = function(btn, bw, bh)
			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(50, 150, 255, 255)
			end

			surface.SetTexture(gradient_left)
			surface.SetDrawColor(20, 20, 20, 200)
			surface.DrawTexturedRect(0, 0, bw, bh)
			draw.SimpleText("Notices", "nulshock32", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		noticebtn.DoClick = function()
			vgui.Create("dNotices")
		end

		local helpbtn = vgui.Create("DButton", charpanel)
		helpbtn:SetSize(scrnw * 0.4, 35)
		helpbtn:SetPos(scrnw * 0.6, scrnh * 0.4 + 120)
		helpbtn:SetText("")
		helpbtn.Paint = function(btn, bw, bh)
			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(50, 150, 255, 255)
			end

			surface.SetTexture(gradient_left)
			surface.SetDrawColor(20, 20, 20, 200)
			surface.DrawTexturedRect(0, 0, bw, bh)
			draw.SimpleText("Help", "nulshock32", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		helpbtn.DoClick = function()
			vgui.Create("dHelpMenu")
		end

		local disconnectbtn = vgui.Create("DButton", charpanel)
		disconnectbtn:SetSize(scrnw * 0.4, 35)
		disconnectbtn:SetPos(scrnw * 0.6, scrnh * 0.4 + 160)
		disconnectbtn:SetText("")
		disconnectbtn.Paint = function(btn, bw, bh)
			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(50, 150, 255, 255)
			end

			surface.SetTexture(gradient_left)
			surface.SetDrawColor(20, 20, 20, 200)
			surface.DrawTexturedRect(0, 0, bw, bh)
			draw.SimpleText("Disconnect", "nulshock32", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		disconnectbtn.DoClick = function()
			RunConsoleCommand("disconnect")
		end

	end
end

function PANEL:AcknowledgeWIPGame()
	self:RefreshMenu()
	local scrnw = ScrW()
	local scrnh = ScrH()

	local charpanel = vgui.Create("DPanel", self)
	charpanel:SetSize(scrnw, scrnh * 0.6)
	charpanel:SetPos(0, scrnh * 0.2)
	charpanel.Paint = function(pnl, w, h)
		draw.SlantedRectHorizOffset(0, 0, w - 3, h - 3, 0, Color(20, 20, 20, 180), Color(30, 30, 30, 180), 3, 3)

		draw.SimpleText("Warnings:", "nulshock32", w * 0.5, 50, Color(200, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("This gamemode is still a work in progress.", "nulshock26", w * 0.5, 90, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("As such, nothing is concrete and may be changed.", "nulshock26", w * 0.5, 115, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("Character data may be wiped if necessary, but notices will be given beforehand.", "nulshock26", w * 0.5, 150, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	local playbtn = vgui.Create("DButton", charpanel)
	playbtn:SetSize(180, 35)
	playbtn:SetPos(scrnw * 0.5 - 90, charpanel:GetTall() - 40)
	playbtn:SetText("")
	playbtn.Paint = function(btn, bw, bh)
		draw.ElongatedHexagonHorizontalOffset(0, 0, bw, bh, 4, Color(30, 30, 30, 160), Color(20, 20, 20, 180), 3, 3)

		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("Acknowledged", "hidden18", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	playbtn.DoClick = function()
		self:OpenNewCharacter_Model()
	end
end

function PANEL:OpenNewCharacter_Model()
	self:RefreshMenu()
	local scrnw = ScrW()
	local scrnh = ScrH()

	local charpanel = vgui.Create("DPanel", self)
	charpanel:SetSize(scrnw * 0.7, scrnh * 0.6)
	charpanel:SetPos(scrnw * 0.15, scrnh * 0.15)
	charpanel.Paint = function(pnl, pw, ph)
		--draw.RoundedBox(8, 0, 0, pnl:GetWide(), pnl:GetTall(), Color(0, 0, 0, 180))
		draw.SlantedRectHorizOffset(0, 0, pw - 3, ph - 3, 0, Color(20, 20, 20, 180), Color(30, 30, 30, 180), 3, 3)

		draw.SimpleText("Select Your Model", "nulshock26", 15, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end

	local mdl = vgui.Create("DModelPanel", charpanel)
	mdl:SetSize(scrnw * 0.3, scrnh * 0.7 - 10)
	mdl:SetPos(5, 5)
	mdl:SetFOV(36)
	mdl:SetCamPos(Vector(-130, -22, 50))
	mdl:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 255))
	mdl:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 255))
	mdl:SetAmbientLight(Vector(64, 64, 64))
	mdl:SetModel("models/player/group01/male_01.mdl")
	mdl:SetAnimated(true)
	mdl.Angles = Angle(0, 0, 0)
	mdl:SetLookAt(Vector(0, 0, 36))

	local PanelSelect = vgui.Create( "DIconLayout", charpanel)
	PanelSelect:SetSize(scrnw * 0.3, scrnh * 0.6)
	PanelSelect:SetPos(scrnw * 0.4, scrnh * 0.1)
	PanelSelect:SetSpaceX(5)
	PanelSelect:SetSpaceY(5)

	for name, tab in SortedPairs(ValidPlayerModels) do
		local icon = vgui.Create("SpawnIcon")
		icon:SetModel(tab.Model)
		icon:SetSize(64, 64)
		icon:SetTooltip(tab.Name)
		icon.playermodel = tab.Model
		icon.modelname = name
		icon.DoClick = function()
			mdl:SetModel(icon.playermodel)
			mdl.modelname = icon.modelname
			mdl.playermodel = icon.playermodel
		end

		PanelSelect:Add(icon)
	end


	local nextbtn = vgui.Create("DButton", charpanel)
	nextbtn:SetPos(charpanel:GetWide() - 95, charpanel:GetTall() - 35)
	nextbtn:SetSize(75, 25)
	nextbtn:SetText("")
	nextbtn.Paint = function(btn, bw, bh)
		draw.ElongatedHexagonHorizontalOffset(0, 0, bw, bh, 4, Color(30, 30, 30, 160), Color(20, 20, 20, 180), 3, 3)

		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("Next", "nulshock22", bw * 0.5, 12, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	nextbtn.DoClick = function()
		self.NewCharInfo.Model = mdl.playermodel
		self:OpenNewCharacter_Stats()
	end
end

function PANEL:OpenNewCharacter_Stats()
	self:RefreshMenu()
	local scrnw = ScrW()
	local scrnh = ScrH()

	local statpanel = vgui.Create("DPanel", self)
	statpanel:SetSize(scrnw * 0.7, scrnh * 0.6)
	statpanel:SetPos(scrnw * 0.15, scrnh * 0.15)
	statpanel.PointsToUse = STATS_FREEPOINTS
	statpanel.Stats = {
		[STAT_STRENGTH] = STATS_ALLOCATE_BASE,
		[STAT_AGILITY] = STATS_ALLOCATE_BASE,
		[STAT_INTELLIGENCE] = STATS_ALLOCATE_BASE,
		[STAT_ENDURANCE] = STATS_ALLOCATE_BASE
	}


	statpanel.Paint = function(pnl, pw, ph)
		draw.ElongatedHexagonHorizontalOffset(pw * 0.5 - 225, 10, 450, 30, 4, Color(50, 50, 50, 160), Color(30, 30, 30, 180), 3, 3)
		draw.SimpleText("Allocate points to your stats: "..tostring(pnl.PointsToUse), "nulshock18", pw * 0.5, 15,Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

		draw.ElongatedHexagonHorizontalOffset(pw * 0.5 - 125, ph * 0.65, 250, 30, 4, Color(50, 50, 50, 160), Color(30, 30, 30, 180), 3, 3)
		draw.SimpleText("Health: "..(GAME_BASEHEALTH + statpanel.Stats[STAT_STRENGTH] * GAME_HEALTHPERSTR + statpanel.Stats[STAT_ENDURANCE] * GAME_HEALTHPEREND), "nulshock16", pw * 0.5, ph * 0.65 + 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

		draw.ElongatedHexagonHorizontalOffset(pw * 0.5 - 125, ph * 0.7, 250, 30, 4, Color(50, 50, 50, 160), Color(30, 30, 30, 180), 3, 3)
		draw.SimpleText("Inventory Space: "..GAME_BASEWEIGHT + statpanel.Stats[STAT_STRENGTH] * GAME_WEIGHTPERSTRENGTH, "nulshock16", pw * 0.5, ph * 0.7 + 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
	--

	for stat, value in pairs(statpanel.Stats) do
		local panel = vgui.Create("DPanel", statpanel)
		panel:SetSize(700, 80)
		panel:SetPos(scrnw * 0.5 - 700, statpanel:GetTall() * 0.1 + 90 * stat)
		panel.Paint = function(pnl, pw, ph)
			local col = Color(30, 30, 30, 180)
			if pnl.Hovered then
				col = Color(40, 40, 40, 180)
			end

			local var = statpanel.Stats[stat]

			--draw.RoundedBox(4, 0, 0, pw, ph, col)
			draw.ElongatedHexagonHorizontalOffset(0, 0, pw, ph, 4, Color(50, 50, 50, 160), col, 3, 3)

			draw.SimpleText(STATS[stat].Name.." : "..var, "Xolonium16", 10, 5, Color(50, 150, 255, 255), TEXT_ALIGN_LEFT)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawLine(6, 38, 306, 38)
			surface.DrawRect(5, 35, 3, 6)
			surface.DrawRect(305, 35, 3, 6)

			surface.SetDrawColor(50, 150, 255, 255)
			surface.DrawRect(5 + (300 / STATS_MAXPERSTAT) * var, 35, 4, 4)

			draw.SimpleText(STATS[stat].Description, "Xolonium16", 10, 60, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end

		local incbtn = vgui.Create("DButton", panel)
			incbtn:SetText("")
			incbtn:SetSize(20, 20)
			incbtn:SetPos(300, 5)
			incbtn.Paint = function(btn, bw, bh)
				draw.SimpleText("+", "hidden24", bw * 0.5, bh * 0.5, Color(150, 255, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			incbtn.DoClick = function(btn)
				surface.PlaySound("buttons/button9.wav")
				if statpanel.PointsToUse > 0 and statpanel.Stats[stat] < STATS_MAXPERSTAT then
					statpanel.Stats[stat] = statpanel.Stats[stat] + 1
					statpanel.PointsToUse = statpanel.PointsToUse - 1
				end
			end

		local decbtn = vgui.Create("DButton", panel)
			decbtn:SetText("")
			decbtn:SetSize(20, 20)
			decbtn:SetPos(335, 5)
			decbtn.Paint = function(btn, bw, bh)
				draw.SimpleText("-", "hidden18", bw * 0.5, bh * 0.5, Color(255, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			decbtn.DoClick = function(btn)
				surface.PlaySound("buttons/button9.wav")
				if statpanel.Stats[stat] > 1 then
					statpanel.Stats[stat] = statpanel.Stats[stat] - 1
					statpanel.PointsToUse = statpanel.PointsToUse + 1
				end
			end
	end

	local nextbtn = vgui.Create("DButton", statpanel)
	nextbtn:SetPos(statpanel:GetWide() - 95, statpanel:GetTall() - 35)
	nextbtn:SetSize(75, 25)
	nextbtn:SetText("")
	nextbtn.Paint = function(btn, bw, bh)
		draw.ElongatedHexagonHorizontalOffset(0, 0, bw, bh, 4, Color(30, 30, 30, 160), Color(20, 20, 20, 180), 3, 3)

		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("Next", "nulshock22", bw * 0.5, 12, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	nextbtn.DoClick = function()
		self.NewCharInfo.Stats = statpanel.Stats

		local maxs = STATS_ALLOCATE_BASE * 4 + STATS_FREEPOINTS
		local cur = 0
		for k, v in pairs(statpanel.Stats) do
			cur = cur + v
		end

		if cur < maxs then
			self:VerifyContinue()
		elseif cur == maxs then
			self:OpenNewCharacter_Skills()
		end
	end
end

function PANEL:VerifyContinue()
	local pnl = vgui.Create("DPanel")
		pnl:SetSize(400, 150)
		pnl:SetPos(ScrW() * 0.5 - 200, ScrH() * 0.5 - 75)
		pnl.Paint = function(me, pw, ph)
			draw.SlantedRectHoriz(0, 0, pw, ph, 0, Color(20, 20, 20, 150), Color(0, 0, 0, 255))

			draw.SimpleText("Not all your stat points were used.", "hidden16", pw * 0.5, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Continue?", "hidden16", pw * 0.5, 35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

	local agree = vgui.Create("DButton", pnl)
		agree:SetPos(5, 120)
		agree:SetSize(120, 25)
		agree:SetText("")
		agree.Paint = function(btn, bw, bh)
			draw.ElongatedHexagonHorizontalOffset(0, 0, bw, bh, 4, Color(30, 30, 30, 160), Color(20, 20, 20, 180), 3, 3)
			draw.SimpleText("Continue", "hidden14", bw * 0.5, bh * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		agree.DoClick = function()
			pnl:Remove()
			self:OpenNewCharacter_Skills()
		end

	local stop = vgui.Create("DButton", pnl)
		stop:SetPos(140, 120)
		stop:SetSize(140, 25)
		stop:SetText("")
		stop.Paint = function(btn, bw, bh)
			draw.ElongatedHexagonHorizontalOffset(0, 0, bw, bh, 4, Color(30, 30, 30, 160), Color(20, 20, 20, 180), 3, 3)
			draw.SimpleText("Cancel", "hidden14", bw * 0.5, bh * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		stop.DoClick = function()
			pnl:Remove()
		end
end

function PANEL:OpenNewCharacter_Skills()
	self:RefreshMenu()
	local scrnw = ScrW()
	local scrnh = ScrH()

	local skillpanel = vgui.Create("DPanel", self)
	skillpanel:SetSize(scrnw * 0.7, scrnh * 0.6)
	skillpanel:SetPos(scrnw * 0.15, scrnh * 0.15)
	skillpanel.Paint = function(pnl, pw, ph)
		draw.ElongatedHexagonHorizontalOffset(pw * 0.5 - 200, 10, 400, 30, 4, Color(50, 50, 50, 160), Color(30, 30, 30, 180), 3, 3)
		draw.SimpleText("Select a single skill to start.", "nulshock26", pw * 0.5, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	local skillscroll = vgui.Create("DScrollPanel",skillpanel)
		skillscroll:SetPos(5, 35)
		skillscroll:SetSize(skillpanel:GetWide() - 25,skillpanel:GetTall() - 100)

	local skilllist = vgui.Create( "DIconLayout", skillscroll)
		skilllist:SetSize(skillscroll:GetWide() - 10, skillscroll:GetTall() - 10)
		skilllist:SetPos(5, 5)
		skilllist:SetSpaceY(10)
		skilllist:SetSpaceX(5)

	for k,v in pairs(SKILLS) do
		local skillbtn = vgui.Create("DButton")
		skillbtn:SetSize(skilllist:GetWide() - 10, 55)
		skillbtn:SetText("")
		skillbtn.Paint = function(btn)
			local col = Color(50, 10, 10, 200)
			if btn.Selected then
				col = Color(10, 50, 10, 200)
			end
			draw.RoundedBox(6, 0, 0, btn:GetWide(), btn:GetTall(), col)
			draw.SimpleText(v.Name, "nulshock26", 15, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.DrawText(v.Descrip, "hidden12", 15, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end

		skillbtn.SetSelected = function(btn, bool)
			btn.Selected = bool
		end

		skillbtn.DoClick = function(btn)
			if not btn.Selected and #self.NewCharInfo.SelectedSkills < SKILL_STARTING_PICKS then
				surface.PlaySound("UI/buttonclick.wav")
				btn.Selected = true
				table.insert(self.NewCharInfo.SelectedSkills,k)
			elseif btn.Selected then
				surface.PlaySound("UI/buttonclickrelease.wav")
				btn.Selected = false
				for i,index in pairs(self.NewCharInfo.SelectedSkills) do
					if index == k then
						table.remove(self.NewCharInfo.SelectedSkills, i)
						break
					end
				end
			else
				surface.PlaySound("common/wpn_denyselect.wav")
			end
		end
		skilllist:Add(skillbtn)
	end

	local backbtn = vgui.Create("DButton", skillpanel)
	backbtn:SetPos(skillpanel:GetWide() - 180, skillpanel:GetTall() - 35)
	backbtn:SetSize(75, 25)
	backbtn:SetText("")
	backbtn.Paint = function(btn)
		local w = btn:GetWide()
		local h = btn:GetTall()
		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))

		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("Back", "nulshock22", w * 0.5, 12, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	backbtn.DoClick = function()
		self.NewCharInfo.SelectedSkills = nil
		self:OpenNewCharacter_Stats()
	end

	local nextbtn = vgui.Create("DButton", skillpanel)
	nextbtn:SetPos(skillpanel:GetWide() - 95, skillpanel:GetTall() - 35)
	nextbtn:SetSize(75, 25)
	nextbtn:SetText("")
	nextbtn.Paint = function(btn)
		local w = btn:GetWide()
		local h = btn:GetTall()
		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))

		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("Next", "nulshock22", w * 0.5, 12, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	nextbtn.DoClick = function()
		self:OpenCharacterWaitMenu()
		SendNewCharInfo()
	end
end

function PANEL:OpenCharacterWaitMenu()
	self:RefreshMenu()
	local idlepanel = vgui.Create("DPanel",self)
	idlepanel:SetSize(self:GetWide() * 0.2, self:GetTall() * 0.2)
	idlepanel:SetPos(self:GetWide() * 0.4, self:GetTall() * 0.4)
	idlepanel.Paint = function(pnl)
		local w = pnl:GetWide()
		local h = pnl:GetTall()

		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))

		draw.SimpleText("Waiting...", "hidden18", w * 0.5, h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:OpenInvalidCharInfo(id)
	self:RefreshMenu()
	local idlepanel = vgui.Create("DPanel",self)
	idlepanel:SetSize(self:GetWide() * 0.4, self:GetTall() * 0.2)
	idlepanel:SetPos(self:GetWide() * 0.3, self:GetTall() * 0.4)
	idlepanel.Paint = function(pnl)
		local w = pnl:GetWide()
		local h = pnl:GetTall()

		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))

		draw.DrawText(ACCT_FLAG_TRANSLATE[id],"nulshock32",w * 0.5, 15, Color(255, 200, 200, 255), TEXT_ALIGN_CENTER)
	end

	local continuebtn = vgui.Create("DButton",idlepanel)
	continuebtn:SetSize(idlepanel:GetWide() - 30, 25)
	continuebtn:SetPos(15, idlepanel:GetTall() - 35)
	continuebtn:SetText("")
	continuebtn.Paint = function(btn)
		local w = btn:GetWide()
		local h = btn:GetTall()
		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))

		local col = Color(255, 255, 255, 255)
		if btn.Hovered then
			col = Color(50, 150, 255, 255)
		end
		draw.SimpleText("Continue", "nulshock22", w * 0.5, 12, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	continuebtn.DoClick = function()
		self:OpenNewCharacter_Model()
	end
end

--[[local graddown = surface.GetTextureID("gui/gradient_down")
local gradup = surface.GetTextureID("gui/gradient_up")
local grad = surface.GetTextureID("gui/gradient")]]
local logo = Material("noxrp/noxrp2.png", "smooth")
function PANEL:Paint( w, h )
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, h)

	--[[surface.SetDrawColor(50, 75, 100, 100)
	surface.SetTexture(graddown)
	surface.DrawTexturedRect(0, 0, w, h * 0.1)

	surface.SetTexture(gradup)
	surface.DrawTexturedRect(0, h * 0.9, w, h * 0.1)]]

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(logo)
	surface.DrawTexturedRect(w * 0.5 - 193, 5, 387, 94)
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:Think()
	if not self.ForceNewChar then
		if input.IsKeyDown(KEY_ENTER) then
			RunConsoleCommand("nox_play")
			LocalPlayer().c_InGame = true
			gui.EnableScreenClicker(false)
			self:Remove()
		end
	end
end

vgui.Register( "dCharacterMenu", PANEL, "EditablePanel" )