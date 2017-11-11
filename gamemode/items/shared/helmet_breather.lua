local ITEM = {}
ITEM.DataName = "helmet_breather"
ITEM.Model = "models/props_c17/briefcase001a.mdl"
ITEM.Name = "'Breather' Helmet"
ITEM.ItemWeight = 2
ITEM.Base = "_base"
ITEM.Category = "armor"
ITEM.EquipCategory = EQUIP_ARMOR_HEAD
ITEM.BasePrice = 450
ITEM.Durability = true
ITEM.IsArmor = true

ITEM.ArmorBonus = {
	[REDUCTION_STAMINA] = 0.2
}

local HELMET = {}
HELMET.Name = "status_helmet_breather"
HELMET.Model = "models/gibs/strider_gib7.mdl"
HELMET.Bone = "ValveBiped.Bip01_Head1"
HELMET.Offset = Vector(2.2, 2.5, 0)
HELMET.Scale = 0.07
HELMET.Angle = Angle(0, 0, 90)

ITEM.Status = HELMET

RegisterItem(ITEM)
RegisterHelmet(HELMET)