ITEM.Base = "_base_ammobox"

ITEM.Name = "SMG Ammo"
ITEM.Description = "A box of smg ammo."
ITEM.Model = "models/Items/BoxMRounds.mdl"
ITEM.ItemWeight = 0.2

ITEM.AmmoType = "smg1"
ITEM.AmmoAmount = 30

if CLIENT then
ITEM.Name3DPos = Vector(0, 0, 20)

ITEM.InventoryCameraPos = Vector(0, 30, 20)

ITEM.ExamineCameraPos = Vector(0, 80, 5)
ITEM.ExamineCameraAng = Vector(0, 0, 5)
end
