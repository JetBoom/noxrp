local ITEM = {}
ITEM.DataName = "timebomb"

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 200
	trace.filter = pl
	trace.mask = MASK_SOLID
	local tr = util.TraceLine(trace)

	if tr.HitWorld then
		local bomb = ents.Create("planted_timebomb")
		bomb:SetPos(tr.HitPos + tr.HitNormal * 2)
		bomb:SetAngles(tr.HitNormal:Angle() + Angle(270, 0, 180))
		bomb:Spawn()

		bomb.Player = pl

		pl:SendNotification("You should probably run now!", 4)

		return true
	else
		pl:SendNotification("You need to do this on the ground or a wall.")
	end

	return false
end

RegisterItem(ITEM)