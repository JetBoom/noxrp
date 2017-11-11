local ITEM = {}
ITEM.DataName = "water"

function ITEM:OnReagentDrink(pl)
	if pl:Health() < 20 then
		pl:SetHealth(math.min(pl:Health() + self:GetAmount(), 20))
	--[[elseif pl:Health() < pl:GetMaxHealth() then
		pl:AddTemporaryHealth(math.min(pl:GetMaxHealth() - pl:Health(), 1 * plitem.Data.Volume))
		pl:AddTemporaryHealth(5)]]
	end
end

function ITEM:OnAerosolized(entity, collision)
	if collision ~= nil then
		local effect = EffectData()
			effect:SetOrigin(collision.HitPos)
			effect:SetScale(2 * self:GetAmount())
			effect:SetNormal(collision.OurOldVelocity:GetNormalized())
		util.Effect("water_aerosoled", effect)

		for k, v in pairs(ents.FindInSphere(collision.HitPos, 24)) do
			if v.GetTemperature then
				if v:GetTemperature() > TEMPERATURE_BASE_ENTITY then
					v:SetTemperature(math.max(v:GetTemperature() - 30, TEMPERATURE_BASE_ENTITY))
				end
			end

			if v:GetClass() == "status_onfire" then
				v:Remove()
			end
		end

		collision.HitEntity:EmitSound("ambient/water/water_splash1.wav")
	else
		local effect = EffectData()
			effect:SetOrigin(entity:GetPos())
			effect:SetScale(2 * self:GetAmount())
		util.Effect("water_aerosoled", effect)

		for k, v in pairs(ents.FindInSphere(entity:GetPos(), 24)) do
			if v.GetTemperature then
				if v:GetTemperature() > TEMPERATURE_BASE_ENTITY then
					v:SetTemperature(math.max(v:GetTemperature() - 30, TEMPERATURE_BASE_ENTITY))
				end
			end

			if v:GetClass() == "status_onfire" then
				v:Remove()
			end
		end

		entity:EmitSound("ambient/water/water_splash1.wav")
	end
	--particle\water\watersplash_002a.vtf
end

function ITEM:OnHitTemperature(temperature)
	if temperature >= 212 then
		return {Name = "water_boiling", Volume = 1}
	end

	return false
end
RegisterItem(ITEM)