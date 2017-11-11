local ITEM = {}
ITEM.DataName = "idcard"

ITEM.Description = "%s security card registered to %s."
	
function ITEM:GetDescription(item)
	local data = item:GetData()
		
	if data.ID then
		return string.format(self.Description, "A", tostring(data.ID))
	else
		return string.format(self.Description, "A blank", "no one")
	end
end

RegisterItem(ITEM)