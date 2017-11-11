local ITEM = {}
ITEM.DataName = "manhack"

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector()*200
	trace.filter = pl
	local tr = util.TraceLine(trace)
		
	if not tr.Hit then
		for k,v in pairs(ents.FindInBox(tr.HitPos+Vector(-5,-5,-2),tr.HitPos+Vector(5,5,2))) do
			if v:IsPlayer() then return false end
			break
		end
			
		local manhack = ents.Create("prop_drone")
		manhack:SetPos(tr.HitPos)
		manhack:SetAngles(tr.HitNormal:Angle() + Angle(90,0,0))
		manhack:Spawn()
			
		manhack.m_OwnerID = pl:UniqueID()
		pl:AddFollower(manhack)
		manhack:SetOwner(pl)
		
		return true
	end
	return false
end

RegisterItem(ITEM)