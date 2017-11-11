local ITEM = {}
ITEM.DataName = "ore__base"
ITEM.Model = "models/props_junk/rock001a.mdl"
ITEM.Base = "_base"
ITEM.Category = "materials"
ITEM.HeatRequirement = 30
ITEM.IsBase = true
ITEM.Metal = "metal_copper"

function ITEM:PostSetData()
	self.ContentsHeat = TEMPERATURE_BASE_ENTITY
	self.NextCool = 0

	self.TotalSmelt = 0
end
	
function ITEM:OnTakeDamage(dmg)
	if dmg:IsDamageType(DMG_BURN) then
		self.NextCool = CurTime() + 2
		self.TotalSmelt = self.TotalSmelt + 1
		
		self:SetTemperature(math.min(self:GetTemperature() + dmg:GetDamage() * 10, 300))
	end
end
	
function ITEM:LocalThink()
	if self.NextCool < CurTime() then
		self.NextCool = CurTime() + 0.2
		self.TotalSmelt = math.max(self.TotalSmelt - 1, 0)
			
		self:SetTemperature(math.max(self:GetTemperature() - 5, TEMPERATURE_BASE_ENTITY))
	end
		
	if self:GetTemperature() > TEMPERATURE_BASE_ENTITY and self:WaterLevel() >= 2 then
		self:SetTemperature(TEMPERATURE_BASE_ENTITY)
		self:EmitSound("ambient/water/water_splash1.wav")
	end
		
	if self:GetTemperature() > 200 then
		if self.TotalSmelt >= self.HeatRequirement then
			local stack = self.Data:GetAmount()
				
			local ore = ents.Create("item_"..self.Metal)
			if ore then
				ore:SetPos(self:GetPos())
				ore:Spawn()
				ore:SetData()
				ore.Data:SetAmount(stack)
					
				ore:SetDisplayName(ore.Data:GetItemName().." [x"..ore.Data:GetAmount().."]")
			end
				
			if self:GetTemporaryOwner():IsValid() then
				ore:SetTemporaryOwnerMain(self:GetTemporaryOwner(), 20)
			end
				
			local pl = self:GetOwner()
			if pl:IsValid() then
				ore:SetOwner(pl)
				pl.c_Holding = ore
				pl:PickupObject(ore)
			end
			
			self:Remove()
		end
	end
end


RegisterItem(ITEM)