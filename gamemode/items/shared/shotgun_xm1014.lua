local ITEM = {}
ITEM.DataName = "shotgun_xm1014"
ITEM.Model = "models/weapons/w_shot_xm1014.mdl"
ITEM.Name = "XM1014 Shotgun"
ITEM.ItemWeight = 15
ITEM.Weapon = "weapon_shotgun_xm1014"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 15
ITEM.ClipSize = 6
ITEM.NumShots = 6
ITEM.Delay = 0.5
ITEM.Cone = 1.5
ITEM.WeaponType = WEAPON_TYPE_GUN

ITEM.RestrictedChips = {"echip_rico"}

RegisterItem(ITEM)