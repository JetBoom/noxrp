local ITEM = {}
ITEM.DataName = "powerbox1"

function ITEM:SetupLocalVars()
	self:SetNWFloat("Rate", self.PowerRate)
	
	self.Connections = {}
	self.NextPowerCheck = 0
	self.CurrentPowerRate = self.PowerRate
end
	
function ITEM:ThinkLocked()
	if self.NextPowerCheck < CurTime() then
		self.NextPowerCheck = CurTime() + 1
	end
end
	
function ITEM:OnInteractWith(pl, ent)
	if ent.RequiresPower then
		if self.CurrentPowerRate - ent.PowerConsumptionRate >= 0 then
			pl:SendNotification("You link the '"..ent.Data:GetItemName().."' to the powerbox.", 4, Color(255, 255, 255), nil, 1)
			ent:OnPowered(self)
			
			self:AddPowerUser(ent)
			
			self.CurrentPowerRate = self.PowerRate
			local removes = {}
			for index, connect in pairs(self.Connections) do
				if connect then
					if connect.IsPowered then
						self.CurrentPowerRate = self.CurrentPowerRate - connect.PowerConsumptionRate
					end
				else
					table.insert(removes, index)
				end
			end
			
			self.CurrentPowerRate = math.Round(self.CurrentPowerRate, 3)
				
			if self.CurrentPowerRate ~= self:GetNWFloat("Rate") then
				self:SetNWFloat("Rate", self.CurrentPowerRate)
			end
		else
			pl:SendNotification("There is not enough power left to power that.", 4, Color(255, 255, 255), nil, 1)
		end
	end
end

function ITEM:OnTaken(pl)
	for index, ent in pairs(self.Connections) do
		if IsValid(ent) then
			if ent.IsPowered then
				ent:OnLosePower(self)
			end
		end
	end
end

function ITEM:AddPowerUser(ent)
	table.insert(self.Connections, ent)
end

function ITEM:RemovePowerUser(ent)
	for index, tab in pairs(self.Connections) do
		if tab == ent then
			table.remove(self.Connections, index)
		end
	end
end

RegisterItem(ITEM)