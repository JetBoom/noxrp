local ITEM = {}
ITEM.DataName = "heavy_grenadelauncher"
ITEM.Model = "models/weapons/w_rocket_launcher.mdl"
ITEM.Name = "'Harbinger' Grenade Launcher"
ITEM.ItemWeight = 1
ITEM.Weapon = "weapon_heavy_grenadelauncher"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true

ITEM.Damage = 50
ITEM.ClipSize = 4
ITEM.NumShots = 1
ITEM.Delay = 0.5
ITEM.Cone = 5

ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)