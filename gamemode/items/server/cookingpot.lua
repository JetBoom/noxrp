local ITEM = {}
ITEM.DataName = "cookingpot"
	
function ITEM:OnTemperatureUpdate()
	--	if self.NextUpdateName < CurTime() then
	--		self.NextUpdateName = CurTime() + 1
		self:SetDisplayName(self.Data:GetItemName().." [TEMP: "..math.Round(self:GetTemperature()).."F]")
	--	end
end

RegisterItem(ITEM)