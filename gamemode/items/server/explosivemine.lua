local ITEM = {}
ITEM.DataName = "explosivemine"

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector()*200
	trace.filter = pl
	local tr = util.TraceLine(trace)
	
	local dot = Vector(0,0,1):Dot(tr.HitNormal)
	
	if dot > 0.99 and tr.HitWorld then
		for k,v in pairs(ents.FindInBox(tr.HitPos + Vector(-10,-10,-2),tr.HitPos + Vector(10,10,2))) do
			if v:IsPlayer() then return false end
			break
		end
		local mine = ents.Create("prop_explosivemine")
		mine:SetPos(tr.HitPos)
		mine:SetAngles(tr.HitNormal:Angle() + Angle(90,0,0))
		mine:Spawn()
		
		mine.OwnerID = pl:UniqueID()
		mine.OwnerPl = pl
		
		return true
	end
	return false
end

RegisterItem(ITEM)