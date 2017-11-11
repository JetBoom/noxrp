ENT.Type = "anim"

ENT.m_NextFire = 0
ENT.FireSound = Sound("Weapon_SMG1.Single")

function ENT:ShootPos()
	return self:GetPos() + self:GetUp() * 55 + self:GetForward() * 10
end

function ENT:GetTargetPos(target)
	local boneid = target:GetHitBoxBone(HITGROUP_CHEST, 0)
	if boneid and boneid > 0 then
		local p, a = target:GetBonePosition(boneid)
		if p then
			return p
		end
	end

	return target:LocalToWorld(target:OBBCenter())
end

function ENT:SetNextFire(delay)
	self.m_NextFire = delay
end

function ENT:GetNextFire()
	return self.m_NextFire
end