SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Hand Welder"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.Font = "HL2Icons"
	SWEP.Icon = "d"
	
	SWEP.MainPos = Vector(0, 0, -9)
	SWEP.MainBone = "ValveBiped.square"
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "v_weapon.p228_Parent", rel = "", pos = Vector(0.2, -2.8, -1.5), angle = Angle(90, 0, 90), size = Vector(0.82, 0.62, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(0, 0, 0), angle = Angle(90, 0, 0), size = Vector(0.367, 0.367, 0.367), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/props_lab/tpplug.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(-3, 0, -0.801), angle = Angle(0, 180, 0), size = Vector(0.367, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "base", pos = Vector(3.635, 0, -0.519), angle = Angle(-66.624, 0, 180), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["base"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.6, 2, -1), angle = Angle(0, 180, 0), size = Vector(0.8, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(1.557, 0, -0.5), angle = Angle(90, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["4"] = { type = "Model", model = "models/props_lab/tpplug.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(-3, 0, -3), angle = Angle(0, 180, 0), size = Vector(0.3, 0.2, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(4, 0, 0), angle = Angle(-38.571, 0, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.SprintAngles = Angle(-10, 0, 0)
	
	SWEP.Ammo3DBone = "v_weapon.p228_Parent"
	SWEP.Ammo3DPos = Vector(0, -5, -1)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.015
	SWEP.DrawExtraAmmo = false
end

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.Item = "handgun_handwelder"
SWEP.AmmoItem = "battery"

SWEP.ShootSound = "weapons/airboat/airboat_gun_energy1.wav"
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")

SWEP.ViewModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.WeaponType = WEAPON_TYPE_GUN
SWEP.Primary.ClipSize = 100

SWEP.Primary.Delay = 0.2
SWEP.Primary.Automatic = true

--SWEP.SkillCategory = SKILL_PISTOLS
function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() < CurTime() and self:Clip1() > 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
				
		self:Welded()
	else
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:EmitSound("weapons/physcannon/superphys_small_zap4.wav")
	end
end

function SWEP:Welded()
	if self:Clip1() > 0 then
		local owner = self.Owner
		local data = {}
		data.start = owner:GetShootPos()
		data.endpos = data.start + owner:GetAimVector() * 50
		data.filter = {self, owner}
				
		local tr = util.TraceLine(data)
		if tr.Entity:IsValid() then
			if SERVER then
				if tr.Entity.OnWelded then
					if tr.Entity:OnWelded(self, owner, tr) then
						self:WeldedTarget(tr)
						self:CallOnClient("WeldedTarget")
					end
				end
			end
		end
	end
end

function SWEP:WeldedTarget(tr)
	self:SetClip1(math.max(self:Clip1() - 1, 0))
	self:EmitSound("ambient/energy/zap2.wav")
	
	if CLIENT then
		local owner = self.Owner
		
		local data = {}
		data.start = owner:GetShootPos()
		data.endpos = data.start + owner:GetAimVector() * 50
		data.filter = {self, owner}
				
		local tr = util.TraceLine(data)
		
		local effect = EffectData()
			effect:SetOrigin(tr.HitPos)
		util.Effect("weldeffect", effect)
	end
end

function SWEP:Reload()
	if not self:GetHolstered() then
		if self:Clip1() < self.Primary.ClipSize then
			if self.Owner:GetItemCount(self.AmmoItem) > 0 then
				if SERVER then
					self:GetOwner():DestroyItemByName(self.AmmoItem)
				end
				
				self:SetClip1(100)
					
				self:EmitSound("weapons/physcannon/superphys_small_zap4.wav")
			end
		end
	end
end
