local ITEM = {}
ITEM.DataName = "water_boiling"

function ITEM:OnReagentDrink(pl)
	pl:TakeDamage(2 * self:GetAmount())

	pl:EmitSound("ambient/voices/cough1.wav")
	return true
end

function ITEM:OnAerosolized(entity, collision)
	if collision ~= nil then
		for k, v in pairs(ents.FindInSphere(collision.HitPos, 16)) do
			v:TakeDamage(self:GetAmount())
		end

		local effect = EffectData()
			effect:SetOrigin(collision.HitPos)
			effect:SetScale(2 * data.Volume)
			effect:SetNormal(collision.OurOldVelocity:GetNormalized())
		util.Effect("waterb_aerosoled", effect)
		--particle\water\watersplash_002a.vtf
	end
end

function ITEM:OnHitTemperature(temperature, reference)
	if temperature <= 120 then
		return {Name = "water", Volume = 1}
	end

	return nil
end

RegisterItem(ITEM)