local ITEM = {}
ITEM.DataName = "greengoop"

function ITEM:OnTakeDamage(dmg)
	if dmg:IsDamageType(DMG_CLUB) and dmg:GetDamage() >= 5 then
		local prop = ents.Create("item_plant_seed")
			prop:SetPos(self:GetPos() + Vector(0, 0, 2))
			prop:SetAngles(self:GetAngles())
			prop:SetVelocity(self:GetVelocity() + VectorRand() * 30)
			prop:SetItemCount(1)
			prop:Spawn()
					
		local tab = {}
			tab.GrowItem = "item_greengoop"
		prop:SetData(tab)
			
		if self:GetItemCount() > 1 then
			self:SetItemCount(self:GetItemCount() - 1)
		else
			self:Remove()
		end
	end
end

RegisterItem(ITEM)