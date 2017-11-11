local ITEM = {}
ITEM.DataName = "smg_mp5"
ITEM.Model = "models/weapons/w_smg_mp5.mdl"
ITEM.Name = "MP5"
ITEM.ItemWeight = 13
ITEM.Weapon = "weapon_smg_mp5"
ITEM.Base = "gun__base"
ITEM.Category = ITEM_CAT_WEAPONS
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 12
ITEM.ClipSize = 30
ITEM.NumShots = 1
ITEM.Delay = 0.11
ITEM.Cone = 1.2
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)