local ITEM = {}
ITEM.DataName = "smg_ump"
ITEM.Model = "models/weapons/w_smg_ump45.mdl"
ITEM.Name = "UMP SMG"
ITEM.ItemWeight = 13
ITEM.Weapon = "weapon_smg_ump"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 10
ITEM.ClipSize = 22
ITEM.NumShots = 1
ITEM.Delay = 0.15
ITEM.Cone = 1
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)