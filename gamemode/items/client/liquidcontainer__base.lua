local ITEM = {}
ITEM.DataName = "liquidcontainer__base"
ITEM.Description = "CONTAINER_BASE"
	
function ITEM:AddInteractOptions(menu, ent)
	local sub = menu:AddSubMenu("Set Transfer Amount:")
		sub:AddOption("1 unit", function() RunConsoleCommand("container_transfer", 1) end)
		sub:AddOption("5 units", function() RunConsoleCommand("container_transfer", 5) end)
		sub:AddOption("10 units", function() RunConsoleCommand("container_transfer", 10) end)
		sub:AddOption("20 units", function() RunConsoleCommand("container_transfer", 20) end)
end

function ITEM:AddOptionsUse(menu, panel)
	if #panel.Item:GetContainer() > 0 then
		menu:AddOption("Empty Container", function()
			RunConsoleCommand("emptyitem", panel.Item:GetIDRef())
		end):SetIcon("icon16/water.png")
	end
end

RegisterItem(ITEM)