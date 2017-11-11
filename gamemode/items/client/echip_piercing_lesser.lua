local ITEM = {}
ITEM.DataName = "echip_pierce_less"
ITEM.Description = "A small chip that slightly increases the piercing power of bullets."
ITEM.AmmoLetter = "PP"
	
function ITEM:GetLetterColor()
	return Color(50 + 50 * math.cos(CurTime() * 5), 205 + 50 * math.cos(CurTime() * 5), 50 + 50 * math.cos(CurTime() * 5))
end

RegisterItem(ITEM)