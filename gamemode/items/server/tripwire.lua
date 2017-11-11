local ITEM = {}
ITEM.DataName = "tripwire"

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 50
	trace.filter = pl
	local tr = util.TraceLine(trace)
		
	local dot = Vector(0, 0, 1):Dot(tr.HitNormal)
	if tr.HitWorld then
			
		local trip = ents.Create("prop_tripwire")
		trip:SetPos(tr.HitPos + tr.HitNormal * 5)
		trip:SetAngles(tr.HitNormal:Angle() + Angle(0, 90, 0))
		trip:Spawn()
		trip.m_Creator = pl
		
		return true
	end
	return false
end

RegisterItem(ITEM)