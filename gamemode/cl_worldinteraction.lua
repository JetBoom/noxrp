worldInteractionState = false
local currentpos = 0
local worldButtons = {}

local function AddGenericOptions()
	if LocalPlayer():InParty() then
		AddWorldInteractionOption("Leave Party", function() RunConsoleCommand("noxrp_leaveparty") end)
	end

	currentpos = 0
	for k, v in pairs(LocalPlayer().WorldInteractionList) do
		surface.SetFont("hidden14")
		local tw, th = surface.GetTextSize(v.Title)

		local button = vgui.Create("DButton")
			button:SetPos(ScrW() * 0.6, ScrH() * 0.5 + 30 * currentpos)
			button:SetSize(tw + 10, 30)
			button:SetText("")
			button.Text = v.Title
			button.Paint = function(btn, bw, bh)
				local col = Color(20, 20, 20, 150)
				if btn.Hovered then
					col = Color(20, 100, 20, 150)
				end
				--draw.RoundedBox(6, 0, 0, bw, bh, col)
				--draw.SlantedRectHorizOffset(0, 0, bw, bh, 5, col, Color(0, 0, 0, 255), 1, 1)
				draw.ElongatedHexagonHorizontalOffset(0, 0, bw - 1, bh - 1, 5, Color(0, 0, 0, 255), col, 1, 1)
				draw.SimpleText(v.Title, "hidden14", bw * 0.5, bh * 0.5, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			button.DoClick = function(btn)
				v:Function()

				EndWorldInteraction()

				gui.EnableScreenClicker(false)
			end

		table.Empty(LocalPlayer().WorldInteractionList)
		table.insert(worldButtons, button)
		currentpos = currentpos + 1
	end
end

function EndWorldInteraction()
	if not LocalPlayer().c_InGame then return end
	gui.EnableScreenClicker(false)
	worldInteractionState = false

	LocalPlayer().WorldInteractionEnt = nil
	LocalPlayer().WorldInteractionOptionsNorm = nil
	LocalPlayer().WorldInteractionOptionsPos = nil
	LocalPlayer().WorldInteractionList = {}
	LocalPlayer().WorldInteractionOptionsButtons = {}

	for k, v in pairs(worldButtons) do
		v:Remove()
	end
end

function GM:OnContextMenuOpen()
end

function ToggleWorldInteraction(ply, bind, wasin)
	if bind == "+menu_context" then
		if not LocalPlayer().c_InGame then return end
		if LocalPlayer():InVehicle() then return end

		worldInteractionState = not worldInteractionState
		if worldInteractionState then
			gui.EnableScreenClicker(true)

			AddGenericOptions()
		else
			EndWorldInteraction()
		end
	end
end
hook.Add("PlayerBindPress", "WorldInteraction.Toggle", ToggleWorldInteraction)

function AddWorldInteractionOption(text, func)
	table.insert(LocalPlayer().WorldInteractionList, {Title = text, Function = func})
end

function WorldInteraction(mc, aimvec)
	if not LocalPlayer().c_InGame then return end
	if LocalPlayer():InVehicle() then return end
	local ply = LocalPlayer()

	if mc == MOUSE_LEFT then
		if not ply.WorldInteractionEnt then
			local data = {}
				data.start = ply:GetShootPos()
				data.endpos = data.start + aimvec * 100
				data.filter = ply

			local tr = util.TraceLine(data)

			if tr.Entity:IsValid() then
				if tr.Entity.AddWorldInteractionOptions then
					--local dmenu = DermaMenu()

					ply.WorldInteractionEnt = tr.Entity
					tr.Entity:AddWorldInteractionOptions(aimvec)

				--	local norm = (tr.HitPos - data.start):GetNormalized()
				--	ply.WorldInteractionOptionsNorm = norm
				--	ply.WorldInteractionOptionsPos = tr.HitPos
					local scrn = tr.HitPos:ToScreen()

					for k, v in pairs(LocalPlayer().WorldInteractionList) do
						surface.SetFont("hidden14")
						local tw, th = surface.GetTextSize(v.Title)

						local button = vgui.Create("DButton")
							button:SetPos(ScrW() * 0.6, ScrH() * 0.5 + 30 * currentpos)
							button:SetSize(tw + 10, 30)
							button:SetText("")
							button.Text = v.Title
							button.Paint = function(btn, bw, bh)
								local col = Color(20, 20, 20, 150)
								if btn.Hovered then
									col = Color(20, 100, 20, 150)
								end
								--draw.RoundedBox(6, 0, 0, bw, bh, col)
								--draw.SlantedRectHorizOffset(0, 0, bw, bh, 5, col, Color(0, 0, 0, 255), 1, 1)
								draw.ElongatedHexagonHorizontalOffset(0, 0, bw - 1, bh - 1, 5, Color(0, 0, 0, 255), col, 1, 1)
								draw.SimpleText(v.Title, "hidden14", bw * 0.5, bh * 0.5, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end

							button.DoClick = function(btn)
								v:Function()

								EndWorldInteraction()

								gui.EnableScreenClicker(false)
							end

						table.insert(worldButtons, button)
						currentpos = currentpos + 1
					end
				elseif string.find(tr.Entity:GetClass(), "vehicle") then
					ply.WorldInteractionEnt = tr.Entity
					local screen = tr.HitPos:ToScreen()

					surface.SetFont("hidden14")
					local tw, th = surface.GetTextSize("To Inventory")

					local button = vgui.Create("DButton")
						button:SetPos(screen.x, screen.y + 32)
						button:SetSize(tw + 10, 30)
						button:SetText("")
						button.Text = "To Inventory"
						button.Paint = function(btn, bw, bh)
							local col = Color(20, 20, 20, 150)
							if btn.Hovered then
								col = Color(20, 100, 20, 150)
							end
							--draw.RoundedBox(6, 0, 0, bw, bh, col)
							--draw.SlantedRectHorizOffset(0, 0, bw, bh, 5, col, Color(0, 0, 0, 255), 1, 1)
							draw.ElongatedHexagonHorizontalOffset(0, 0, bw - 1, bh - 1, 5, Color(0, 0, 0, 255), col, 1, 1)
							draw.SimpleText("To Inventory", "hidden14", bw * 0.5, bh * 0.5, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end

						button.DoClick = function(btn)
							net.Start("vehToInventory")
							net.SendToServer()

							EndWorldInteraction()

							gui.EnableScreenClicker(false)
						end

					table.insert(worldButtons, button)
				end
			end
		else
			for k, v in pairs(worldButtons) do
				v:Remove()
				ply.WorldInteractionEnt = nil

				LocalPlayer().WorldInteractionEnt = nil
				LocalPlayer().WorldInteractionOptionsNorm = nil
				LocalPlayer().WorldInteractionOptionsPos = nil
				LocalPlayer().WorldInteractionList = {}
				LocalPlayer().WorldInteractionOptionsButtons = {}
			end
		end
	end
end
hook.Add("GUIMousePressed", "noxrp.WorldInteraction", WorldInteraction)

function GM:OnContextMenuClose()
end

--[[function UseWithWorld(pl, key)
	if key == IN_USE then
		if LocalPlayer().c_UsingWithWorld then
			LocalPlayer().c_UsingWithWorld = nil
		end
	end
end
hook.Add("KeyPress", "noxrp.UseWithWorld", UseWithWorld)]]