local ITEM = {}
ITEM.DataName = "glassbottle"

function ITEM:PhysicsCollide(data, physobj)
	if data.Speed > 150 then
		local contents = self.Data:GetContainer()
		if #contents > 0 then
			for _, reagent in pairs(contents) do
				if reagent.OnAerosolized then
					reagent:OnAerosolized(self)
				end
			end
		end
		self:EmitSound("physics/glass/glass_bottle_break"..math.random(1, 2)..".wav")

		local prop = ents.Create("prop_physics")
		if prop then
			prop:SetPos(data.HitPos)
			prop:SetAngles(self:GetAngles())
			prop:SetModel(self:GetModel())
			prop:SetVelocity(data.OurOldVelocity)
			prop:Spawn()
			prop:Fire("Break", "", "")
		end

		self:Remove()
	end
end

RegisterItem(ITEM)