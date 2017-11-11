local ITEM = {}
ITEM.DataName = "campfire"

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 200
	trace.filter = pl
	local tr = util.TraceLine(trace)
	
	local dot = Vector(0, 0, 1):Dot(tr.HitNormal)
		
	if dot > 0.99 and tr.HitWorld then
		local ent = false
		for k, v in pairs(ents.FindInBox(tr.HitPos + Vector(-40, -40, -2), tr.HitPos + Vector(40, 40, 20))) do
			ent = true
		end
			
		if not ent then
			local campfire = ents.Create("prop_campfire")
			campfire:SetPos(tr.HitPos + tr.HitNormal * 0)
			campfire:SetAngles(tr.HitNormal:Angle() + Angle(90, 0, 0))
			campfire:Spawn()
				
			return true
		else
			return false
		end
	end
	return false
end

RegisterItem(ITEM)