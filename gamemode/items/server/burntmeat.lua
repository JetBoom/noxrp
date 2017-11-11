local ITEM = {}
ITEM.DataName = "burntmeat"

ITEM.CookTime = 20
ITEM.HealthRecovery = -1

function ITEM:SetupLocalVars()
	self.CookTotal = 0
end
	
function ITEM:OnTakeDamage(dmg)
	if dmg:IsDamageType(DMG_BURN) then
		self.CookTotal = self.CookTotal + dmg:GetDamage()
			
		if self.CookTotal >= (self.CookTime * self:GetItemCount()) then
			local prop = ents.Create("item_ash")
				prop:SetPos(self:GetPos())
				prop:SetAngles(self:GetAngles())
				prop:SetVelocity(self:GetVelocity())
				prop:SetItemCount(self:GetItemCount())
				prop:Spawn()
					
			prop:SetData()
			
			self:Remove()
		end
	end
end

RegisterItem(ITEM)