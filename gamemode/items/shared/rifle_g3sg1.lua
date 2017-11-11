local ITEM = {}
ITEM.DataName = "rifle_g3sg1"
ITEM.Model = "models/weapons/w_snip_g3sg1.mdl"
ITEM.Name = "'G3SG1' Rifle"
ITEM.ItemWeight = 13
ITEM.Weapon = "weapon_rifle_g3sg1"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 22
ITEM.ClipSize = 20
ITEM.NumShots = 1
ITEM.Delay = 0.18
ITEM.Cone = 0.5
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)