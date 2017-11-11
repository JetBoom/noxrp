local ITEM = {}
ITEM.DataName = "armor_light_combine"
ITEM.Model = "models/props_c17/briefcase001a.mdl"
ITEM.Name = "Light Metrocop Armor"
ITEM.ItemWeight = 5
ITEM.Durability = true
ITEM.EquipCategory = EQUIP_ARMOR_BODY
ITEM.Category = ITEM_CAT_ARMOR
ITEM.IsArmor = true

ITEM.ArmorBonus = {
	[DMG_BULLET] = 0.1,
	[DMG_SLASH] = 0.1,
	[DMG_CLUB] = 0.1,
	[REDUCTION_SPEED] = 0.15
}

function ITEM:GetPlayerModel(pl)
	--local mdl = pl:GetModel()
	--if string.find(mdl, "female") or string.find(pl:GetModel(), "alyx") or string.find(pl:GetModel(), "mossman_arctic") then
	--	return "models/player/fempolice.mdl"
	--else
		return "models/player/police.mdl"
	--end
end

RegisterItem(ITEM)