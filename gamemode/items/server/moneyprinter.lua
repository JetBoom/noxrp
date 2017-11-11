local ITEM = {}
ITEM.DataName = "moneyprinter"

function ITEM:SetupLocalVars()
	self.PrintMoney = CurTime() + 10
	self.Exploding = false
	self.Ignited = false
		
	self.NextSpark = CurTime() + 8
end
	
function ITEM:LocalThink()
	if not self.Exploding and self.NextSpark < CurTime() then
		self.NextSpark = CurTime() + 0.1
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetMagnitude(2)
			effectdata:SetScale(2)
			effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end
		
	if self.PrintMoney < CurTime() and not self.Exploding then
		self.Exploding = true
			
		local item = ents.Create("item_money")
			item:SetPos(self:GetPos() + Vector(0, 0, 10))
			item:Spawn()
			item:SetData(Item("moneyc"))
				
		self.BlowUp = CurTime() + 5
		self.IgniteTime = CurTime() + 1
	elseif self.Exploding then
		if not self.Ignited and self.IgniteTime < CurTime() then
			self.Ignited = true
			self:Ignite(4)
		elseif self.BlowUp < CurTime() then	
			local effect = EffectData()
				effect:SetOrigin(self:GetPos())
			util.Effect("Explosion", effect)
				
			util.BlastDamage(self, self, self:GetPos(), 200, 50)
			
			self:Remove()
		end
	end
end
	
function ITEM:CanPickup()
	return not self.Exploding
end

RegisterItem(ITEM)