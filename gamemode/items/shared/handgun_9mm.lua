local ITEM = {}
ITEM.DataName = "handgun_9mm"
ITEM.Model = "models/weapons/w_pistol.mdl"
ITEM.Name = "Combine-Issue Handgun"
ITEM.ItemWeight = 6
ITEM.Weapon = "weapon_pistol_9mm"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 10
ITEM.ClipSize = 12
ITEM.NumShots = 1
ITEM.Delay = 0.18
ITEM.Cone = 0.8
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)