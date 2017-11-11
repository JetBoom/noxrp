local ITEM = {}
ITEM.DataName = "crafting_cooking"

function ITEM:OnUseLocked(act)
	if act:IsPlayer() then
			--act:SendLua("OpenFilteredCrafting("..SKILL_COOKING..")")
		self.IsCooking = not self.IsCooking
			--act:SendNotification("You can cook items by placing them on the burners.", 10, Color(100, 150, 255), "buttons/button14.wav", 1)
		
		if self.IsCooking then
			self:EmitSound("ambient/fire/ignite.wav")
		else
			self:EmitSound("ambient/fire/mtov_flame2.wav")
		end
	end
end
	
function ITEM:OnLockedDownItem(pl)
	self.IsCooking = false
	self.NextCook = CurTime() + 1
end
	
function ITEM:ThinkLocked()
	if self.IsCooking then
		if not self.NextCook then
			self.NextCook = CurTime()
				
			local effect = EffectData()
				effect:SetEntity(self)
			util.Effect("cooking_fire", effect)
		end
			
		local effect = EffectData()
			effect:SetOrigin(self:GetPos() - self:GetRight() * 25 - self:GetForward() * 6 + Vector(0, 0, 40))
		util.Effect("cooking_fire", effect)
			
			effect:SetOrigin(self:GetPos() - self:GetRight() * 25 + self:GetForward() * 6 + Vector(0, 0, 40))
		util.Effect("cooking_fire", effect)
			
			effect:SetOrigin(self:GetPos() - self:GetRight() * 12 + self:GetForward() * 6 + Vector(0, 0, 40))
		util.Effect("cooking_fire", effect)
			
			effect:SetOrigin(self:GetPos() - self:GetRight() * 12 - self:GetForward() * 6 + Vector(0, 0, 40))
		util.Effect("cooking_fire", effect)
		
		local cent = self:GetPos() + Vector(0, 0, 40) - self:GetRight() * 18
				
		for k, v in pairs(ents.FindInSphere(cent, 16)) do
			if v ~= self then
				if self.NextCook < CurTime() then
					self.NextCook = CurTime() + 1
					local dmg = DamageInfo()
						dmg:SetDamage(2)
						dmg:SetDamageType(DMG_BURN)
						dmg:SetAttacker(self)
							
					v:TakeDamageInfo(dmg)
				end
						
				if not v:IsPlayer() then
					local effect = EffectData()
						effect:SetEntity(v)
					util.Effect("cooking_fire_item", effect)
				end
			end
		end
	end
end

RegisterItem(ITEM)