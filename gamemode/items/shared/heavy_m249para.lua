local ITEM = {}
ITEM.DataName = "heavy_m249para"
ITEM.Model = "models/weapons/w_mach_m249para.mdl"
ITEM.Name = "'Para' LMG"
ITEM.ItemWeight = 10
ITEM.Weapon = "weapon_heavy_m249para"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay"}

ITEM.Damage = 9
ITEM.ClipSize = 100
ITEM.NumShots = 1
ITEM.Delay = 0.07
ITEM.Cone = 2.5
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)