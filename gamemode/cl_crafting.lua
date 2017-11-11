local CRAFTFAILED = false
local CRAFTSUCCEEDED = false
local CRAFTFINISH = 0
local CRAFTSTART = 0
local CRAFT_STARTED = false
local CRAFT_RECIPE = ""

//ITEM CRAFTING SECTION
local CRAFTKEYS = {}

//The translations from the IN_ enums to text to display
local TranslateKey = {
	[IN_FORWARD] = "/\\",
	[IN_BACK] = "\\/",
	[IN_MOVELEFT] = "<",
	[IN_MOVERIGHT] = ">"
}

local nextmove = 0

//Net receiver for starting the DDR game.
function StartCraftingDDR()
	CRAFTKEYS = net.ReadTable()
	CRAFTSTART = net.ReadFloat()
	nextmove = 0
	
	if CRAFT_STARTED then CRAFT_STARTED = false end
	
	local w = ScrW()
	
	LocalPlayer().IsCrafting = true
	LocalPlayer().StartCrafting = CurTime()
	
	hook.Add("Think", "Crafting.ThinkDDR", CraftKeyThinkDDR)
	hook.Add("HUDPaint", "Crafting.DrawHUDDDR", DrawCraftHUDDDR)
end
net.Receive("craftBeginDDR", StartCraftingDDR)

//Net receiver for ending the ddr game
function EndCraftingDDR()
	LocalPlayer().IsCrafting = false
	LocalPlayer().StartCrafting = nil
	
	local result = net.ReadBit()
	if result == 1 then
		CRAFTSUCCEEDED = true
	else
		CRAFTFAILED = true
	end
	
	CRAFTFINISH = CurTime() + 4
end
net.Receive("craftEndDDR", EndCraftingDDR)


function CraftKeySuccessDDR()
	CRAFTKEYS = net.ReadTable()
	nextmove = CurTime()
	
	local w = ScrW()
end
net.Receive("craftKeySuccessDDR", CraftKeySuccessDDR)

function CraftKeyUpdateDDR()
	local key = net.ReadFloat()
	
	CRAFTKEYS[1].Posx = key
	
	for index, key in pairs(CRAFTKEYS) do
		if index > 1 then
			key.Posx = CRAFTKEYS[1].Posx + key.MoveDistance * (index - 1)
		end
	end
	
end
net.Receive("craftKeyUpdateDDR", CraftKeyUpdateDDR)

function DrawCraftHUDDDR()
	local _w, _h = ScrW(), ScrH()

	if LocalPlayer().IsCrafting then
		draw.RoundedBox(4, _w * 0.5 - 20, _h * 0.5 - 20, 40, 40, Color(20, 20, 20, 200))
		draw.RoundedBox(4, _w * 0.5 - 22, _h * 0.5 - 22, 44, 44, Color(20, 20, 20, 150))
			
		for _, key in pairs(CRAFTKEYS) do
			draw.RoundedBox(4, _w * 0.5 + key.Posx - 20, _h * 0.5 - 20, 40, 40, Color(20, 20, 20, 200))
			draw.RoundedBox(4, _w * 0.5 + key.Posx - 22, _h * 0.5 - 22, 44, 44, Color(20, 20, 20, 150))
					
				--	draw.SlantedRectHoriz(posx, _h * 0.5 - 20, 40, 40, 0, Color(40, 40, 40, 200), Color(0, 0, 0, 255))
			draw.SimpleText(TranslateKey[key.Key], "Xolonium14", _w * 0.5 + key.Posx, _h * 0.5, Color(50, 255, 50, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	elseif CRAFTSUCCEEDED then
		local _w, _h = ScrW(), ScrH()
		
		draw.SimpleText("Craft Succeeded!", "hidden18", _w * 0.5, _h * 0.5 - 100, Color(50, 255, 50, 150 + 100 * math.cos(CurTime() * 8)), TEXT_ALIGN_CENTER)
	elseif CRAFTFAILED then
		local _w, _h = ScrW(), ScrH()
		
		draw.SimpleText("Craft Failed!", "hidden18", _w * 0.5, _h * 0.5 - 100, Color(255, 50, 50, 150 + 100 * math.cos(CurTime() * 8)), TEXT_ALIGN_CENTER)
	end
end


//Really need to work on getting this prediction better.
function CraftKeyThinkDDR()
	local w = ScrW()
	local h = ScrH()
	
	if CRAFTSTART < CurTime() then
		if LocalPlayer().IsCrafting then
		//	if nextmove < CurTime() then
		//		nextmove = CurTime() + CRAFTKEYS[1].MoveTime
				
				if #CRAFTKEYS > 0 then
					for _, key in pairs(CRAFTKEYS) do
						key.Posx = key.Posx - key.MoveSpeed * FrameTime()
					end
				end
		//	end
		elseif CRAFTFINISH < CurTime() and (CRAFTFAILED or CRAFTSUCCEEDED) then
			CRAFTSUCCEEDED = false
			CRAFTFAILED = false
				
			CRAFTFINISH = 0
			
			CRAFT_STARTED = false
				
			hook.Remove("Think", "Crafting.ThinkDDR")
			hook.Remove("HUDPaint", "Crafting.DrawHUDDDR")
		end
	end
end