local ITEM = {}
ITEM.DataName = "armor_heavy_rebel"
ITEM.Model = "models/props_c17/briefcase001a.mdl"
ITEM.Name = "Heavy Citizen Armor"
ITEM.ItemWeight = 15
ITEM.EquipCategory = EQUIP_ARMOR_BODY
ITEM.Category = ITEM_CAT_ARMOR
ITEM.Durability = true
ITEM.IsArmor = true

ITEM.ArmorBonus = {
	[DMG_BULLET] = 0.4,
	[DMG_SLASH] = 0.4,
	[DMG_CLUB] = 0.3,
	[REDUCTION_SPEED] = 0.2,
	[REDUCTION_STAMINA] = -0.5
}

function ITEM:GetPlayerModel(pl)
	return "models/player/urban.mdl"
end

RegisterItem(ITEM)