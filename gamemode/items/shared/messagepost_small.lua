local ITEM = {}
ITEM.DataName = "messagepost_small"
ITEM.Model = "models/props_combine/combine_intmonitor001.mdl"
ITEM.Name = "Small Message Post"
ITEM.ItemWeight = 5
ITEM.Base = "_base"
ITEM.Category = "materials"

function ITEM:SetupExtraDataTables()
	self:NetworkVar("String", 2, "DisplayMessage")
end

RegisterItem(ITEM)