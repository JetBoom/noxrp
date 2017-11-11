mapedit = {}

local IsOpen = false
local CreatePos = Vector(0, 0, 0)

local function CreateEntity(entity)
	net.Start("createEntityDev")
		net.WriteTable(entity)
	net.SendToServer()
end

function mapedit.Open()
	if not LocalPlayer():IsSuperAdmin() then return end
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW()*0.4,ScrH()*0.3)
	frame:SetSize(400,300)
	frame:SetTitle("Create...")
	frame:ShowCloseButton(true)
	frame:MakePopup()

	IsOpen = frame
	CreatePos = LocalPlayer():GetEyeTrace(9999).HitPos

	frame.OnClose = function()
		IsOpen = false
	end

	local entitylisttxt = vgui.Create("DLabel", frame)
	entitylisttxt:SetText("Entity List")
	entitylisttxt:SetPos(5, 30)

	local combobox = vgui.Create("DComboBox", frame)
	combobox:SetPos(60, 30)
	combobox:SetSize(240, 20)

	for ent, vars in pairs(DEV_ENTITIES) do
		combobox:AddChoice(ent)
	end

	combobox.OnSelect = function(box, index, value, data)
		if frame.InfoPanel then
			for k,v in pairs(frame.InfoPanel:GetChildren()) do
				v:Remove()
			end
			frame.InfoPanel:Remove()
		end

		frame.InfoPanel = vgui.Create("DPanel", frame)
		frame.InfoPanel:SetPos(5, 60)
		frame.InfoPanel:SetSize(frame:GetWide() - 10, frame:GetTall() - 65)
		frame.Class = value

		for i, var in pairs(DEV_ENTITIES[value]) do
			local entry = vgui.Create("DTextEntry", frame.InfoPanel)
			entry:Dock( TOP )
			entry:SetSize(75, 25)
			entry:SetValue(var.Disp)
			entry.Var = i

			entry.OnGetFocus = function(txt)
				if txt:GetValue() == var.Disp then
					txt:SetValue("")
				end
			end

			entry.OnLoseFocus = function(txt)
				if txt:GetValue() == "" then
					txt:SetValue(var.Disp)
				end
			end
		end
	end

	local spawnbtn = vgui.Create("DButton", frame)
	spawnbtn:SetPos(310, 30)
	spawnbtn:SetSize(75, 20)
	spawnbtn:SetText("Spawn")
	spawnbtn.DoClick = function()
		local entity = {}
			entity.Type = combobox:GetValue()
			entity.Vars = {}

		for _,v in pairs(frame.InfoPanel:GetChildren()) do
			entity.Vars[v.Var] = v:GetValue()
		end
		CreateEntity(entity)
	end
end
concommand.Add("noxrp_dev_openmenu", mapedit.Open)

function mapedit.EditEntity()
	if not LocalPlayer():IsSuperAdmin() then return end

	local ent = LocalPlayer():GetEyeTrace(1000).Entity
	local HoloEntity = ClientsideModel(ent:GetModel(), RENDERGROUP_TRANSLUCENT)
		HoloEntity:SetPos(ent:GetPos())
		HoloEntity:SetAngles(ent:GetAngles())
		HoloEntity:SetColor(Color(255, 255, 255, 100))

	if not ent:IsValid() then return end
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() * 0.4,ScrH() * 0.3)
	frame:SetSize(400,400)
	frame:SetTitle("Editing Entity: "..ent:GetClass())
	frame:ShowCloseButton(true)
	frame:MakePopup()
	frame.OnRemove = function()
		HoloEntity:Remove()
		gui.EnableScreenClicker(false)
		--AdminMenu = false
	end

	local button = vgui.Create("DButton", frame)
		button:SetPos(5, frame:GetTall() - 30)
		button:SetSize(frame:GetWide() - 10, 25)
		button:SetText("Edit")
		button.DoClick = function()
			RunConsoleCommand("noxrp_dev_edititempos", frame.PosX, frame.PosY, frame.PosZ)
			RunConsoleCommand("noxrp_dev_edititemang", frame.Pitch, frame.Yaw, frame.Roll)
		end

	frame.Pitch = 0
	frame.Yaw = 0
	frame.Roll = 0

	frame.PosX = 0
	frame.PosY = 0
	frame.PosZ = 0

	--ANGLES
	local label = vgui.Create("DLabel", frame)
		label:SetPos(15, 30)
		label:SetText("Pitch: ")
	local slider1 = vgui.Create("Slider", frame)
		slider1:SetPos(15, 40)
		slider1:SetSize(frame:GetWide() - 10, 30)
		slider1:SetMin(-360)
		slider1:SetMax(360)
		slider1:SetDecimals(0)
		slider1:SetValue(0)
		slider1.OnValueChanged = function(sld, val)
			frame.Pitch = math.Round(val)
			HoloEntity:SetAngles(Angle(frame.Pitch, frame.Yaw, frame.Roll))
		end

	local label2 = vgui.Create("DLabel", frame)
		label2:SetPos(15, 70)
		label2:SetText("Yaw: ")
	local slider2 = vgui.Create("Slider", frame)
		slider2:SetPos(15, 80)
		slider2:SetSize(frame:GetWide() - 10, 30)
		slider2:SetMin(-360)
		slider2:SetMax(360)
		slider2:SetDecimals(0)
		slider2:SetValue(0)
		slider2.OnValueChanged = function(sld, val)
			frame.Yaw = math.Round(val)
			HoloEntity:SetAngles(Angle(frame.Pitch, frame.Yaw, frame.Roll))
		end

	local label3 = vgui.Create("DLabel", frame)
		label3:SetPos(15, 110)
		label3:SetText("Roll: ")
	local slider3 = vgui.Create("Slider", frame)
		slider3:SetPos(15, 120)
		slider3:SetSize(frame:GetWide() - 10, 30)
		slider3:SetMin(-360)
		slider3:SetMax(360)
		slider3:SetDecimals(0)
		slider3:SetValue(0)
		slider3.OnValueChanged = function(sld, val)
			frame.Pitch = math.Round(val)
			HoloEntity:SetAngles(Angle(frame.Pitch, frame.Yaw, frame.Roll))
		end


	--POSITION
	local labelx = vgui.Create("DLabel", frame)
		labelx:SetPos(15, 170)
		labelx:SetText("X: ")
	local sliderx = vgui.Create("Slider", frame)
		sliderx:SetPos(15, 180)
		sliderx:SetSize(frame:GetWide() - 10, 30)
		sliderx:SetMin(-200)
		sliderx:SetMax(200)
		sliderx:SetDecimals(0)
		sliderx:SetValue(0)
		sliderx.OnValueChanged = function(sld, val)
			frame.PosX = math.Round(val)
			HoloEntity:SetPos(ent:GetPos() + Vector(frame.PosX, frame.PosY, frame.PosZ))
		end

	local labely = vgui.Create("DLabel", frame)
		labely:SetPos(15, 210)
		labely:SetText("Y: ")
	local slidery = vgui.Create("Slider", frame)
		slidery:SetPos(15, 220)
		slidery:SetSize(frame:GetWide() - 10, 30)
		slidery:SetMin(-200)
		slidery:SetMax(200)
		slidery:SetDecimals(0)
		slidery:SetValue(0)
		slidery.OnValueChanged = function(sld, val)
			frame.PosY = math.Round(val)
			HoloEntity:SetPos(ent:GetPos() + Vector(frame.PosX, frame.PosY, frame.PosZ))
		end

	local labelz = vgui.Create("DLabel", frame)
		labelz:SetPos(15, 260)
		labelz:SetText("Z: ")
	local sliderz = vgui.Create("Slider", frame)
		sliderz:SetPos(15, 270)
		sliderz:SetSize(frame:GetWide() - 10, 30)
		sliderz:SetMin(-200)
		sliderz:SetMax(200)
		sliderz:SetDecimals(0)
		sliderz:SetValue(0)
		sliderz.OnValueChanged = function(sld, val)
			frame.PosZ = math.Round(val)
			HoloEntity:SetPos(ent:GetPos() + Vector(frame.PosX, frame.PosY, frame.PosZ))
		end
end

function mapedit.EditEntityValues()
	if not LocalPlayer():IsSuperAdmin() then return end

	local target = LocalPlayer():GetEyeTrace(1000).Entity

	if not target:IsValid() then return end
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() * 0.4,ScrH() * 0.3)
	frame:SetSize(400,400)
	frame:SetTitle("Editing Entity: "..target:GetClass())
	frame:ShowCloseButton(true)
	frame:MakePopup()
	frame.OnRemove = function()
		gui.EnableScreenClicker(false)
		--AdminMenu = false
	end

	local isvalid = false
	if DEV_EDIT[target:GetClass()] then
		isvalid = true
	end

	if not isvalid then frame:Remove() return end
	local combobox = vgui.Create("DComboBox", frame)
		combobox:SetPos(60, 30)
		combobox:SetSize(240, 20)

	for var, tab in pairs(DEV_EDIT[target:GetClass()]) do
		combobox:AddChoice(var)
	end
end

function DrawRadii()
	if IsOpen then
		if IsOpen.Class then
			for index, ref in pairs(DEV_ENTITIES[IsOpen.Class]) do
				if ref.DrawRadi then
					for _, pnl in pairs(IsOpen.InfoPanel:GetChildren()) do
						if pnl.Var == index then
							local size = tonumber(pnl:GetValue()) or 10

							render.DrawWireframeSphere(CreatePos, size, 12, 12, ref.RadiusColor, true)
						end
					end
				end
			end
		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "Dev.DrawRadii", DrawRadii)

local AdminMenu
local function OpenAdminMenu()
	if LocalPlayer():IsSuperAdmin() then
		if AdminMenu then
			AdminMenu:Remove()
			AdminMenu = nil
			gui.EnableScreenClicker(false)
		else
			gui.EnableScreenClicker(true)
			AdminMenu = DermaMenu()
				AdminMenu:AddOption("Admin Menu")
				AdminMenu:AddSpacer()
				local maplist = AdminMenu:AddSubMenu("NoXRP Functions")

					local ent = maplist:AddSubMenu("Map Edit")
						ent:AddOption("Spawn Entity", function() mapedit.Open() end):SetIcon("icon16/world.png")
						ent:AddOption("Edit Entity Position/Angles", function() mapedit.EditEntity() end):SetIcon("icon16/wrench.png")
						ent:AddOption("Edit Entity Values", function() mapedit.EditEntityValues() end):SetIcon("icon16/wrench.png")
						local items = ent:AddSubMenu("Give Item")
						for itemkey, item in pairs(ITEMS) do
							if not itemkey:find("__") and item.Name then
								local m = items:AddSubMenu(item.Name)
									m:AddOption("Give 1", function() RunConsoleCommand("noxrp_dev_giveitem", item.DataName, 1) end):SetIcon("icon16/wrench.png")
									m:AddOption("Give 2", function() RunConsoleCommand("noxrp_dev_giveitem", item.DataName, 2) end):SetIcon("icon16/wrench.png")
									m:AddOption("Give 5", function() RunConsoleCommand("noxrp_dev_giveitem", item.DataName, 5) end):SetIcon("icon16/wrench.png")
							end
						end
					local merch = maplist:AddSubMenu("Merchants")
						merch:AddOption("Set Merchant Title")
						merch:AddOption("Add Merchant Item")
						merch:AddOption("Remove Merchant Item")
				AdminMenu:Open()
		end
	end
end
concommand.Add("noxrp_admin", OpenAdminMenu)