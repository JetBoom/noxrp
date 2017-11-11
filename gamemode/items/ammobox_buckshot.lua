ITEM.Base = "_base_ammobox"

ITEM.Name = "Buckshot Ammo"
ITEM.Description = "A box of buckshot"
ITEM.Model = "models/Items/BoxBuckshot.mdl"
ITEM.ItemWeight = 0.2

ITEM.BasePrice = 100

ITEM.AmmoType = "buckshot"
ITEM.AmmoAmount = 12

if CLIENT then
ITEM.InventoryCameraPos = Vector(0, 15, 5)
ITEM.InventoryCameraAng = Vector(0, 0, 5)

ITEM.ExamineCameraPos = Vector(0, 60, 5)
ITEM.ExamineCameraAng = Vector(0, 0, 6)
end
