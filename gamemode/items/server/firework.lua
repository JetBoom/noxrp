local ITEM = {}
ITEM.DataName = "firework"

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + Vector(0, 0, 9999)
	trace.filter = pl
	local tr = util.TraceLine(trace)
		
	if tr.HitSky or not tr.Hit then
		local firework = ents.Create("firework")
		firework:SetPos(pl:GetPos() + pl:GetAimVector() * 70)
		firework:Spawn()
		
		return true
	end
	
	pl:SendNotification("You must do this outside.", 4)
	return false
end

RegisterItem(ITEM)