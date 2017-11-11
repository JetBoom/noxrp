local ITEM = {}
ITEM.DataName = "gib"
ITEM.Model = "models/Gibs/HGIBS.mdl"
ITEM.Name = "Gib"
ITEM.ItemWeight = 2
ITEM.Base = "_base"
ITEM.Category = "materials"

RegisterItem(ITEM)

function ITEM:GetItemName(item)
	if item:GetData().Owner then
		return "A "..item:GetData().Owner.." gib"
	else
		return item:GetBaseName()
	end
end