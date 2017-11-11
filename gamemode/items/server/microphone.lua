local ITEM = {}
ITEM.DataName = "microphone"

ITEM.RequiresPower = true
ITEM.PowerConsumptionRate = 0.5
	
function ITEM:SetupLocalVars()
	self.Transmitter = false
	self.Power = false
	self.IsPowered = false
	self.BroadcastFrequency = 102.2
	self.Connections = {}
end
	
function ITEM:ThinkLocked()
end

function ITEM:GetReceivers()
	local tab = {}
	
	//If this transmitter is specifically linked to another receiver, then only send it to that
	if self.Linked then
		table.insert(tab, self.Linked)
	else
		tab = ents.FindByClass("item_radio")
	end
	return tab
end

function ITEM:CanTransmit()
	//If this transmitter is specifically linked to another receiver, then only send it to that
	if self.Linked then
		table.insert(tab, self.Linked)
	else
		tab = ents.FindByClass("item_radio")
	end
	return tab
end
	
function ITEM:OnUseLocked(pl)
end

function ITEM:OnInteractWith(pl, ent2)
	if ent2:GetClass() == "item_radio" then
		pl:SendNotification("You link the microphone to the radio.", 4, Color(255, 255, 255), nil, 1)
		self.Linked = ent2
			
		//ent2:OnMicrophoneLinked(self)
	else
		pl:SendNotification("You can't use that with this.", 4, Color(255, 255, 255), nil, 2)
	end
end

function ITEM:CanPlayerTransmitVoice(pl)
	if pl:GetPos():Distance(self:GetPos()) > 600 then
		return false
	end
	
	return true
end
	
function ITEM:OnHearSentence(pl, text)
	//Get the table of entities that can receive this message, and then transmit it to all listeners
	local transmitter = self:GetReceivers()
	for _, receiver in pairs(transmitter) do
		if receiver.Frequency == self.BroadcastFrequency then
			local distance = pl:GetPos():Distance(self:GetPos())
			receiver:OnReceiveText(pl, text, distance)
		end
	end
end
	
function ITEM:OnTransmitterLinked(transmitter)
end

RegisterItem(ITEM)