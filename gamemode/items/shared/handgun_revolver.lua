local ITEM = {}
ITEM.DataName = "handgun_revolver"
ITEM.Model = "models/weapons/w_357.mdl"
ITEM.Name = "Magnum Revolver"
ITEM.ItemWeight = 10
ITEM.Weapon = "weapon_pistol_magnum"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 24
ITEM.ClipSize = 6
ITEM.NumShots = 1
ITEM.Delay = 0.4
ITEM.Cone = 0.5
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)