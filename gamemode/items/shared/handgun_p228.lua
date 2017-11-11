local ITEM = {}
ITEM.DataName = "handgun_p228"
ITEM.Model = "models/weapons/w_pist_p228.mdl"
ITEM.Name = "SIG P228"
ITEM.ItemWeight = 8
ITEM.Weapon = "weapon_pistol_p228"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 13
ITEM.ClipSize = 15
ITEM.NumShots = 1
ITEM.Delay = 0.18
ITEM.Cone = 0.8
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)