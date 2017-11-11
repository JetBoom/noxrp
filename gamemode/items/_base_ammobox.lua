ITEM.ItemWeight = 0.2

ITEM.Category = ITEM_CAT_AMMO

ITEM.Usable = true
ITEM.DestroyOnUse = true

ITEM.AmmoType = "buckshot"
ITEM.AmmoAmount = 1

if SERVER then
function ITEM:ItemUse(pl)
	pl:GiveAmmo(self.AmmoAmount, self.AmmoType, true)
	return true
end
end
