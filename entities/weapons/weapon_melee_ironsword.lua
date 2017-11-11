if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "Iron Sword"
	SWEP.PrintName2 = "Light Melee"
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true
	
	SWEP.Icon = "c"
	SWEP.Font = "HL2Icons"

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10, -8) }
	}
	
	SWEP.VElements = {
		["base"] = { type = "Model", model = "models/nayrbarr/Sword/sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5, 1.6, -16), angle = Angle(90, 70, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Base = "weapon_melee_base"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "Models/nayrbarr/Sword/Sword.mdl"

SWEP.SwingSound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Damage = 15
SWEP.Primary.Delay = 0.75
SWEP.Range = 55

SWEP.HoldType = "melee"
SWEP.WeaponSkill = SKILL_BLADEWEAPONS
SWEP.DamageType = DMG_SLASH

SWEP.HitDecal = "Manhackcut"

SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.Item = "ironsword"
SWEP.CanBlock = true
SWEP.BlockingStaminaPerDamage = 0.4

if CLIENT then
	SWEP.Offset = {
		Pos = {
			Up = 16,
			Right = 0,
			Forward = 0,
		},
		Ang = {
			Up = 0,
			Right = -90,
			Forward = 0,
		},
		Scale = 1
	}

	function SWEP:DrawWorldModel()
		if self:GetHolstered() then return end
		local hand, offset, rotate
		
		if not self.Owner:IsValid() then
			self:DrawModel()
			return
		end
		
		if not self.Hand then
			self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
		end
		
		hand = self.Owner:GetAttachment( self.Hand )
		
		if not hand then
			self:DrawModel()
			return
		end
		offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up
		
		hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
		hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
		hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )
		
		self:SetRenderOrigin( hand.Pos + offset )
		self:SetRenderAngles( hand.Ang )

		self:DrawModel()
	end
end

local verticalswanim = {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = -5
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -86,
					RR = -14
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 1,
					RR = -13,
					RF = 36
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -28,
					RR = 7,
					RF = 62
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 27,
					RF = 10
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 53
				},
				['ValveBiped.Bip01_Spine1'] = {
					RU = -15,
					RF = -6
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 57
				},
				['ValveBiped.Bip01_Spine2'] = {
					RU = -5,
					RF = -26
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 42
				}
			},
			FrameRate = 2
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = 16,
					RR = -4,
					RF = -14
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = 6,
					RR = -92,
					RF = -94
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 17,
					RR = 15,
					RF = -33
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -12,
					RR = -58
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = 18
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 91
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 27
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 30
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 19,
					RR = 25
				}
			},
			FrameRate = 4
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = 16,
					RR = -4,
					RF = 7
				},
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = 6,
					RR = -92,
					RF = -94
				},
				['ValveBiped.Bip01_Head1'] = {
					RU = 17,
					RR = 9,
					RF = -33
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = -12,
					RR = -58
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 91
				},
				['ValveBiped.Bip01_Spine1'] = {
					RF = 8
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 23
				}
			},
			FrameRate = 2.5
		},
		{
			BoneInfo = {},
			FrameRate = 4
		}
	},
	Type = TYPE_GESTURE,
	Group = "melee_1h"
}
RegisterLuaAnimation('melee_1h_swing', verticalswanim)