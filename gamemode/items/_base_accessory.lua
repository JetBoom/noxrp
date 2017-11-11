ITEM.ItemWeight = 1

ITEM.Equipable = true
ITEM.EquipCategory = EQUIP_ARMOR_ACCESSORY
ITEM.Category = ITEM_CAT_ARMOR
ITEM.ArmorBonus = {
	[DMG_BURN] = 1,
	[REDUCTION_SPEED] = 1
}

ITEM.Description = "BASE ACCESSORY"

function ITEM:GetTooltip()
	local str = ""

	for stat, val in pairs(ITEM.ArmorBonus) do
		if val > 0 then
			str = str..DAMAGETYPE_TRANSLATE[stat]..": +"..tostring(val * 100).."%\n"
		else
			str = str..DAMAGETYPE_TRANSLATE[stat]..": -"..tostring(val * 100).."%\n"
		end
	end

	return str
end
