local ITEM = {}
ITEM.DataName = "shovel"
ITEM.Model = "models/props_junk/Shovel01a.mdl"
ITEM.Name = "Shovel"
ITEM.ItemWeight = 1
ITEM.Weapon = "weapon_melee_shovel"
ITEM.Base = "_base"
ITEM.Category = "weapons"
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "Delay", "Range"}
ITEM.WeaponType = WEAPON_TYPE_MELEE
ITEM.Durability = true

ITEM.Damage = 11
ITEM.Delay = 0.8
ITEM.Range = 60

RegisterItem(ITEM)