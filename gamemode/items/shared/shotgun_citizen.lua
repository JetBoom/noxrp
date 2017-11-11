local ITEM = {}
ITEM.DataName = "shotgun_citizen"
ITEM.Model = "models/weapons/w_shotgun.mdl"
ITEM.Name = "Citizen Shotgun"
ITEM.ItemWeight = 12
ITEM.Weapon = "weapon_shotgun_citizen"
ITEM.Base = "gun__base"
ITEM.Category = "weapons"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone"}

ITEM.Damage = 9
ITEM.ClipSize = 6
ITEM.NumShots = 6
ITEM.Delay = 0.75
ITEM.Cone = 5
ITEM.WeaponType = WEAPON_TYPE_GUN

ITEM.RestrictedChips = {"echip_rico"}

RegisterItem(ITEM)