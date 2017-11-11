local ITEM = {}
ITEM.DataName = "rifle_sg550"
ITEM.Model = "models/weapons/w_snip_sg550.mdl"
ITEM.Name = "'SG550' Rifle"
ITEM.ItemWeight = 15
ITEM.Weapon = "weapon_rifle_sg550"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 16
ITEM.ClipSize = 20
ITEM.NumShots = 1
ITEM.Delay = 0.08
ITEM.Cone = 0.5
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)