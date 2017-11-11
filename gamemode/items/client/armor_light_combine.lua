local ITEM = {}
ITEM.DataName = "armor_light_combine"

ITEM.Description = "A light armor commonly used by Metrocops."
ITEM.Draw3DName = true
	
local overlay = Material("noxrp/combine_binocoverlay.png")
local alphaflash = 0
local flashfade = false
local flashing = true

local drawInit = false
local drawInitTime = 0
	
function ITEM:SetupHud()
	alphaflash = 0
	flashfade = false
	flashing = true
		
	drawInit = true
	drawInitTime = 1
end
	
function ITEM:ThinkHud()
	if flashing then
		if not flashfade then
			if alphaflash < 1 then
				alphaflash = math.Approach(alphaflash, 1, FrameTime() * 4)
			else
				flashfade = true
			end
		else
			if alphaflash > 0.01 then
				alphaflash = math.Approach(alphaflash, 0.01, FrameTime() * 4)
			else
				flashing = false
			end
		end
	end
		
	if drawInit then
		if drawInitTime == 0 then
			drawInit = false
		else
			drawInitTime = math.Approach(drawInitTime, 0, FrameTime() * 0.4)
		end
	end
end
	
local alert = 0
local alertIcon = Material("sprites/glow04_noz")
local overlay2 = surface.GetTextureID("effects/combine_binocoverlay.vtf")
function ITEM:DrawHud()
	local col
		
	if HealthLerp > LocalPlayer():Health() then
		alert = 1
		col = Color(255, 100, 100, 60)
	else	
		if alert > 0 then
			alert = math.Approach(alert, 0, FrameTime() * 0.6)
			col = Color(255, 255 - 155 * alert, 255 - 155 * alert, 5 + 30 * alert)
		else
			col = Color(255, 255, 255, 0)
		end
	end
		
	if LocalPlayer():Health() <= LocalPlayer():GetMaxHealth() * 0.25 then
		col = Color(255, 50, 50, 10)
	end
		
	surface.SetMaterial(overlay)
	if flashing then
		surface.SetDrawColor(col.r, col.g, col.b, 100 * alphaflash)
	else
		surface.SetDrawColor(col.r, col.g, col.b, col.a or 0)
	end
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		
	if drawInit then
		draw.SimpleText("..//..INITIALIZING..//..", "nulshock32", ScrW() * 0.5, ScrH() * 0.2, Color(255, 255, 255, 255 * drawInitTime), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("..//..HEALTH DISPLAY..//..", "nulshock26", ScrW() * 0.5, ScrH() * 0.2 + 35, Color(255, 255, 255, 255 * drawInitTime), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("..//..REACTIVE ARMOR..//..", "nulshock26", ScrW() * 0.5, ScrH() * 0.2 + 55, Color(255, 255, 255, 255 * drawInitTime), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end
	
function ITEM:DrawDeathHud()
	surface.SetMaterial(overlay)
	surface.SetDrawColor(255, 0, 0, 100)
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end

RegisterItem(ITEM)