local ITEM = {}
ITEM.DataName = "idcard"
ITEM.Model = "models/gibs/metal_gib4.mdl"
ITEM.Name = "ID Securi-Card"
ITEM.ItemWeight = 0
ITEM.Base = "_base"
ITEM.Category = "other"
ITEM.BasePrice = 2
ITEM.Usable = true

function ITEM:GetItemDescription(item)
	if item:GetData().Name then
		return "This card"
	else
		return "This ID Card is blank."
	end
end

RegisterItem(ITEM)