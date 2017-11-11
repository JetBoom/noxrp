local ITEM = {}
ITEM.DataName = "handgun_usp"
ITEM.Model = "models/weapons/w_pist_usp.mdl"
ITEM.Name = "USP Handgun"
ITEM.ItemWeight = 7
ITEM.Weapon = "weapon_pistol_usp"
ITEM.Base = "gun__base"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 8
ITEM.ClipSize = 12
ITEM.NumShots = 1
ITEM.Delay = 0.19
ITEM.Cone = 0.4
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)