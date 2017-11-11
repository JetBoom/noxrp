local ITEM = {}
ITEM.DataName = "phosphorus"

function ITEM:OnBreatheIn(pl)
	pl:TakeDamage(1)
end

RegisterItem(ITEM)