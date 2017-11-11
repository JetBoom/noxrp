local ITEM = {}
ITEM.DataName = "chemistrygrenade"
ITEM.Model = "models/Items/grenadeAmmo.mdl"
ITEM.Name = "Grenade"
ITEM.ItemWeight = 0.5
ITEM.Category = ITEM_CAT_WEAPONS
ITEM.Weapon = "weapon_throwable_chemgrenade"
ITEM.ContainerVolume = 50
ITEM.DropIndividual = true
ITEM.Base = "liquidcontainer__base"

RegisterItem(ITEM)