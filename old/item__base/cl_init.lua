include("shared.lua")
include("cl_props.lua")

ENT.Draw3DName = true
ENT.Name3DPos = Vector(0, 0, 20)

function ENT:Initialize()
	if self.PostClientInit then
		self:PostClientInit()
	end

	local gitem = ITEMS[self:GetBaseItem()]
	if gitem then
		if gitem.Weapon then
			local wepmdls = weapons.Get(gitem.Weapon)
			if wepmdls.WElements then
				self.WElements = table.Copy(wepmdls.WElements)
				self:CreateModels(self.WElements)
			end
		end
	end
end

function ENT:CLSetItemPrice()
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() * 0.4, ScrH() * 0.3)
	frame:SetSize(400, 80)
	frame:SetTitle("Set Sell Price")
	frame:ShowCloseButton(true)
	frame:MakePopup()

	local entry = vgui.Create("DTextEntry", frame)
		entry:Dock( TOP )
		entry:SetSize(75, 25)

	local setbtn = vgui.Create("DButton", frame)
	setbtn:SetPos(5, frame:GetTall() - 25)
	setbtn:SetSize(75, 20)
	setbtn:SetText("Set")
	setbtn.DoClick = function()
		RunConsoleCommand("noxrp_setsellitem", entry:GetValue())
		frame:Close()
	end
end

function ENT:CLTransferAmount()
	local frame = vgui.Create("DFrame")
		frame:SetSize(400, 100)
		frame:SetPos(ScrW() * 0.5 - 120, ScrH() * 0.5 - 50)
		--frame:SetTitle("Dropping "..ITEMS[item.Name].Name)
		frame:SetTitle("")
		frame:SetDeleteOnClose(true)
		frame:ShowCloseButton(false)
		frame:SetDraggable(true)
		frame:SetMouseInputEnabled(true)
		frame:MakePopup()
		frame.Paint = function(pnl, pw, ph)
			draw.SlantedRectHorizOffset(5, 5, pw - 4, 25, 2, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 2, 2)
			draw.SlantedRectHorizOffset(5, 30, pw - 4, ph - 30, 2, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 2, 2)

			draw.NoTexture()

			draw.SimpleText("Set Transfer Amount", "nulshock18", pw * 0.5, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end

		frame.DropAmount = 1

	local slider = vgui.Create("Slider", frame)
		slider:SetPos(15, 30)
		slider:SetSize(frame:GetWide() - 10, 30)
		slider:SetMin(1)
		slider:SetMax(20)
		slider:SetDecimals(0)
		slider:SetValue(1)
		slider.TextArea:SetTextColor(Color(255, 255, 255, 255))

	local setbtn = vgui.Create("DButton", frame)
		setbtn:SetPos(frame:GetWide() * 0.5 - 25, frame:GetTall() - 25)
		setbtn:SetSize(50, 20)
		setbtn:SetText("Set")
		setbtn.DoClick = function()
			RunConsoleCommand("container_transfer", slider:GetValue())
			frame:Close()
		end
		setbtn.Paint = function(btn, bw, bh)
			draw.SlantedRectHorizOffset(0, 0, bw, bh, 2, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 2, 2)
		end

		local cancelbtn = vgui.Create("DButton", frame)
		cancelbtn:SetText("X")
		cancelbtn:SetPos(frame:GetWide() - 25, 5)
		cancelbtn:SetSize(20, 25)
		cancelbtn:SetTextColor(Color(255, 255, 255))
		cancelbtn.DoClick = function(btn)
			frame:Close()
		end

		cancelbtn.Paint = function(btn, bw, bh)
			--draw.SlantedRectHorizOffset(0, 0, bw, bh, 4, Color(10, 10, 10, 200), Color(0, 0, 0, 255), 1, 1)
		end
end

function ENT:CLUseItemWith()
	local pl = LocalPlayer()

	if pl.ent_Use then
		if pl.ent_Use ~= self then
			RunConsoleCommand("noxrp_useworld", pl.ent_Use:EntIndex(), self:EntIndex())
			pl.ent_Use = nil
		else
			pl.ent_Use = nil
			GAMEMODE:AddLocalNotification("You can't use this with itself!", 4)
		end
	else
		pl.ent_Use = self
	end
end

function ENT:CLExamine()
	RunConsoleCommand("noxrp_examine", self:EntIndex())
end

function ENT:AddWorldInteractionOptions(dmenu)
	--[[if self:GetLockedDown() then
		dmenu:AddOption("Set Sell Price", function() self:CLSetItemPrice() end)
	end

	dmenu:AddOption("Use Item With", function() self:CLUseItemWith() end)
	dmenu:AddOption("Examine", function() self:CLExamine() end)]]

	table.insert(LocalPlayer().WorldInteractionList, {Title = "Examine", Function = function() self:CLExamine() end})
	table.insert(LocalPlayer().WorldInteractionList, {Title = "Use Item With", Function = function() self:CLUseItemWith() end})

	if self:GetLockedDown() then
		table.insert(LocalPlayer().WorldInteractionList, {Title = "Set Sell Price", Function = function() self:CLSetItemPrice() end})
	end

	if self.IsLiquidContainer then
		table.insert(LocalPlayer().WorldInteractionList, {Title = "Set Transfer Amount", Function = function() self:CLTransferAmount() end})
	end

	if self.AdditionalList then
		for _, item in pairs(self.AdditionalList) do
			table.insert(LocalPlayer().WorldInteractionList, {Title = item.Title, Function = item.Function})
		end
	end
end

function ENT:Draw()
--	local night = ents.FindByClass("time_night")[1]
--	if night then
--		self:SetColor(Color(50, 50, 50))
--	end

	--If an item wants to override how it draws everything, then let it do that
	if self.OverrideDraw then
		self:LocalDraw()
		return
	end

	if self.ShowWorldModel or self.ShowWorldModel == nil then
		self:DrawModel()
	end

	if self.LocalDraw then
		self:LocalDraw()
	end

	self:RenderModels()

	if EntityIsDrawn(self) then
		self:DrawOverheadName()
	end
end

local function DrawText(tab, i, top)
	surface.SetFont("Xolonium48")
	local tw, th = surface.GetTextSize(tab.Text)

	draw.RoundedBox(8, tw * -0.5 - 10, -50 - 110 * (top - i), tw + 20, 100, Color(0, 0, 0, tab.Alpha))

	local col = Color(255, 255, 255)
	if tab.Color then
		col = tab.Color
	end
	col.a = tab.Alpha
	draw.SimpleText(tab.Text, "Xolonium48", 0,  -110 * (top - i), col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function ENT:DrawOverheadName(alpha)
	alpha = alpha or 1

	local dist = self:GetPos():Distance(LocalPlayer():GetPos())
	if (dist - 100) > GetConVar("noxrp_radius3dtext"):GetInt() then
		alpha = 0
		return
	elseif dist > GetConVar("noxrp_radius3dtext"):GetInt() then
		alpha = math.Clamp(1 - (dist - GetConVar("noxrp_radius3dtext"):GetInt()) * 0.01, 0, 1)
	end

	--local tr = LocalPlayer():GetEyeTrace(200)


	local pos = self:GetPos() + self:GetRight() * self.Name3DPos.x + self:GetForward() * self.Name3DPos.y + Vector(0, 0, self.Name3DPos.z)
	--local pos = tr.HitPos - tr.Normal * 10 + self:GetRight() * self.Name3DPos.x + self:GetForward() * self.Name3DPos.y + Vector(0, 0, self.Name3DPos.z)
	local ang = Angle(180, EyeAngles().y + 90, EyeAngles().r - 90)
	if self.NoRotateForEyes then
		pos = self:GetPos() + self:GetRight() * self.Name3DPos.x + self:GetForward() * self.Name3DPos.y + self:GetUp() * self.Name3DPos.z
		ang = self:GetAngles()
		ang:RotateAroundAxis(self:GetUp(), self.Name3DAng.p)
		ang:RotateAroundAxis(self:GetRight(), self.Name3DAng.y)
		ang:RotateAroundAxis(self:GetForward(), self.Name3DAng.r)
	end

	local scale = self.Name3DScale or 0.03

	local name = self:GetDisplayName()
	local amt = self:GetItemCount()
	local sellprice = self:GetSellPrice()

	if amt > 1 then
		name = name.." [x"..self:GetItemCount().."]"
	end

	if LocalPlayer().ent_Use then
		if LocalPlayer().ent_Use == self then
			name = name.." [INTERACTING]"
		end
	end


	cam.Start3D2D(pos, ang, scale)
		surface.SetFont("hidden48")
		local tw, th = surface.GetTextSize(name)

		draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 - 5, tw + 10, th + 10, Color(20, 20, 20, 180 * alpha))

		local col = self.TextColor or Color(255, 255, 255)

		if self:GetTemporaryOwner():IsValid() then
			local tempowner = self:GetTemporaryOwner()
			local timel = self:GetTemporaryOwnedTime()

			if tempowner == LocalPlayer() then
				col = Color(100, 255, 100)

				local text = "[OWNED BY YOU FOR: "..tostring(math.Round(timel - CurTime(), 1)).."]"
				tw, th = surface.GetTextSize(text)

				draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 + 55, tw + 10, th + 10, Color(20, 20, 20, 180 * alpha))
				draw.SimpleText(text, "hidden48", 0, 60, Color(col.r, col.g, col.b, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				col = Color(255, 100, 100)

				local text = "[OWNED BY '"..tempowner:Nick().."' FOR: "..tostring(math.Round(timel - CurTime(), 1)).."]"
				tw, th = surface.GetTextSize(text)

				draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 + 55, tw + 10, th + 10, Color(20, 20, 20, 180 * alpha))
				draw.SimpleText(text, "hidden48", 0, 60, Color(col.r, col.g, col.b, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		draw.SimpleText(name, "hidden48", 0, 0, Color(col.r, col.g, col.b, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if sellprice ~= 0 then
			local str = "Price: "..sellprice
			local tw, th = surface.GetTextSize(str)

			draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 + 70, tw + 10, th + 10, Color(20, 20, 20, 180 * alpha))

			draw.SimpleText(str, "hidden48", 0, 75, Color(100, 255, 100, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()

	local ang = EyeAngles()

	local alltext = self:GetOverheadText()
	if #alltext > 0 then
		local height = Vector(0, 0, self:OBBMaxs().z + 10)
		cam.Start3D2D(self:GetPos() + height, Angle(180, ang.y + 90, -90), 0.05)
			for i, tab in pairs(alltext) do
				local top = #alltext
				if top > 5 then
					top = 5
					if i > (top - 5 ) then
						DrawText(tab, i, top)
					end
				else
					DrawText(tab, i, top)
				end
			end
		cam.End3D2D()
	end
end

local length = 200
local height = 20
function ENT:Display(alpha, posx, posy)
	draw.SimpleText(self:GetDisplayName(), "default", posx, posy, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function ENT:OnRemove()
	self:RemoveModels()
end

function ENT:Think()
	for i, tab in pairs(self:GetOverheadText()) do
		if tab.LifeTime < CurTime() then
			table.remove(self:GetOverheadText(), i)
			i = i - 1
		elseif tab.LifeTime <= CurTime() + 0.3 then
			tab.Alpha = math.max(tab.Alpha - 10, 0)
		end
	end
end