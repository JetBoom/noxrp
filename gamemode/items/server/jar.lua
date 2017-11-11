local ITEM = {}
ITEM.DataName = "plasticjar"

function ITEM:OnExamined(pl)
	if #self.Data.Contents > 0 then
		pl:SendNotification("The jar contains: ", 4, Color(255, 255, 255), nil, 1)
			
		for k, v in pairs(self.Data.Contents) do
			pl:SendNotification(v.Volume.." units of "..ITEMS[v.Name].Name, 4, Color(255, 255, 255), nil, 1)
		end
	else
		pl:SendNotification("The jar contains nothing.", 4, Color(255, 255, 255), nil, 1)
	end	
end
RegisterItem(ITEM)