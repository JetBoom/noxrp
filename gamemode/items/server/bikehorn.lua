local ITEM = {}
ITEM.DataName = "bikehorn"

function ITEM:ItemUse(pl)
	pl:EmitSound("noxrp/bikehorn.ogg", 100, math.random(80, 110))
end

RegisterItem(ITEM)