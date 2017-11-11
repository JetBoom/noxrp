if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Shovel"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.NoIcon = true

	SWEP.Icon = "c"
	SWEP.Font = "HL2Icons"

	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/props_junk/Shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -5.715), angle = Angle(0, 20, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/props_junk/Shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, -7.792), angle = Angle(0, 20, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.SprintAngles = Angle(-20, -50, 20)
	SWEP.SprintVector = Vector(-5, 0, 0)
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_melee_base"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 15
SWEP.Primary.Delay = 0.85
SWEP.Range = 55

SWEP.BlockingStaminaPerDamage = 0.9
SWEP.CanBlock = true

SWEP.HoldType = "melee2"
SWEP.DamageType = DMG_CLUB

SWEP.HitDecal = "Manhackcut"

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.Item = "shovel"

function SWEP:OnSwing(trace)
	if not trace.Entity:IsValid() then
		for _, ent in pairs(ents.FindInSphere(trace.HitPos, 70)) do
			if ent:GetClass() == "point_digspot" then
				local effect = EffectData()
					effect:SetOrigin(ent:GetPos())
				util.Effect("buryitem", effect)

				if SERVER then
					local item = ents.Create(ent.Class)
						item:SetPos(ent:GetPos())
						item:SetAngles(ent.ItemAngles)
						item:Spawn()

						item:SetData(ent:GetItem())

					ent:Remove()
				end
			end
		end
	end
end

function SWEP:OnHitEntity(trace, damage)
	local ent = trace.Entity

	if SERVER then
		ent:TakeSpecialDamage(damage, self.Owner, self, self.DamageType, trace.HitPos)

		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(trace.Normal * 2)
		end

		if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
			self:CallSkillCheck(ent)
		end
	end

	if ent.CanBeBuried then
		local effect = EffectData()
			effect:SetOrigin(ent:GetPos())
		util.Effect("buryitem", effect)

		if SERVER then
			local bury = ents.Create("point_digspot")
				bury:SetPos(ent:GetPos())
				bury:Spawn()
				bury:SetItem(ent.Data)
				bury.ItemAngles = ent:GetAngles()
				bury.Class = ent:GetClass()

			ent:Remove()
		end
	end
end