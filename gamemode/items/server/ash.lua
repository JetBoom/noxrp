local ITEM = {}
ITEM.DataName = "ash"

function ITEM:OnBreatheIn(pl)
	pl:KnockDown(2)
end

RegisterItem(ITEM)