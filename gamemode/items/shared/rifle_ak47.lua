local ITEM = {}
ITEM.DataName = "rifle_ak47"
ITEM.Model = "models/weapons/w_rif_ak47.mdl"
ITEM.Name = "AK47"
ITEM.ItemWeight = 9
ITEM.Weapon = "weapon_rifle_ak47"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}
ITEM.BasePrice = 1000
ITEM.Base = "gun__base"

ITEM.Damage = 18
ITEM.ClipSize = 30
ITEM.NumShots = 1
ITEM.Delay = 0.15
ITEM.Cone = 0.3
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)