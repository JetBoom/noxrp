local ITEM = {}
ITEM.DataName = "handgun_deagle"
ITEM.Model = "models/weapons/w_pist_deagle.mdl"
ITEM.Name = "Desert Eagle"
ITEM.ItemWeight = 6
ITEM.Weapon = "weapon_pistol_deagle"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 21
ITEM.ClipSize = 7
ITEM.NumShots = 1
ITEM.Delay = 0.22
ITEM.Cone = 1.2
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)