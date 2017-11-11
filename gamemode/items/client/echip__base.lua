local ITEM = {}
ITEM.DataName = "echip__base"

ITEM.Description = ""
ITEM.ToolTip = ""
	
ITEM.Draw3DName = true
ITEM.Name3DPos = Vector(0, 0, 20)
	
ITEM.AmmoLetter = "B"
	
ITEM.InventoryCameraPos = Vector(0, 10, 0)
	
function ITEM:GetLetterColor()
	return Color(30 + 20 * math.cos(CurTime() * 5), 100 + 50 * math.cos(CurTime() * 5), 200  + 55 * math.cos(CurTime() * 5))
end

RegisterItem(ITEM)