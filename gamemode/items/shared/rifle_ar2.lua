local ITEM = {}
ITEM.DataName = "rifle_ar2"
ITEM.Model = "models/weapons/w_irifle.mdl"
ITEM.Name = "Combine Issue AR2"
ITEM.ItemWeight = 9
ITEM.Weapon = "weapon_rifle_ar2"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}
ITEM.BasePrice = 1000
ITEM.Base = "gun__base"

ITEM.Damage = 12
ITEM.ClipSize = 20
ITEM.NumShots = 1
ITEM.Delay = 0.12
ITEM.Cone = 0.5
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)