local ITEM = {}
ITEM.DataName = "metal_iron"

ITEM.Description = "A chunk of refined iron."

--[[function ITEM:CustomExamine(panel, item)
	print("After: ", panel.IncrementHeight)
	
	local pnl = vgui.Create("DPanel", panel)
		pnl:SetPos(5, 200 + panel.IncrementHeight)
		pnl:SetSize(panel:GetWide() - 10, 40)
		pnl.Paint = function(pnl, pw, ph)
			draw.SlantedRectHorizOffset(0, 0, pw - 2, ph - 2, 0, Color(30, 30, 30, 250), Color(20, 20, 20, 255), 2, 2)
			
			draw.SlantedRectHorizOffset(5, 5, pw - 10, ph - 10, 0, Color(10, 10, 10, 250), Color(0, 0, 0, 255), 1, 1)
			draw.SlantedRectHorizOffset(6, 6, (pw - 12) * (item:GetData().Quality * 0.001), ph - 12, 0, Color(60, 60, 130, 250), Color(0, 0, 0, 255), 1, 1)
			
			draw.SimpleText("Item Quality: " .. item:GetData().Quality .. "/1000", "nulshock16", pw * 0.5, ph * 0.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	

	panel.IncrementHeight = panel.IncrementHeight + 50
	panel:SetTall(200 + panel.IncrementHeight)
end]]

RegisterItem(ITEM)