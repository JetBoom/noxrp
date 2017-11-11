local ITEM = {}
ITEM.DataName = "messagepost_small"

ITEM.DisplayMessage = "This is the basic message."

function ITEM:OnUseLocked(pl)
	if not pl.ChatInput then
		pl.ChatInput = self
		pl:SendNotification("Enter the message you wish to display.")
	end
end

function ITEM:ChatInput(pl, text)
	pl.ChatInput = nil

	if self:GetPos():Distance(pl:EyePos()) <= 200 then
		self.DisplayMessage = text
		return true
	end

	return false
end

RegisterItem(ITEM)
