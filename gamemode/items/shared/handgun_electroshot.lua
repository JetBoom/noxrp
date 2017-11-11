local ITEM = {}
ITEM.DataName = "handgun_electroshot"
ITEM.Model = "models/weapons/w_pistol.mdl"
ITEM.Name = "Specialized Electric Handgun"
ITEM.ItemWeight = 7
ITEM.Weapon = "weapon_pistol_electroshot"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 7
ITEM.ClipSize = 14
ITEM.NumShots = 1
ITEM.Delay = 0.12
ITEM.Cone = 0.5
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)