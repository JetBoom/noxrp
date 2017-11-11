local meta = FindMetaTable("Weapon")
if not meta then return end

function meta:IsReloading()
	return CurTime() < self:GetReloadEnd()
end

function meta:GetReloadStart()
	return self.m_ReloadStart or 0
end

meta.SetNextPrimaryAttack = meta.SetNextPrimaryFire
meta.SetNextSecondaryAttack = meta.SetNextSecondaryFire

function AngleCone(ang, fCone)
	ang:RotateAroundAxis(ang:Up(), math.Rand(-fCone, fCone))
	ang:RotateAroundAxis(ang:Right(), math.Rand(-fCone, fCone))
	return ang
end

function meta:ShootBullet(fDamage, iNumber, fCone, tFilter)
	local owner = self.Owner
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:ShootEffects()
	
	self:PlayFireSound()
	
	local owner = self.Owner
	
	if self:GetDurability() < 20 then
		fDamage = fDamage * math.max(self:GetDurability() / 20, 0.4)
	end
	
	for k, v in pairs(self.Modifications) do
		local gitem = ITEMS[v.Name]
		if gitem.ShootBullet then
			gitem:ShootBullet(self, fDamage, num_bullets, fCone)
			return
		end
	end
	
	for i=1, (iNumber or 1) do
		local pos = owner:GetShootPos()
		local ang = fCone == 0 and owner:EyeAngles() or AngleCone(owner:EyeAngles(), fCone)
		local nocompensation = false
		if self.AlterBulletAngles then
			local a, n = self:AlterBulletAngles(pos, ang)
			if a ~= nil then ang = a end
			if n ~= nil then nocompensation = n end
		end
		--CreateBullet(pos, ang:Forward(), owner, self, fDamage, self.BulletSpeed, self.BulletClass, true, nocompensation)
		CreateBullet(pos, ang:Forward(), owner, self, fDamage, self.BulletSpeed, self.BulletClass, true, nocompensation, tFilter or {})
	end
end