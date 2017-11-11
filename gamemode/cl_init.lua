include("shared.lua")
include("cl_inventory.lua")
include("cl_net.lua")
include("obj_extend_player_cl.lua")
include("cl_targetid.lua")
include("cl_draw_custom.lua")
include("cl_skills.lua")
include("cl_scoreboard.lua")
include("cl_chat.lua")
include("cl_dermaskin.lua")
include("inventory/cl_trading.lua")
include("cl_worldinteraction.lua")

--include("weathersystem/cl_weather.lua")

include("areas/cl_management.lua")
include("cl_crafting.lua")

include("sh_skillnotes.lua")

include("saveload/sh_accountvars.lua")
include("saveload/sh_charactervars.lua")

include("vgui/ditempanel.lua")
include("vgui/ditempanelsimple.lua")
include("vgui/dinventory.lua")
include("vgui/dequipment.lua")
include("vgui/dinventorycontainer.lua")
include("vgui/ditempanelother.lua")
include("vgui/dnotification.lua")
include("vgui/dcharactermenu.lua")
include("vgui/dskill.lua")
include("vgui/dcraftingmenu.lua")
include("vgui/ditempanelcrafting.lua")
include("vgui/dhelpmenu.lua")
include("vgui/dmainmenu.lua")
include("vgui/dmainmenubtn.lua")
include("vgui/drecipelist.lua")
include("vgui/dcharacterinfo.lua")
include("vgui/dupdates.lua")
include("vgui/doptions.lua")
include("vgui/dnotices.lua")
include("vgui/dexamineitem.lua")

include("vgui/dinventorymerchant.lua")
include("vgui/ditempanelmerchant.lua")
include("vgui/ditempanelmerchant_pl.lua")

include("vgui/ncchatbox.lua")
include("vgui/dskillpanel.lua")

include("animationsapi/cl_boneanimlib.lua")
include("animationsapi/cl_animeditor.lua")

include("saveload/cl_charactermenu.lua")

include("dev/cl_devmode.lua")
include("dev/sh_devmode.lua")

--TODO: Fix up this clusterfuck of fonts

surface.CreateFont( "hidden48", {font = "hidden", size = 48, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden32", {font = "hidden", size = 32, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden28", {font = "hidden", size = 28, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden24", {font = "hidden", size = 24, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden18", {font = "hidden", size = 18, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden16", {font = "hidden", size = 16, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden14_ns", {font = "hidden", size = 14, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = false,} )
surface.CreateFont( "hidden14", {font = "hidden", size = 14, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden12", {font = "hidden", size = 12, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden10", {font = "hidden", size = 10, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "hidden8", {font = "hidden", size = 8, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )

surface.CreateFont( "neuropol22", {font = "Neuropol", size = 22, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "neuropol18", {font = "Neuropol", size = 18, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "neuropol16", {font = "Neuropol", size = 16, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "neuropol14", {font = "Neuropol", size = 14, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )

surface.CreateFont( "nulshock38", {font = "Nulshock Rg", size = 38, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "nulshock32", {font = "Nulshock Rg", size = 32, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "nulshock26", {font = "Nulshock Rg", size = 26, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "nulshock22", {font = "Nulshock Rg", size = 22, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "nulshock18", {font = "Nulshock Rg", size = 18, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "nulshock16", {font = "Nulshock Rg", size = 16, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )
surface.CreateFont( "nulshock14", {font = "Nulshock Rg", size = 14, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = true,} )

surface.CreateFont( "Xolonium48", {font = "Xolonium", size = 48, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = false} )
surface.CreateFont( "Xolonium18", {font = "Xolonium", size = 18, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = false} )
surface.CreateFont( "Xolonium16", {font = "Xolonium", size = 16, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = false} )
surface.CreateFont( "Xolonium14", {font = "Xolonium", size = 14, weight = 500, blursize = 0, scanlines = 0, antialias = true, shadow = false} )

surface.CreateFont( "dmKillIcons_S", {font = "HL2MP",size = 32,weight = 500,antialias = true,additive=true})
surface.CreateFont( "csKillIcons_S", {font = "csd",size = 32,weight = 500,antialias = true,additive=true})
surface.CreateFont( "HL2Icons_S", {font = "HalfLife2",size = 32,weight = 500,antialias = true,additive=true})

surface.CreateFont( "dmKillIcons_M", {font = "HL2MP",size = 48,weight = 500,antialias = true,additive=true})
surface.CreateFont( "csKillIcons_M", {font = "csd",size = 48,weight = 500,antialias = true,additive=true})
surface.CreateFont( "HL2Icons_M", {font = "HalfLife2",size = 48,weight = 500,antialias = true,additive=true})

surface.CreateFont( "dmKillIcons_Hud", {font = "HL2MPTypeDeath",size = 78,weight = 500,antialias = true,additive=true})
surface.CreateFont( "csKillIcons_Hud", {font = "csd",size = 78,weight = 500,antialias = true,additive=true})
surface.CreateFont( "HL2Icons_Hud", {font = "HalfLife2",size = 78,weight = 500,antialias = true,additive=true})

surface.CreateFont( "dmKillIcons_HudL", {font = "HL2MPTypeDeath",size = 64,weight = 500,antialias = true,additive=true})
surface.CreateFont( "csKillIcons_HudL", {font = "csd",size = 64,weight = 500,antialias = true,additive=true})
surface.CreateFont( "csKillIcons_HudL_NA", {font = "csd",size = 64,weight = 500,antialias = true,additive=true})
surface.CreateFont( "HL2Icons_HudL", {font = "HalfLife2",size = 64,weight = 500,antialias = true,additive=true})
surface.CreateFont( "HL2Icons_HudL_NA", {font = "HalfLife2",size = 64,weight = 500,antialias = true,additive=false})

GM.RainEffect = false

local weaponfade = 0
local lastkeypress = 0

HealthLerp = 0
--local HealthFadeTime = 0
local HealthAlpha = 0

StamLerp = 0
--local StamFadeTime = 0
local StamAlpha = 0

local DeathTime = 0
local StartDeathTimer = false

function GM:Initialize()
end

function GM:AddDeathNotice() end
function GM:DrawDeathNotice() end

hook.Add("Think", "InitializeClient", function()
	local ply = LocalPlayer()
	if ply:IsValid() then
		ply.FirstPerson = false
		ply.VehicleViewFirst = false

		--[[if not ply.c_Inventory then
			local tab = Item(nil, "container_playerinventory")
			tab.IsContainer = true

			ply.c_Inventory = tab
		end]]
		ply.c_Stamina = ply.c_Stamina or 70
		ply.c_MaxStamina = ply.c_MaxStamina or 70
		ply.c_BreathLevel = ply.c_BreathLevel or 100
		ply.c_Notifications = {}
		ply.t_ItemNotifications = {}
		ply.c_WeaponSelection = {}
		ply.c_Stats = ply.c_Stats or {}
		ply.c_Equipment = ply.c_Equipment or {}
		ply.c_SortedWeaponTable = {}
		ply.WorldInteractionList = ply.WorldInteractionList or {}

		ply.c_GlobalText = {}

		if ply:Team() ~= 1 then
			ply.c_InGame = false
			GAMEMODE:OpenCharacterMenu()
			OnJoin()
		end

		hook.Remove("Think", "InitializeClient")
	end
end)

--Told by the server when to call this function. Really only sets up more variables.
function GM:OnInitialSpawn()
	if GetConVar("noxrp_lastviewedupdate"):GetInt() < NoXRP_TotalUpdates then
		chat.AddText(Color(100, 200, 255), "There has been a new update!")
	end

	if GetConVar("noxrp_viewedhelp"):GetInt() == 0 then
		chat.AddText(Color(100, 255, 100), "Hey, you look new! Press F1 and press the help button to open up the help menu!")
	end

	for k, v in pairs(ents.FindByClass("item_*")) do
		if v.GetBaseItem then
			local gitem = ITEMS[v:GetBaseItem()]
			if gitem then
				if gitem.Weapon then
					local wepmdls = weapons.Get(gitem.Weapon)
					if wepmdls.WElements then
						v.WElements = table.Copy(wepmdls.WElements)
						v:CreateModels(v.WElements)
					end
				end
			end
		end
	end
end

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudCrosshair"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudDamageIndicator"] = true,
	["CHudZoom"] = true,
	["CHudWeaponSelection"] = true
}
function GM:HUDShouldDraw(name)
	return not hide[name]
end

function GM:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return math.max(100, 520 - pl:GetVelocity():Length())
	end

	if iType == STEPSOUNDTIME_ON_LADDER then
		return 500
	end

	if iType == STEPSOUNDTIME_WATER_KNEE then
		return 650
	end

	return 350
end

function GM:CalcView(ply, pos, angles, fov)
	local view = {}
	local ragdoll = ply:GetRagdollEntity()

	if not ply:Alive() and ragdoll then
		if ragdoll:IsValid() then
			local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))

			view.origin = att.Pos
			view.angles = att.Ang
			view.fov = fov
		end
	else
		if ply:IsKnockedDown() and ragdoll then
			local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))
			view.origin = att.Pos
			view.angles = att.Ang
			view.fov = fov
		elseif ply:InVehicle() then
			--[[local att = ply:GetAttachment(ply:LookupAttachment("eyes"))
			local veh = ply:GetVehicle()]]

			if ply:GetVehicle():GetVehicleParent():IsValid() then
				local tab = ply:GetVehicle():GetVehicleParent():GetViewTable(ply, pos, angles, fov)
				return tab
			end
		elseif LocalPlayer():GetActiveWeapon().ForceThirdPerson then
			view.origin = pos - angles:Forward() * 50 + angles:Right() * 8
			view.angles = angles
			view.fov = fov
		else
			view.origin = pos
			view.angles = angles
			view.fov = fov
		end
	end

	return view
end

function GM:ShouldDrawLocalPlayer(ply)
	local wep = LocalPlayer():GetActiveWeapon()

	if wep:IsValid() then
		if wep.ForceThirdPerson then return true end
	end

	if LocalPlayer():InVehicle() then return not ply.VehicleViewFirst end

	return LocalPlayer():IsKnockedDown()
end

local function SortWeapons(a, b)
	return a and b and a.Slot and b.Slot and a.Slot < b.Slot
end

function RefreshWeapons(ply)
	ply = ply or LocalPlayer()
	local weps = ply:GetWeapons()

	table.Empty(ply.c_SortedWeaponTable)
	for k, v in pairs(weps) do
		table.insert(ply.c_SortedWeaponTable, v)
	end

	table.sort(ply.c_SortedWeaponTable, SortWeapons)
end

function SelectWeapon(ply, bind, wasin)
	local weps = ply:GetWeapons()
	local slot = string.Left(bind, 4)

	if #weps > 0 then
		local activewep = ply:GetActiveWeapon()
		RefreshWeapons(ply)

		if slot == "slot" then
			lastkeypress = CurTime()
			surface.PlaySound("common/wpn_moveselect.wav")
			weaponfade = 1

			local slotnum = tonumber(string.Right(bind, 1))
			RunConsoleCommand("select", slotnum)
		elseif bind == "invnext" then
			lastkeypress = CurTime()
			surface.PlaySound("common/wpn_moveselect.wav")
			weaponfade = 1

			local nextslot = 10
			local lowestslot = 10
			for _, wep in pairs(weps) do
				if wep ~= ply:GetActiveWeapon() then
					if wep.Slot < lowestslot then
						lowestslot = wep.Slot
					end

					if wep.Slot >= activewep.Slot and wep.Slot <= nextslot then
						nextslot = wep.Slot
					end
				end
			end

			if nextslot == 10 then
				nextslot = 1
			end

			RunConsoleCommand("select", nextslot)
		elseif bind == "invprev" then
			lastkeypress = CurTime()
			surface.PlaySound("common/wpn_moveselect.wav")
			weaponfade = 1

			local nextslot = 0
			local highest = 0
			for _, wep in pairs(weps) do
				if wep ~= activewep then
					if wep.Slot > highest then
						highest = wep.Slot
					end

					if wep.Slot <= activewep.Slot and wep.Slot >= nextslot then
						nextslot = wep.Slot
					end
				end
			end

			if nextslot == 0 then
				nextslot = highest
			end

			RunConsoleCommand("select", nextslot)
		end
	end
end
hook.Add("PlayerBindPress", "SelectWeapon", SelectWeapon)

local function FadeWeaponDraw()
	if (lastkeypress + 2 < CurTime()) and weaponfade > 0 then
		weaponfade = math.Approach(weaponfade, 0, FrameTime())
	end
end
hook.Add("Think", "FadeWeaponSelect", FadeWeaponDraw)

local colModDead = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
function GM:RenderScreenspaceEffects()
	local ply = LocalPlayer()
	if ply:Team() ~= TEAM_UNASSIGNED and ply:Alive() then
		local tab = {}

		if GetConVar("noxrp_enablecolor"):GetBool() then
			if GAMEMODE.RainEffect then
				tab[ "$pp_colour_addr" ] = 0
				tab[ "$pp_colour_addg" ] = 0
				tab[ "$pp_colour_addb" ] = 0
				tab[ "$pp_colour_brightness" ] = 0
				tab[ "$pp_colour_contrast" ] = 0.9
				tab[ "$pp_colour_colour" ] = 1
				tab[ "$pp_colour_mulr" ] = 0
				tab[ "$pp_colour_mulg" ] = 0
				tab[ "$pp_colour_mulb" ] = 0
			else
				tab[ "$pp_colour_addr" ] = 0
				tab[ "$pp_colour_addg" ] = 0
				tab[ "$pp_colour_addb" ] = 0
				tab[ "$pp_colour_brightness" ] = 0
				tab[ "$pp_colour_contrast" ] = 1

				for _, ent in pairs(ents.FindInSphere(LocalPlayer():EyePos(), 150)) do
					if ent:GetClass() == "point_smoke" then
						tab[ "$pp_colour_brightness" ] = -0.4 + 0.4 * math.Clamp((ent:GetPos():Distance(LocalPlayer():GetPos()) / 150), 0, 1)
						break
					end
				end

				local health = HealthLerp
				if health <= 30 then
					tab[ "$pp_colour_colour" ] = 0.5 + 0.5 * (health / 30)
				else
					tab[ "$pp_colour_colour" ] = 1
				end

				tab[ "$pp_colour_mulr" ] = 0
				tab[ "$pp_colour_mulg" ] = 0
				tab[ "$pp_colour_mulb" ] = 0
			end

			DrawColorModify( tab )

			if GetConVar("noxrp_enablebloom"):GetBool() then
				DrawBloom( 0.8, 1, 9, 9, 1, 1, 1, 1, 1 )
			end
		end
	else
		DrawColorModify(colModDead)
	end
end

local centergradient = surface.GetTextureID("gui/center_gradient")
local gradient = surface.GetTextureID("gui/gradient")

local HintIcon1 = Material("icon16/information.png")
local HintIcon2 = Material("icon16/cancel.png")
function GM:DrawNotifications()
	local ypos = ScrH() - 5
	local xpos = ScrW() * 0.5

	for k, v in pairs(LocalPlayer().c_Notifications) do
		if v.time > CurTime() then
			if v.time <= CurTime() + 0.3 then
				v.alpha = math.max(v.alpha - 10, 0)
			elseif v.alpha < 255 then
				v.alpha = math.min(v.alpha + 10, 255)
			end

			local text = v.text
			if v.stacks > 1 then
				text = text.." [x"..v.stacks.."]"
			end

			surface.SetFont(v.font)
			local tw, th = surface.GetTextSize(text)

			ypos = ypos - th - 5

			surface.SetTexture(centergradient)
			surface.SetDrawColor(0, 0, 0, v.alpha)
			surface.DrawTexturedRect(xpos - tw, ypos, v.sizex * 2, v.sizey)

			local col = Color(v.color.r, v.color.g, v.color.b, v.alpha)

			draw.DrawText(text, v.font, xpos, ypos + 1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if v.hint > 0 then
				if v.hint == 1 then
					surface.SetMaterial(HintIcon1)
				elseif v.hint == 2 then
					surface.SetMaterial(HintIcon2)
				end
				surface.SetDrawColor(255, 255, 255, 255)

				surface.DrawTexturedRect(xpos + tw * 0.5 + 10, ypos + 3, 16, 16)
				surface.DrawTexturedRect(xpos - tw * 0.5 - 26, ypos + 3, 16, 16)
			end
		end
	end
end

local function NotificationThink()
	for k, v in pairs(LocalPlayer().c_Notifications) do
		if v.time < CurTime() then
			table.remove(LocalPlayer().c_Notifications, k)
			k = k - 1
		end
	end
end
hook.Add("Think","Notifications.Think", NotificationThink)

local NextStamRegen = 0
--This is the client prediction for the stamina. The server sends the server value when the player stops sprinting or runs out of stamina
local function ClientStamPredict()
	local ply = LocalPlayer()
	if not ply.c_InGame then return end
	if ply:IsSprinting() and ply:GetVelocity():Length2D() > 30 then
		if not ply:Crouching() then
			if ply:GetStamina() > 0 then
				if NextStamRegen < CurTime() then
					NextStamRegen = CurTime() + 0.2

					ply:AddStamina(-1)
				end
			end
		end
	else
		if ply:GetStamina() < ply:GetMaxStamina() then
			if NextStamRegen < CurTime() then
				NextStamRegen = CurTime() + ply:GetCachedStamRegen()

				ply:AddStamina(1)
			end
		end
	end
end
hook.Add("Think", "Stamina.ClientPrediction", ClientStamPredict)

local gradleft = surface.GetTextureID("noxrp/gradient_left")
function GM:DrawHUDHealth()
	local ply = LocalPlayer()

	if StamLerp == ply:GetMaxStamina() and StamAlpha == 0 and HealthLerp == ply:GetMaxHealth() and HealthLerp == 0 then return end

	local health = ply:Health()
	local maxhealth = ply:GetMaxHealth()

	local stam = ply:GetStamina()
	local maxstam = ply:GetMaxStamina()

	local w = ScrW()
	local h = ScrH()

	local hptextcol = Color(220, 20, 20, 255)
	local hpbarcol = Color(255, 20, 20, 170)
	--local stamcol = Color(180, 180, 20)

	if StamLerp ~= stam then
		StamLerp = math.Approach(StamLerp, stam, FrameTime() * 80)
		if StamLerp > stam then
			stamcol = Color(240, 240, 200, 220)
		elseif StamLerp == stam then
			StamAlpha = 1
		end
	end

	if HealthLerp ~= health then
		HealthLerp = math.Approach(HealthLerp, health, FrameTime() * 60)

		--If we lost health, then change the health color
		if HealthLerp > health then
			hpbarcol = Color(240, 220, 220, 220)
		elseif HealthLerp == health then
			HealthAlpha = 1
		end
	end

	if HealthLerp <= maxhealth * 0.3 then
		local rate = 1 - (HealthLerp / (maxhealth * 0.3))

		hpbarcol = Color(255, 100 + 100 * math.cos(CurTime() * rate * 15), 100 + 100 * math.cos(CurTime() * rate * 15), 170)
	end

	if not GetConVar("noxrp_drawhud"):GetBool() then return end

	--local hei = 35
	local ypos = h * 0.97

	--local scale = 247 / maxhealth

	local hpper = math.Clamp(HealthLerp / maxhealth, 0, 1)

	if HealthLerp < maxhealth then
		surface.SetDrawColor(0, 0, 0, 250)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, ypos - 60, 300, 30)

		--draw.ElongatedHexagonHorizontalOffset(10, h - 70, 70, 60, 10, Color(0, 0, 0, 200), Color(0, 0, 0, 200), 1, 1)
		draw.SlantedRectHoriz(73, ypos - 53, 250, 15, -18, Color(20, 20, 20, 170), Color(0, 0, 0, 220))

		if HealthLerp < health then
			draw.SlantedRectHoriz(74, ypos - 52, math.max(248 * hpper, 0), 13, -18, hpbarcol, Color(0, 0, 0, 220))
		else
			draw.SlantedRectHoriz(74, ypos - 52, math.max(248 * hpper, 6), 13, -18, hpbarcol, Color(0, 0, 0, 220))
		end

		draw.SimpleText(health.."/"..maxhealth, "nulshock18", 37, ypos - 45, hptextcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		HealthAlpha = math.Approach(HealthAlpha, 0, FrameTime())

		surface.SetDrawColor(0, 0, 0, 250 * HealthAlpha)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, ypos - 60, 300, 30)

		if HealthAlpha > 0 then --fading out
			--draw.ElongatedHexagonHorizontalOffset(10, h - 70, 70, 60, 10, Color(0, 0, 0, 255 * HealthAlpha), Color(20, 20, 20, 200 * HealthAlpha), 1, 1)

			draw.SlantedRectHoriz(74, ypos - 52, math.max(248 * hpper, 6), 13, -18, Color(255, 20, 20, 170 * HealthAlpha), Color(0, 0, 0, 220 * HealthAlpha))
			draw.SlantedRectHoriz(74, ypos - 52, math.max(248 * hpper, 6), 13, -18, Color(255, 20, 20, 170 * HealthAlpha), Color(0, 0, 0, 220 * HealthAlpha))

			draw.SimpleText(health.."/"..maxhealth, "nulshock18", 37, ypos - 45, Color(255, 20, 20, 255 * HealthAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local stampos = 5
	local stamlength = 261
	local per = (StamLerp / maxstam)
	--local str = math.Round((stam / maxstam) * 100)

	if StamLerp < maxstam then
		surface.SetDrawColor(0, 0, 0, 250)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, ypos - 30, 300, 30)

		draw.SlantedRectHoriz(stampos, ypos - 23, stamlength + 2, 15, 18, Color(20, 20, 20, 170), Color(0, 0, 0, 220))
		draw.SlantedRectHoriz(stampos + 1, ypos - 22, math.max(stamlength * per, 6), 13, 18, Color(250, 250, 20, 170), Color(0, 0, 0, 220))

		draw.SimpleText(stam.."/"..maxstam, "nulshock18", stamlength + 40, ypos - 5, Color(250, 250, 20, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	elseif StamAlpha > 0 then
		StamAlpha = math.Approach(StamAlpha, 0, FrameTime())

		surface.SetDrawColor(0, 0, 0, 250 * StamAlpha)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, ypos - 30, 300, 30)

		draw.SlantedRectHoriz(stampos, ypos - 23, stamlength + 2, 15, 18, Color(20, 20, 20, 170 * StamAlpha), Color(0, 0, 0, 220 * StamAlpha))
		draw.SlantedRectHoriz(stampos + 1, ypos - 22, math.max(stamlength * per, 6), 13, 18, Color(250, 250, 20, 170 * StamAlpha), Color(0, 0, 0, 220 * StamAlpha))

		draw.SimpleText(stam.."/"..maxstam, "nulshock18", stamlength + 40, ypos - 5, Color(250, 250, 20, 255 * StamAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end

	if LocalPlayer().c_UsingWithWorld then
		draw.SimpleText("[USING ITEM WITH WORLD]", "hidden16", w * 0.5, ypos * 0.5 + 40, Color(100, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

--This way we can just add them here and only work about local statuses as opposed to getting every single active status in the game and checking if we're their owner
local statuses = {}
function AddLocalStatus(ent)
	table.insert(statuses, ent)
end

function RemoveLocalStatus(ent)
	for index, entity in pairs(statuses) do
		if entity == ent then
			table.remove(statuses, index)
		end
	end
end

function ClearLocalStatus()
	table.Empty(statuses)
end

function GM:DrawHUDStatuses()
	if not GetConVar("noxrp_drawhud"):GetBool() then return end

	local ply = LocalPlayer()

	--local w = ScrW()
	local h = ScrH()

	if #statuses > 0 then
		local baseheight = h - 80

		if ply.c_BreathLevel < 100 then
			baseheight = baseheight - 40
		end

		if HealthAlpha > 0 or HealthLerp < ply:GetMaxHealth() then
			baseheight = baseheight - 80
		elseif StamAlpha > 0 or StamLerp < ply:GetMaxStamina()  then
			baseheight = baseheight - 40
		end

		local nexty = -40
		local nextx = 0
		--local total = #statuses
		for k, v in pairs(statuses) do
			if v:GetClass() == "status_equipping" then
				v:PanelDraw(20, baseheight + nexty)
				nexty = nexty - 40
			else
				if v.PanelDraw then
					v:PanelDraw(20 + nextx, baseheight)

					nextx = nextx + 40
				end

				if v.DrawHud then
					v:DrawHud()
				end
			end
		end
	end
end

function GM:DrawHUDBreath()
	if not GetConVar("noxrp_drawhud"):GetBool() then return end
	local ply = LocalPlayer()

	local breath = ply.c_BreathLevel
	local breathpos = ScrH() - 36

	if breath < 100 then
		draw.SlantedRectHoriz(5, breathpos, 300, 10, -18, Color(20, 20, 20, 170), Color(0, 0, 0, 220))
		draw.SlantedRectHoriz(6, breathpos + 1, 298 * (breath * 0.01), 8, -18, Color(0, 100, 255, 255), Color(0, 0, 0, 220))
	end
end

function GM:HUDWeaponPickedUp()
end


function GM:DrawHUDWeapons()
	if not GetConVar("noxrp_drawhud"):GetBool() or worldInteractionState or weaponfade <= 0 then return end

	local ply = LocalPlayer()
	local w = ScrW()
	local h = ScrH()

	local wepypos = h - 400
	local weps = ply.c_SortedWeaponTable
	local curwep = ply:GetActiveWeapon()

	local gap = 40

	surface.SetTexture(gradleft)
	surface.SetDrawColor(0, 0, 0, 250 * weaponfade)
	surface.DrawTexturedRect(w - 140, wepypos - 15, 140, gap * #weps)

	draw.NoTexture()
	for k, v in pairs(weps) do
		local slotcol = Color(50, 150, 255, 255 * weaponfade)

		if v.Slot == curwep.Slot then
			slotcol = Color(255, 255, 255, 255 * weaponfade)
		end

		draw.SimpleText(v.PrintName, "hidden18", w - 100, wepypos + gap * (k - 1), slotcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(v.Slot, "hidden18", w - 10, wepypos + gap * (k - 1), slotcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		if (v.Font and v.Icon) and not v.NoIcon then
			draw.SimpleText(v.Icon, v.Font.."_M", w - 25 + (v.HUDPosX or 0), wepypos + gap * (k - 1) + (v.HUDPosY or 0), slotcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end
end

function GM:DrawPartyInfo()
	if not GetConVar("noxrp_drawhud"):GetBool() then return end

	local ply = LocalPlayer()
	local posx = 0
	local posy = ScrH() * 0.1

	local tab = {}
	tab = table.Copy(ply:GetParty().Members)
	table.insert(tab, ply:GetParty().Leader)

	for index, pl in pairs(tab) do
		if pl ~= LocalPlayer() and pl:IsValid() then
			local pos = posy + 55 * (index - 1)
			local hp = pl:Health()
			local maxhp = pl:GetMaxHealth()

			surface.SetTexture(gradient)
			surface.SetDrawColor(Color(0, 0, 0, 180))
			surface.DrawTexturedRect(posx, pos, 300, 50)

			draw.SimpleText(pl:Nick(), "hidden18", posx + 5, pos + 5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

			surface.SetDrawColor(Color(0, 0, 0, 180))
			surface.DrawRect(posx + 5, pos + 30, 200, 10)

			surface.SetDrawColor(Color(255, 30, 30, 180))
			surface.DrawRect(posx + 6, pos + 31, 198 * (hp / maxhp), 8)

			draw.SimpleText(hp.."/"..maxhp, "hidden14", posx + 210, pos + 25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
	end
end

function DeathThink()
	if not LocalPlayer():Alive() and not StartDeathTimer then
		StartDeathTimer = true
	--	DeathTime = CurTime() + 15
		DeathTime = CurTime() + 2
	elseif LocalPlayer():Alive() and StartDeathTimer then
		StartDeathTimer = false
	end
end
hook.Add("Think", "Death.ThinkTimer", DeathThink)

function DrawHUDDeathTime()
	local startdeath = DeathTime - 15
	local ct = CurTime()

	local timet = math.max(math.Round(15 - (ct - startdeath), 1), 0)
	draw.SimpleText("You are dead.", "hidden16", ScrW() * 0.5, ScrH() * 0.6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if timet > 0 then
		draw.SimpleText(timet, "hidden16", ScrW() * 0.5, ScrH() * 0.65, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("Press a key to respawn.", "hidden16", ScrW() * 0.5, ScrH() * 0.65, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

local function ItemHUDThink()
	local ply = LocalPlayer()
	local armor = ply:GetEquipmentSlot(EQUIP_ARMOR_BODY)
	if armor then
		armor = ply:GetItemByID(armor)
		if armor and armor.ThinkHud then
			armor:ThinkHud()
		end
	end
end
hook.Add("Think", "Item.HUDThink", ItemHUDThink)

function MainHUDPaint()
	local ply = LocalPlayer()
	if ply.c_InventoryPanel or ply:Team() == TEAM_UNASSIGNED then return end

	if not ply:Alive() then
		local armor = ply:GetEquipmentSlot(EQUIP_ARMOR_BODY)
		if armor then
			armor = ply:GetItemByID(armor)
			if armor and armor.DrawDeathHud then
				armor:DrawDeathHud()
			end
		end

		DrawHUDDeathTime()
		GAMEMODE:DrawNotifications()

		return
	end

	local wep = ply:GetActiveWeapon()
	if wep:IsValid() and wep.GetZoomed and wep:GetZoomed() then return end

	local armor = ply:GetEquipmentSlot(EQUIP_ARMOR_BODY)
	if armor then
		armor = ply:GetItemByID(armor)
		if armor and armor.DrawHud then
			armor:DrawHud()
		end
	end

	GAMEMODE:DrawHUDHealth()

	GAMEMODE:DrawHUDWeapons()

	GAMEMODE:DrawHUDBreath()

	GAMEMODE:DrawHUDStatuses()

	GAMEMODE:DrawNotifications()

	--[[if not LocalPlayer().IsCrafting then
		GAMEMODE:DrawCursor()
	end]]

	if ply:InParty() then
		GAMEMODE:DrawPartyInfo()
	end

	if ply:GetVehicle():IsValid() then
		local veh = ply:GetVehicle()
		if veh:GetVehicleParent().DrawOnHUD then
			veh:GetVehicleParent():DrawOnHUD()
		end
	end
end
hook.Add("HUDPaint","MainHudPaint",MainHUDPaint)

local function insertLocalNotification(text, dietime, color, hint, font, newline)
	if font == nil or font == "" then
		font = "Xolonium16"
	end

	if newline == 0 then
		for _, note in pairs(LocalPlayer().c_Notifications) do
			if note.text == text then
				note.stacks = note.stacks + 1
				note.time = note.time + dietime or 4
				note.alpha = 255

				return
			end
		end
	end

	surface.SetFont(font)
	local tsizex, tsizey = surface.GetTextSize(text)

	local note = {}
		note.alpha = 0
		note.text = text or ""
		note.time = CurTime() + (dietime or 3)
		note.sizey = tsizey + 4
		note.sizex = tsizex
		note.font = font
		note.color = color or Color(255, 255, 255)
		note.hint = hint or 0
		note.stacks = 1

	table.insert(LocalPlayer().c_Notifications, 1, note)
end

function GM:AddLocalNotification(...)
	if not LocalPlayer():IsValid() then return end

	insertLocalNotification(...)
end

local function AddNotification()
	if not LocalPlayer():IsValid() then return end
	if not LocalPlayer().c_Notifications then LocalPlayer().c_Notifications = {} end

	local text = net.ReadString()
	local dietime = net.ReadInt(8)
	local tblcol = net.ReadTable()
	local color = Color(tblcol.r, tblcol.g, tblcol.b)

	local sound = net.ReadString()

	if sound ~= "" then
		surface.PlaySound(sound)
	end

	local hint = net.ReadInt(4)
	local font = net.ReadString()
	local newline = net.ReadBit() or 0

	insertLocalNotification(text, dietime, color, hint, font, newline)
end
net.Receive("addNotification", AddNotification)

function OpenFilteredCrafting(filter)
	if #GetOpenedVGUIElements() > 0 then return end

	local m = vgui.Create("dCraftingMenu")
	m.SFilter = filter
	m:SetupInventory()

	AddOpenedVGUIElement(m)
end

function ToggleF1Menu()
	if not LocalPlayer().c_InGame then return end

	if not LocalPlayer().v_MainMenu then
		LocalPlayer().v_MainMenu = vgui.Create("dMainMenu")
	else
		LocalPlayer().v_MainMenu:DoRemove()
	end
end

function GM:HUDItemPickedUp()
end

function GM:HUDAmmoPickedUp()
end

--[[local matBeam = Material("effects/spark")
function DrawRain()
	local rain = ents.FindByClass("weather_rain")[1]
	if rain then
		render.SetMaterial(matBeam)
		local _w, _h = ScrW(), ScrH()
		for _, raindrop in pairs(rain.RainDrops) do
			local toscreen = raindrop.Pos:ToScreen()
			if toscreen.x > 0 and toscreen.x < _w and toscreen.y > 0 and toscreen.y < _h then
				local data = {}
					data.start = raindrop.Pos
					data.endpos = data.start - Vector(0, 0, 10)

				local tr = util.TraceLine(data)

				if not tr.Hit then
					render.DrawBeam(raindrop.Pos, raindrop.Pos + Vector(0, 0, 30), 6, 1, 0, Color(120, 120, 140))
				end
			end
		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "noxrp.DrawRain", DrawRain)]]

--function DrawItemNames()
	--self:DrawOverheadName()
--[[	for _, item in pairs(ents.FindInSphere(LocalPlayer():GetPos(), GetConVar("noxrp_radius3dtext"):GetInt() + 100)) do
		if string.find(item:GetClass(), "item_") then
			if item.DrawOverheadName then
				item:DrawOverheadName()
			end]]
		--gotta love lack of clientside functions for nextbot
--[[		elseif item:GetClass() == "npc_merchant" then
			local ang = EyeAngles()
			local pos = item:GetPos() + Vector(0, 0, 75)

			cam.Start3D2D(pos, Angle(180, ang.y + 90, -90), 0.03)
				draw.RoundedBox(8, -400, -50, 800, 100, Color(0, 0, 0, 200))
				draw.SimpleText(item:GetDTString(0), "hidden48", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end]]
--end
--hook.Add("PostDrawOpaqueRenderables", "noxrp.DrawItems", DrawItemNames)

--either something fucked up or ragdolls won't disappear on npcs/nextbots
--hacky method

local ragdolls = {}
function ClearRagdolls()
	--"class C_ClientRagdoll"
	for k, v in pairs(ragdolls) do
		if v.DieTime < CurTime() then
			v:Remove()

			table.remove(ragdolls, k)
		end
	end
end
hook.Add("Think", "noxrp.ClearRagdolls", ClearRagdolls)

function CheckRagdolls(ent)
	if ent:GetClass() == "class C_ClientRagdoll" then
		ent.DieTime = CurTime() + GetConVar("noxrp_ragdoll_deathtime"):GetFloat()
		table.insert(ragdolls, ent)
	end
end
hook.Add("OnEntityCreated", "noxrp.CheckRagdolls", CheckRagdolls)

function ToggleVehicleView(ply, key)
	if ply:InVehicle() then
		if key == IN_DUCK then
			ply.VehicleViewFirst = not ply.VehicleViewFirst
		end
	end
end
hook.Add("KeyPress", "noxrp.ClientToggleVehicleView", ToggleVehicleView)


local vguiElements = {}
function AddOpenedVGUIElement(item)
	table.insert(vguiElements, item)

	gui.EnableScreenClicker(true)

	worldInteractionState = true
end

function RemoveVGUIElement(item)
	local removes = {}
	for index, v in pairs(vguiElements) do
		if v == item or not IsValid(v) then
			table.insert(removes, index)
		end
	end

	for i = 1, #removes do
		table.remove(vguiElements, i)
		i = i - 1
	end

	if #vguiElements == 0 and LocalPlayer():Team() ~= TEAM_UNASSIGNED then
		gui.EnableScreenClicker(false)

		worldInteractionState = false
		EndWorldInteraction()
	end
end

function GetOpenedVGUIElements()
	return vguiElements
end

function EmptyVGUIElements()
	table.Empty(vguiElements)
end
