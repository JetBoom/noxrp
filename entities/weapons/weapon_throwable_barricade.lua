SWEP.Base = "weapon_throwable_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Deployable Shield"
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
end

SWEP.Projectile = "projectile_combinebarricade"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Item = "combarricade"

SWEP.ThrowDelay = 1

if SERVER then
	function SWEP:ThrowProjectile()
		local owner = self.Owner
		local ent = ents.Create(self.Projectile)
		if ent:IsValid() then
			local pow = self:GetThrowPower()
			ent:SetPos(owner:GetShootPos())
			ent:SetOwner(owner)
			ent:Spawn()
			
			ent.DeployNormal = owner:GetAimVector()
			ent.DeployNormal.z = 0
			
			ent:EmitSound(self.ThrowSound)
			
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 4)
				phys:SetVelocityInstantaneous(owner:GetAimVector() * (self.BaseProjectileSpeed + pow * self.PowerProjectileSpeed))
			end
			
			self.Owner:DestroyItemByName(self.Item, 1)
		end
		self:SetThrowPower(0)
		self.DeleteTime = CurTime()+1.5
		self.Thrown = true
	end
end