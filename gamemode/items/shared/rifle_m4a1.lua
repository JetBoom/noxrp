local ITEM = {}
ITEM.DataName = "rifle_m4a1"
ITEM.Model = "models/weapons/w_rif_m4a1.mdl"
ITEM.Name = "M4A1 Assault Rifle"
ITEM.ItemWeight = 8
ITEM.Weapon = "weapon_rifle_m4a1"
ITEM.Durability = true
ITEM.Mutatable = true
ITEM.MutatableList = {"ItemWeight", "Damage", "ClipSize", "NumShots", "Cone", "Delay", "Recoil"}
ITEM.Base = "gun__base"

ITEM.Damage = 14
ITEM.ClipSize = 24
ITEM.NumShots = 1
ITEM.Delay = 0.17
ITEM.Cone = 1
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)