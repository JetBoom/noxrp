local ITEM = {}
ITEM.DataName = "vehfigurine"

function ITEM:ItemUse(pl)
	if self.VehicleClass then
		local data = {}
		data.start = pl:GetShootPos()
		data.endpos = data.start + pl:GetAimVector() * 200
		data.filter = pl
		local tr = util.TraceLine(data)

		if tr.HitWorld or not tr.Hit then
			local veh = ents.Create(self.VehicleClass)
			if veh:IsValid() then
				veh:SetPos(tr.HitPos + Vector(0, 0, veh:OBBMaxs().z + 10))
				if self.RegularVehicle then
					veh:SetModel(self.VehicleModel)
					veh:SetSkin(self.VehicleSkin)
					veh:SetColor(self.VehicleColor)
					veh:SetKeyValue("vehiclescript", "scripts/vehicles/sentry/mp4-12c.txt")

					veh:Spawn()
					veh:Activate()
				else
					veh:Spawn()
					veh:SetVarsToLoad(self)
				end

				return true
			end
		else
			return false
		end
	end
end

RegisterItem(ITEM)