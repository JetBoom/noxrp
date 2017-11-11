--Testing Item
local ITEM = {}
ITEM.DataName = "electrohack"

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 60
	trace.filter = pl
	local tr = util.TraceLine(trace)

	if tr.Hit then
		local ent = tr.Entity
		if ent:IsValid() then
			--print(ent:GetClass())
			if string.find(ent:GetClass(), "door") or (ent.CanBeHacked and ent.m_Owner ~= pl:UniqueID()) then
				local elechack = ents.Create("ent_electrohack")
				elechack:SetPos(tr.HitPos + tr.HitNormal)
				elechack:SetAngles(tr.HitNormal:Angle())
				elechack:SetEntityAppliedTo(ent)
				elechack:Spawn()
				elechack.m_Creator = pl

				return true
			else
				return false
			end
		else
			return false
		end
	end
	return false
end

RegisterItem(ITEM)