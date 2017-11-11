local ITEM = {}
ITEM.DataName = "redgoop"

function ITEM:OnTakeDamage(dmg)
	if dmg:IsDamageType(DMG_CLUB) then
		for i = 1, math.random(2) do
			local prop = ents.Create("item_plant_seed")
				prop:SetPos(self:GetPos())
				prop:SetAngles(self:GetAngles())
				prop:SetVelocity(self:GetVelocity() + VectorRand() * 30)
				prop:SetItemCount(self:GetItemCount())
				prop:Spawn()
					
			local tab = {}
				tab.GrowItem = "item_redgoop"
				tab.Name = "Plant Seed (Red Goop)"
			prop:SetData(tab)
		end
			
		self:Remove()
	end
		
	if dmg:IsDamageType(DMG_BURN) then
		local effect = EffectData()
			effect:SetOrigin(self:GetPos())
		util.Effect("HelicopterMegaBomb", effect)
		util.BlastDamage(self, self, self:GetPos(), 150, 10)
			
		self:Remove()
	end
end

RegisterItem(ITEM)