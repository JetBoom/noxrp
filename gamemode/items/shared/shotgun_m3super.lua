local ITEM = {}
ITEM.DataName = "shotgun_m3super"
ITEM.Model = "models/weapons/w_shot_m3super90.mdl"
ITEM.Name = "M3 Super 90"
ITEM.ItemWeight = 15
ITEM.Weapon = "weapon_shotgun_m3super"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 20
ITEM.ClipSize = 6
ITEM.NumShots = 6
ITEM.Delay = 0.8
ITEM.Cone = 3.5
ITEM.WeaponType = WEAPON_TYPE_GUN

ITEM.RestrictedChips = {"echip_rico"}

RegisterItem(ITEM)