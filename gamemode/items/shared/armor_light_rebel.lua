local ITEM = {}
ITEM.DataName = "armor_light_rebel"
ITEM.Model = "models/props_c17/briefcase001a.mdl"
ITEM.Name = "Light Citizen Armor"
ITEM.ItemWeight = 6
ITEM.Durability = true
ITEM.EquipCategory = EQUIP_ARMOR_BODY
ITEM.Category = ITEM_CAT_ARMOR
ITEM.IsArmor = true

ITEM.ArmorBonus = {
	[DMG_BULLET] = 0.15,
	[REDUCTION_SPEED] = 0.05
}

//This is mostly why we store their original model
function ITEM:GetPlayerModel(pl, overWrite)
	return string.Replace(overWrite or pl:GetModel(), "group01", "group03")
end

RegisterItem(ITEM)