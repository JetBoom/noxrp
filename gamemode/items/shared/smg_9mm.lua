local ITEM = {}
ITEM.DataName = "smg_9mm"
ITEM.Model = "models/weapons/w_smg1.mdl"
ITEM.Name = "Combine-Issue Submachine Gun"
ITEM.ItemWeight = 12
ITEM.Weapon = "weapon_smg_9mm"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 8
ITEM.ClipSize = 25
ITEM.NumShots = 1
ITEM.Delay = 0.1
ITEM.Cone = 1.4
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)