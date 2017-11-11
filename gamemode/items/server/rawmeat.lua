local ITEM = {}
ITEM.DataName = "rawmeat"

ITEM.CookTime = 10
ITEM.HealthRecovery = 2

function ITEM:SetupLocalVars()
	self.CookTotal = 0
	self.NextCool = 0
end
	
function ITEM:OnTakeDamage(dmg)
	if dmg:IsDamageType(DMG_BURN) or dmg:IsDamageType(DMG_BLAST) then
		self.NextCool = CurTime() + 1
		
		self:SetTemperature(self:GetTemperature() + dmg:GetDamage() * 2)
		if self:GetTemperature() > 200 then
			local prop = ents.Create("item_cookedmeat")
				prop:SetPos(self:GetPos())
				prop:SetAngles(self:GetAngles())
				prop:SetVelocity(self:GetVelocity())
				prop:Spawn()
					
			local item = Item("cookedmeat")
				item:SetAmount(self.Data:GetAmount())
				
			prop:SetData(item)
			if self:GetNWEntity("TemporaryOwner"):IsValid() then
				prop:SetTemporaryOwner(self:GetNWEntity("TemporaryOwner"), self:GetNWFloat("TemporaryOwnedTime") - CurTime())
			end
			self:Remove()
		end
	end
end

function ITEM:LocalThink()
	local contents = self.Data:GetContainer()
	
	if self.NextCool < CurTime() then
		self.NextCool = CurTime() + 1
		
		self:SetTemperature(math.max(self:GetTemperature() - 3, TEMPERATURE_BASE_ENTITY))
	end
		
	if self:GetTemperature() > TEMPERATURE_BASE_ENTITY and self:WaterLevel() >= 2 then
		self:SetTemperature(TEMPERATURE_BASE_ENTITY)
		
		self:EmitSound("ambient/water/water_splash1.wav")
	end
end

RegisterItem(ITEM)