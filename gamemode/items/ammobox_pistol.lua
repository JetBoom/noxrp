ITEM.Base = "_base_ammobox"

ITEM.Name = "Pistol Ammo"
ITEM.Description = "A box of pistol ammo."
ITEM.Model = "models/Items/BoxSRounds.mdl"
ITEM.ItemWeight = 0.2

ITEM.BasePrice = 100

ITEM.AmmoType = "pistol"
ITEM.AmmoAmount = 24

if CLIENT then
ITEM.Name3DPos = Vector(0, 0, 20)

ITEM.InventoryCameraPos = Vector(0, 20, 5)
ITEM.InventoryCameraAng = Vector(0, 0, 5)
end
