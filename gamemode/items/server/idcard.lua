local ITEM = {}
ITEM.DataName = "idcard"

function ITEM:ItemUse(pl, item)
	if not item:GetData().ID then
		item:GetData().ID = pl:GetAccountID()
		item:GetData().Name = pl:Nick()

		pl:UpdateInventoryItem(item)
	end
end

RegisterItem(ITEM)