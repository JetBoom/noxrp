if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Explosive Grenade"
	SWEP.PrintName2 = "Throwable Detonation Device"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
end

SWEP.Base = "weapon_throwable_base"
SWEP.Projectile = "projectile_chemgrenade"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"

SWEP.Item = "chemistrygrenade"
SWEP.PowerProjectileSpeed = 400
SWEP.BaseProjectileSpeed = 500
SWEP.PreventAutoEquip = true

if SERVER then
	function SWEP:SetupItemVariables()
		local item = self.Owner:GetItemByID(self:GetIDTag())

		if item then
			self.Reagents = item
		end
	end

	function SWEP:ThrowProjectile()
		local owner = self.Owner
		local ent = ents.Create(self.Projectile)
		if ent:IsValid() then
			local pow = self:GetThrowPower()
			ent:SetPos(owner:GetShootPos())
			ent:SetOwner(owner)
			ent:Spawn()
			ent:EmitSound(self.ThrowSound)

			--print("--reagent--", "before")
			ent.Data = self.Reagents
			--print("--reagent--", "after")

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 4)
				phys:SetVelocityInstantaneous(owner:GetAimVector() * (self.BaseProjectileSpeed + pow * self.PowerProjectileSpeed))
			end

			self.Owner:DestroyItem(self:GetIDTag(), 1)
		end

		self:SetThrowPower(0)
		self.DeleteTime = CurTime() + 1.5
		self.Thrown = true
	end
end