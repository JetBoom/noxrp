local ITEM = {}
ITEM.DataName = "sniper_awp"
ITEM.Model = "models/weapons/w_snip_awp.mdl"
ITEM.Name = "'AWP' Heavy Sniper"
ITEM.ItemWeight = 15
ITEM.Weapon = "weapon_sniper_awp"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 90
ITEM.ClipSize = 1
ITEM.NumShots = 1
ITEM.Delay = 2
ITEM.Cone = 0.05
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)