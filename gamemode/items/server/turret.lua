local ITEM = {}
ITEM.DataName = "turret"

ITEM.Health = 250
ITEM.MaxHealth = 250
ITEM.Energy = 100

function ITEM:ItemUse(pl)
	local trace = {}
	trace.start = pl:GetShootPos()
	trace.endpos = trace.start + pl:GetAimVector() * 200
	trace.filter = pl
	trace.mask = MASK_SOLID
	local tr = util.TraceLine(trace)

	if tr.HitNormal.z >= 0.99 and tr.HitWorld then
		for k,v in pairs(ents.FindInBox(tr.HitPos + Vector(-40, -40, -2), tr.HitPos + Vector(40, 40, 92))) do
			if v:IsPlayer() then return false end
		end

		local ang = tr.Normal:Angle()
		ang.pitch = 0

		local turret = ents.Create("prop_turret")
		if turret:IsValid() then
			turret:SetPos(tr.HitPos)
			turret:SetAngles(ang)
			turret:Spawn()

			turret.m_Owner = pl:GetAccountID()
			turret.m_Creator = pl

			turret:SetHealth(self.Health)
			turret:SetMaxHealth(self.MaxHealth)
			turret:SetEnergy(self.Energy)

			return true
		end
	end
	return false
end

function ITEM:ToInventory(entity)
end

RegisterItem(ITEM)