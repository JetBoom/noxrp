--[[
contains the chat stuff (world chat boxes over players' heads)
]]

--Adds chat tags and adds overhead text
function NoXRPChat(player, strText, bTeamOnly, bPlayerIsDead)
	local tab = {}

	if string.sub(strText, 1, 2) == "/w" then
		chat.AddText(Color(100, 200, 255), "[Whisper] ", player, Color(255, 255, 255), ": ", string.sub(strText, 3))

		tab.Text = "[W] "..string.sub(strText, 4)
		tab.LifeTime = 10
		tab.Color = Color(255, 170, 170, 255)

		player:AddOverheadText(tab)
	elseif string.sub(strText, 1, 2) == "/g" or string.sub(strText, 1, 2) == "--" then
		chat.AddText(Color(255, 100, 100), "[Global] ", player, Color(255, 255, 255), ": ", string.sub(strText, 3))
	elseif string.sub(strText, 1, 2) == "/p" then
		chat.AddText(Color(100, 255, 100), "[Party] ", player, Color(255, 255, 255), ": ", string.sub(strText, 3))
	elseif string.sub(strText, 1, 2) == "/e" then
		chat.AddText(col, player:Nick(), " ", string.sub(strText, 3))

		tab.Text = player:Nick().." "..string.sub(strText, 3)
		tab.LifeTime = 10
		tab.Color = Color(255, 255, 100, 255)

		player:AddOverheadText(tab)
	else
		chat.AddText(Color(200, 200, 255), "[Local] ", player, Color(255, 255, 255), ": ", strText)

		tab.Text = strText
		tab.LifeTime = 10

		player:AddOverheadText(tab)
	end
	return true
end
hook.Add("OnPlayerChat", "NoXRP.OnPlayerChat", NoXRPChat)

--These two functions deal with World text panels. Basically, if the server sends a worldmessage, the client draws them at the vector specified for a certain amount of time.
--This deals with the deletion of the text.
function OverheadTextThink()
	if LocalPlayer().v_GlobalText then
		if #LocalPlayer().v_GlobalText > 0 then
			for i, tab in pairs(LocalPlayer().v_GlobalText) do
				if tab.LifeTime < CurTime() then
					table.remove(LocalPlayer().v_GlobalText, i)
					i = i - 1
				elseif tab.LifeTime <= CurTime() + 0.3 then
					tab.Alpha = math.max(tab.Alpha - 10, 0)
				end

				tab.Position = tab.Position + tab.Velocity
				tab.Velocity = tab.Velocity * tab.Resistance
			end
		end
	end
end
hook.Add("Think", "OverheadText.Think", OverheadTextThink)

--And this draws the worldmessages
local function OverheadTextDraw()
	local ang = EyeAngles()

	if LocalPlayer().v_GlobalText then
		if #LocalPlayer().v_GlobalText > 0 then
			for _, tab in pairs(LocalPlayer().v_GlobalText) do
				local text = tab.Text
				if tab.Stacks > 1 then
					text = text.." [X"..tab.Stacks.."]"
				end

				surface.SetFont("Xolonium48")
				local tw, th = surface.GetTextSize(text)

				local col = Color(255, 255, 255)
				if tab.MostRecent then
					col = Color(255 - 50 * math.sin(CurTime() * 10), 200 - 50 * math.sin(CurTime() * 10), 200 - 50 * math.sin(CurTime() * 10))
				elseif tab.Color then
					col = tab.Color
				end
				col.a = tab.Alpha

				cam.Start3D2D(tab.Position, Angle(180, ang.y + 90, -90), 0.05)
					draw.RoundedBox(8, tw * -0.5 - 10, -50, tw + 20, 100, Color(0, 0, 0, tab.Alpha))
					draw.SimpleText(text, "Xolonium48", 0,  0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				cam.End3D2D()
			end
		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "OverheadText.Draw", OverheadTextDraw)

--This is the net receiver for global text.
function RecieveGlobalText()
	--Read it
	local tab = net.ReadTable()
		tab.Stacks = 1
		--Velocity makes it move around a bit
		tab.Velocity = (LocalPlayer():GetShootPos() - tab.Position):GetNormalized() + VectorRand() * 0.04
		tab.Resistance = 0.9

	--If theres a sound to play, play it
	if tab.Sound then
		surface.PlaySound(tab.Sound)
		tab.Sound = nil
	end

	if not LocalPlayer().v_GlobalText then
		LocalPlayer().v_GlobalText = {}
	end

	--If we already have another global text with the same text, and its close to it, then just combine them
	local alreadythere = false

	--The MostRecent boolean makes the text flash. Seen in the above drawing hook
	for _, tab in pairs(LocalPlayer().v_GlobalText) do
		if tab.MostRecent then
			tab.MostRecent = nil
		end
	end

	for k, v in pairs(LocalPlayer().v_GlobalText) do
		local dist = v.Position:Distance(tab.Position)
		if v.Text == tab.Text and dist < 40 then
			--Combine them
			v.Stacks = v.Stacks + 1
			v.LifeTime = CurTime() + 5
			v.MostRecent = true

			alreadythere = true
			break
		elseif v.Text ~= tab.Text then
			if dist < 40 then
				tab.Position = tab.Position + Vector(0, 0, 5)
			end
		--	alreadythere = RecursiveCheck(tab, tab.Position + Vector(0, 0, 5))
		end
	end

	if not alreadythere then
		tab.MostRecent = true
		table.insert(LocalPlayer().v_GlobalText, tab)
	end
end
net.Receive("sendGlobalText", RecieveGlobalText)

--This is the net receiver for entity OverheadText. Similiar to world messages, but draw overtop an entity.
function RecieveOverheadText()
	local tab = net.ReadTable()
	if tab.SubtitleType then
		if GetConVarNumber("noxrp_worldsubtitles") < tab.SubtitleType then
			return
		end
	end

	if tab.Entity then
		tab.Entity = Entity(tab.Entity)
		tab.Entity:AddOverheadText(tab)
	end
end
net.Receive("sendOverheadText", RecieveOverheadText)



--[[

This is the area for the conversations.

]]


--Start the conversation with the specified entity.
function StartConversation()
	local ent = net.ReadEntity()
	local str = net.ReadString()

	local convo = Deserialize(str)
	if ent:IsValid() then
		LocalPlayer().NPCIsTalkingTo = ent
		LocalPlayer().CurrentConversation = convo
		LocalPlayer().Conversation = {}

		gui.EnableScreenClicker(true)

		local scroll = vgui.Create("DScrollPanel")
			scroll:SetPos(ScrW() * 0.5 - 200, ScrH() * 0.6 + 35)
			scroll:SetSize(ScrW() * 0.4, 300)

		local list = vgui.Create( "DIconLayout", scroll)
			list:SetSize(scroll:GetWide() - 10, scroll:GetTall() - 60)
			list:SetPos(10, 10)
			list:SetSpaceY(5)
			list:SetSpaceX(ScrW() * 0.5 - 5)

		LocalPlayer().Conversation.List = list
		LocalPlayer().Conversation.Scroll = scroll

		UpdateConvoOptions()
	end
end
net.Receive("startConversation", StartConversation)

--End the conversation
function EndConversation()
	LocalPlayer().NPCIsTalkingTo = nil

	LocalPlayer().Conversation.Header:Remove()
	LocalPlayer().Conversation.List:Remove()
	LocalPlayer().Conversation.Scroll:Remove()
	LocalPlayer().Conversation = nil
	LocalPlayer().CurrentConversation = nil

	gui.EnableScreenClicker(false)
end
net.Receive("endConversation", EndConversation)

--The net receiver for continuing a conversation
function ContinueConversation()
	local str = net.ReadString()
	LocalPlayer().CurrentConversation = Deserialize(str)

	UpdateConvoOptions()
end
net.Receive("continueConversation", ContinueConversation)

--When the player presses a button, this updates the conversation choices and text.
function UpdateConvoOptions()
	local ply = LocalPlayer()
	local convo = ply.CurrentConversation

	--Header is the text displayed at the top of the menu. Essentially what the entity said in response to a choice
	if ply.Conversation.Header then
		local header = ply.Conversation.Header
		header.Text = convo.Text
		header:BuildPosition()
	else
		local header = vgui.Create("DPanel")
			header.Text = convo.Text
			header:SetSize(400, 25)
			header.Paint = function(pnl, pw, ph)
				draw.RoundedBox(8, 0, 0, pw, ph, Color(20, 20, 20, 200))
				draw.SimpleText(pnl.Text, "hidden18", pw * 0.5, ph * 0.5, Color(50, 150, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			header.BuildPosition = function(pnl)
				surface.SetFont("hidden18")
				local tw, th = surface.GetTextSize(pnl.Text)

				pnl:SetSize(tw + 20, th + 10)
				pnl:SetPos(ScrW() * 0.5 - tw * 0.5 - 10, ScrH() * 0.6)
			end

			header:BuildPosition()

		ply.Conversation.Header = header
	end

	--If we already have a bunch of choice buttons, remove them and make new ones for the next set of choices
	if #ply.Conversation.List:GetChildren() > 0 then
		for _, v in pairs(ply.Conversation.List:GetChildren()) do
			v:Remove()
		end
	end

	for index, choice in pairs(convo.Choices) do
		local panel = vgui.Create("DButton")
			panel.Text = choice[3]
			panel:SetText("")

		panel.Paint = function(pnl, pw, ph)
			draw.RoundedBox(8, 0, 0, pw, ph, Color(20, 20, 20, 200))

			local col = Color(255, 255, 255, 255)
			if pnl.Hovered then
				col = Color(150, 255, 150, 255)
			end
			draw.SimpleText(pnl.Text, "hidden18", pw * 0.5, ph * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		panel.BuildPosition = function(pnl)
			surface.SetFont("hidden18")
			local tw, th = surface.GetTextSize(pnl.Text)

			pnl:SetSize(tw + 20, th + 10)
		end
		panel:BuildPosition()

		panel.DoClick = function(btn)
			net.Start("continueConversation")
				net.WriteInt(index, 8)
			net.SendToServer()
		end

		LocalPlayer().Conversation.List:Add(panel)
	end
end