local ITEM = {}
ITEM.DataName = "gib"

ITEM.CookTime = 10

function ITEM:PostSetData()
	--	self:SetMaterial("models/flesh")
		
		--if self.Data.Owner then
		--	self:SetDisplayName("A "..self.Data.Owner.." gib")
		--end
end
	
function ITEM:LocalThink()
end
	
function ITEM:SetupLocalVars()
	self.CookTotal = 0
end
	
function ITEM:OnTakeDamage(dmg)
	if dmg:IsDamageType(DMG_BURN) or dmg:IsDamageType(DMG_BLAST)  then
		self.CookTotal = self.CookTotal + dmg:GetDamage()
			
		if self.CookTotal >= (self.CookTime * self:GetItemCount()) then
			local prop = ents.Create("item_cookedmeat")
				prop:SetPos(self:GetPos())
				prop:SetAngles(self:GetAngles())
				prop:SetVelocity(self:GetVelocity())
				prop:SetItemCount(self:GetItemCount())
				prop:Spawn()
					
			if self.Data:GetData().Owner then
				local data = self.Data:GetData()
				local tab = Item("cookedmeat")
					tab:GetData().Owner = data.Owner
						
					tab:SetModel(data.Model)
					tab:SetItemName("Cooked "..data.Owner.." Meat")
					
				prop:SetData(tab)
			else
				local tab = Item("cookedmeat")
					tab:SetAmount(self.Data:GetAmount())
					
				prop:SetData(tab)
			end
			self:Remove()
		end
	end
end

RegisterItem(ITEM)