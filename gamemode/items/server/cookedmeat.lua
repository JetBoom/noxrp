local ITEM = {}
ITEM.DataName = "cookedmeat"

ITEM.CookTime = 10
ITEM.HealthRecovery = 5

function ITEM:PostSetData()
	--	self:SetMaterial("models/flesh")
	self.DieTime = CurTime() + 25
end
	
function ITEM:SetupLocalVars()
	self:SetColor(Color(100, 100, 100))
end
	
function ITEM:SetupLocalVars()
	self.CookTotal = 0
end

function ITEM:OnTakeDamage(dmg)
	if dmg:IsDamageType(DMG_BURN) or dmg:IsDamageType(DMG_BLAST) then
		self.CookTotal = self.CookTotal + dmg:GetDamage()
			
		if self.CookTotal >= (self.CookTime * self:GetItemCount()) then
			local prop = ents.Create("item_burntmeat")
				prop:SetPos(self:GetPos())
				prop:SetAngles(self:GetAngles())
				prop:SetVelocity(self:GetVelocity())
				prop:SetItemCount(self:GetItemCount())
				prop:Spawn()
				
			local item = Item("burntmeat")
				item:SetAmount(self.Data:GetAmount())

			if self.Data:GetData().Owner then
				item:GetData().Owner = self.Data:GetData().Owner
			end
			
			prop:SetData(item)
			self:Remove()
		end
	end
end

RegisterItem(ITEM)