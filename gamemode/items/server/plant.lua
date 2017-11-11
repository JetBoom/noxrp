local ITEM = {}
ITEM.DataName = "plant_seed"

ITEM.GrowItem = "item_greengoop"
ITEM.GrowTime = 30
ITEM.GrowNum = 2

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 100
	trace.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceLine(trace)

	if tr.HitWorld and tr.HitNormal.z >= 0.95 and tr.MatType == MAT_DIRT then
		local plant = ents.Create("base_plant")
		if plant then
			plant:SetPos(tr.HitPos)
			plant:SetAngles(Angle(0, 0, 0))
			plant:Spawn()
			plant:SetItem(self:GetCopy())

			return true
		end
	else
		pl:SendNotification("You can only grow this on flat dirt.")
	end

	return false
end

RegisterItem(ITEM)