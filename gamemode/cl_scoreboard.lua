local vScoreBoard

function GM:CreateScoreboard()
	if not LocalPlayer().c_InGame then return end
	local _w, _h = ScrW(), ScrH()
	if vScoreBoard then
		vScoreBoard:Remove()
		vScoreBoard = nil
	end

	vScoreBoard = vgui.Create("DFrame")
	vScoreBoard:SetSize(_w * 0.8, _h * 0.8)
	vScoreBoard:Center()
	vScoreBoard:SetVisible(true)
	vScoreBoard:SetTitle("")
	vScoreBoard.btnClose:SetVisible(false)
	vScoreBoard.btnMaxim:SetVisible(false)
	vScoreBoard.btnMinim:SetVisible(false)
	vScoreBoard:SetDraggable(false)
	
	vScoreBoard.Paint = function(pnl, pw, ph)
	end
	
	local scroll = vgui.Create("DScrollPanel", vScoreBoard)
		scroll:SetPos(5, 80)
		scroll:SetSize(vScoreBoard:GetWide() - 5, vScoreBoard:GetTall() - 70)
		
	self.PList = vgui.Create( "DIconLayout", scroll)
		self.PList:SetSize(scroll:GetWide() - 10, scroll:GetTall() - 60)
		self.PList:SetPos(10, 10)
		self.PList:SetSpaceY(10)
		self.PList:SetSpaceX(5)
		
	vScoreBoard.Think = function(pnl)
		for _, pl in pairs(player.GetAll()) do
			if pl.v_ScoreBoardEntry then continue end
			
			ScoreboardAddPlayer(pl, self.PList)
		end
	end
		
	local panel = vgui.Create("DPanel", vScoreBoard)
		panel:SetPos(5, 40)
		panel:SetSize(self.PList:GetWide() - 5, 30)
		panel.Paint = function(pnl, pw, ph)
			draw.SlantedRectHoriz(0, 0, pw, ph - 2, 15, Color(20, 20, 20, 200), Color(0, 0, 0, 255))
			draw.SimpleText("Name", "hidden14", 90, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Title", "hidden14", pw * 0.35, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("Karma", "hidden14", pw * 0.7, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Ping", "hidden14", pw - 60, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	
	for k, v in pairs(player.GetAll()) do
		ScoreboardAddPlayer(v, self.PList)
	end
end

function ScoreboardAddPlayer(v, plist)
	local panel = vgui.Create("DPanel")
		panel:SetSize(plist:GetWide() - 5, 56)
		panel.Player = v
			
	panel.Paint = function(pnl, pw, ph)
		--	draw.RoundedBox(4, 0, 0, pw, ph, Color(50, 50, 50, 255))
		draw.SlantedRectHoriz(0, 0, pw, ph - 2, 15, Color(50, 50, 50, 150), Color(0, 0, 0, 255))
			--draw.RoundedBox(4, 1, 1, pw - 2, ph - 2, Color(100, 100, 100, 255))
			
		draw.SimpleText(v:Nick(), "hidden14", 72, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
		if v:GetDTString(0) ~= "" then
			draw.SimpleText("("..v:GetDTString(0)..")", "hidden14", pw * 0.3, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
			
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(pw * 0.7 - 100, 15, 200, 20)
			
		local karma = v:Karma()
		if karma > 0 then
			if karma >= KARMA_OUTSTANDING then
				surface.SetDrawColor(50, 255, 50, 255)
			elseif karma >= KARMA_GOOD then
				surface.SetDrawColor(0, 255, 0, 255)
			else
				surface.SetDrawColor(100, 100, 100, 255)
			end
				
			surface.DrawRect(pw * 0.7, 16, 99 * (karma / 15000), 18)
		else
			if karma <= KARMA_DREADED then
				surface.SetDrawColor(200, 0, 0, 255)
			elseif karma <= KARMA_EVIL then
				surface.SetDrawColor(255, 0, 0, 255)
			elseif karma <= KARMA_CRIMINAL then
				surface.SetDrawColor(150, 150, 150, 255)
			else
				surface.SetDrawColor(100, 100, 100, 255)
			end
				
			local pos = 99 * (karma / -15000)
			surface.DrawRect(pw * 0.7 - pos, 16, pos, 18)
		end
			
		--	draw.SimpleText("Karma", "hidden12", pw * 0.7, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
		draw.SimpleText(v:Ping(), "hidden16", pw - 60, 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	panel.Think = function(pnl)
		if not pnl.Player:IsValid() then
			pnl:Remove()
		end
	end
		
	local model = vgui.Create("SpawnIcon", panel)
		model:SetSize(56, 52)
		model:SetPos(4, 4)
		model:SetModel(v:GetModel())
		model:SetToolTip("")
			
	panel.Think = function(pnl)
		if not pnl.Player:IsValid() then
			pnl:Remove()
		end
	end
	
	v.v_ScoreBoardEntry = panel
	plist:Add(panel, plist)
end

function GM:ScoreboardShow()
	if not LocalPlayer().c_InGame then return end
	GAMEMODE.ShowScoreboard = true

	gui.EnableScreenClicker(true)
	
	if not vScoreBoard then
		print("creating a scoreboard")
		self:CreateScoreboard()
	end
	
	vScoreBoard:SetVisible(true)
end

function GM:ScoreboardHide()
	if not LocalPlayer().c_InGame then return end
	GAMEMODE.ShowScoreboard = false

	gui.EnableScreenClicker(false)

	vScoreBoard:SetVisible(false)
end
