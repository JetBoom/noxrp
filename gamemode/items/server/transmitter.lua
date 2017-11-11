local ITEM = {}
ITEM.DataName = "transmitter"

ITEM.RequiresPower = true
ITEM.PowerConsumptionRate = 0.5

function ITEM:SetupLocalVars()
	self.Power = false
	self.Frequency = 102.2
	self.Connections = {}
	self.IsPowered = false
end

function ITEM:OnUseLocked(pl)
	if self.IsPowered then
		self:TogglePower(pl)
	else
		pl:SendNotification("This needs to be powered first.", 4, Color(255, 255, 255), nil, 1)
	end
end
	
//Returns a table of entities that can recieve messages from whatever is hooked up to this.
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
	return self.Power
end

function ITEM:OnInteractWith(pl, ent2)
	if ent2:GetClass() == "item_microphone" then
		pl:SendNotification("You link the microphone to the transmitter.", 4, Color(255, 255, 255), nil, 1)
			
		self:OnMicrophoneLinked(ent2)
		ent2:OnTransmitterLinked(self)
	else
		pl:SendNotification("You can't use that with this.", 4, Color(255, 255, 255), nil, 2)
	end
end
	
function ITEM:TogglePower(pl)
	self.Power = not self.Power
			
	if self.Power then
		pl:SendNotification("The transmitter is now on.", 4, Color(255, 255, 255), nil, 1)
		self:EmitSound("buttons/combine_button1.wav")
	else
		pl:SendNotification("The transmitter is now off.", 4, Color(255, 255, 255), nil, 1)
		self:EmitSound("buttons/combine_button2.wav")
	end
end
	
function ITEM:OnMicrophoneLinked(mic)
	self.Microphone = mic
end

function ITEM:OnPowered(powerbox)
	self.IsPowered = true
end

function ITEM:OnLosePower(powerbox)
	self.IsPowered = false
end

RegisterItem(ITEM)