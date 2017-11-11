local ITEM = {}
ITEM.DataName = "handgun_glock18"
ITEM.Model = "models/weapons/w_cstm_glock18.mdl"
ITEM.Name = "'Glock 18' Handgun"
ITEM.ItemWeight = 7
ITEM.Weapon = "weapon_pistol_glock18"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 8
ITEM.ClipSize = 20
ITEM.NumShots = 1
ITEM.Delay = 0.11
ITEM.Cone = 1
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)