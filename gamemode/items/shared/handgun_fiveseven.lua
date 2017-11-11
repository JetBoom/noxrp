local ITEM = {}
ITEM.DataName = "handgun_fiveseven"
ITEM.Model = "models/weapons/w_pist_fiveseven.mdl"
ITEM.Name = "Five-Seven Handgun"
ITEM.ItemWeight = 8
ITEM.Weapon = "weapon_pistol_fiveseven"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 6
ITEM.ClipSize = 14
ITEM.NumShots = 2
ITEM.Delay = 0.18
ITEM.Cone = 0.8
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)