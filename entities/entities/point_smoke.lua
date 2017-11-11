ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self.DieTime = CurTime() + 7
		self:SetModel("")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetTrigger(true)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end

	function ENT:StartSmoke(scale)
		self.Scale = scale

		self:EmitSound("weapons/smokegrenade/sg_explode.wav")

		local col = Color(20, 20, 20)
		if self.Reagents then
			--print("we have reagents")
			for _, reag in pairs(self.Reagents) do
				--print(reag:GetItemName())
				if reag.IsFlammable then
					reag.Flammable = true
				end

				if reag.OnAerosolized then
					reag:OnAerosolized(self)
				end

				if gitem.ReagentColor then
					col = Color(col.r + gitem.ReagentColor.r, col.g + gitem.ReagentColor.g, col.b + gitem.ReagentColor.b)
				end
			end
		end

		local effect = EffectData()
			effect:SetOrigin(self:GetPos())
			effect:SetStart( Vector(col.r / 255, col.g / 255, col.b / 255))
		util.Effect("smokegrenade", effect)
	end

	function ENT:Think()
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 150)) do
			if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
				if self.Reagents then
					for _, item in pairs(self.Reagents) do
						if item.OnBreatheIn then
							item:OnBreatheIn(v)
						end
					end
				end
			elseif self.Flammable then
				if v:GetClass() == "projectile_nox_flare" or v:GetClass() == "projectile_firebullet" then
					v:Remove()

					self:Explode()
				end
			end
		end

		if self.DieTime < CurTime() then
			self:Remove()
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		if dmginfo:GetAttacker() == self or dmginfo:GetInflictor() == self then return end
		if self.Flammable and (dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_BLAST)) then
			self:Explode()
		end
	end

	function ENT:Explode()
		local effect = EffectData()
			effect:SetOrigin(self:GetPos())
		util.Effect("vehicle_explode", effect)

		util.BlastDamage(self, self, self:GetPos(), 600, 150)

		self:Remove()
	end
end

if CLIENT then
	function ENT:Initialize()
		self.DieTime = CurTime() + 15
	end

	function ENT:Draw()
	end

	function ENT:Think()
	end
end