local ITEM = {}
ITEM.DataName = "liquidcontainer__base"
ITEM.Model = "models/props_junk/garbage_plasticbottle003a.mdl"
ITEM.Name = "Base Container"
ITEM.ItemWeight = 3
ITEM.IsLiquidContainer = true
ITEM.Category = "materials"
ITEM.Usable = true
ITEM.ContainerVolume = 20
ITEM.ReplaceWorldModel = true
ITEM.IsBase = true
ITEM.CanDrink = false

ITEM.WaterTight = false

function ITEM:CheckCanDrink(item)
	return #item:GetContainer() > 0
end

RegisterItem(ITEM)