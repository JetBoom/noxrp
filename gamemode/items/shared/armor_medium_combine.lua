local ITEM = {}
ITEM.DataName = "armor_medium_combine"
ITEM.Model = "models/props_c17/briefcase001a.mdl"
ITEM.Name = "Medium Combine Armor"
ITEM.ItemWeight = 10
ITEM.Base = "armor_light_combine"
ITEM.Durability = true
ITEM.EquipCategory = EQUIP_ARMOR_BODY
ITEM.Category = ITEM_CAT_ARMOR
ITEM.BasePrice = 450
ITEM.IsArmor = true

ITEM.ArmorBonus = {
	[DMG_BULLET] = 0.15,
	[REDUCTION_SPEED] = 0.1
}

function ITEM:GetPlayerModel()
	return "models/player/combine_soldier.mdl"
end

RegisterItem(ITEM)