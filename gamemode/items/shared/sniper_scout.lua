local ITEM = {}
ITEM.DataName = "sniper_scout"
ITEM.Model = "models/weapons/w_snip_scout.mdl"
ITEM.Name = "'Scout' Light Sniper"
ITEM.ItemWeight = 16
ITEM.Weapon = "weapon_sniper_scout"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 32
ITEM.ClipSize = 5
ITEM.NumShots = 1
ITEM.Delay = 1.5
ITEM.Cone = 0.002
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)