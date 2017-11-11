local ITEM = {}
ITEM.DataName = "handgun_handwelder"
ITEM.Model = "models/weapons/w_pistol.mdl"
ITEM.Name = "Hand Welder"
ITEM.ItemWeight = 7
ITEM.Weapon = "weapon_pistol_handwelder"
ITEM.Base = "_base"
ITEM.Category = "weapons"
ITEM.Durability = true

ITEM.ClipSize = 100
ITEM.Delay = 0.05
ITEM.Cone = 0
ITEM.WeaponType = WEAPON_TYPE_GUN

RegisterItem(ITEM)