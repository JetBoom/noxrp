local ITEM = {}
ITEM.DataName = "item__base"

--EQUIPMENT: Called when the player equips this item
function ITEM:OnEquip(pl)
end

--EQUIPMENT: Called when the player unequips this item
function ITEM:OnUnEquip(pl)
end

--Called when the player uses this item from their inventory
function ITEM:ItemUse(pl)
end

--Called from the entity item__base.
--This sets up local variables for the entity so that it can
--do think functions with instance variables
function ITEM:SetupLocalVars()
end

--Called from the entity item__base.
--This is called when this entity takes damage
function ITEM:OnTakeDamage(dmg)
end

--Called when a player tries to use this item while it is locked down. Mostly for crafting stations.
function ITEM:OnUseLocked(pl)
end

RegisterItem(ITEM)