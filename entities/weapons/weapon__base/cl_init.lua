include("shared.lua")
include("construction.lua")

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false
	
SWEP.Icon = "a"
SWEP.Font = "csKillIcons"
SWEP.PosX = 0
SWEP.PosY = 0

SWEP.PrintName = "Base Weapon"
SWEP.PrintName2 = "Base Weapon"

SWEP.CrosshairScale = 1
SWEP.LerpAngVM = 0
SWEP.LerpVMState = false
SWEP.LerpVMAngle = Angle(0, 0, 0)
SWEP.LerpVMVector = Vector(0, 0, 0)

SWEP.SprintAngles = Angle(-10, 0, 10)
SWEP.SprintVector = Vector(0, 0, 0)

SWEP.ViewModelBoneModsOffHand = {
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-18.889, 32.222, -54.445) }
}

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "hidden16", x + wide * 0.5, y + tall - 32, COLOR_RED, TEXT_ALIGN_CENTER)
end
	
function SWEP:OnRemove()
	self:RemoveModels()
	if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
		self.Owner.LoadoutEffect:WeaponRemove(self.Slot)
	end
end
	
function SWEP:HolsterEffect()
	if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
		self.Owner.LoadoutEffect:WeaponHolster(self)
	end
end

function SWEP:ViewModelDrawn()
	self:Cons_ViewModelDrawn()
end

function SWEP:PreDrawViewModel(vm)
	if self.ShowViewModel == false or (self.LerpAngVM == 1 and self:GetHolstered()) then
		render.SetBlend(0)
	end
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false or (self.LerpAngVM == 1 and self:GetHolstered()) then
		render.SetBlend(1)
	end
end

function SWEP:DrawWorldModel()
	self:Cons_DrawWorldModel()
end

function SWEP:StartHolster()
	if self.HolsterSound then
		self:EmitSound("physics/metal/weapon_impact_soft"..math.random(1,3)..".wav")
	end
	
	self:HolsterEffect()
end

function SWEP:EndHolster()
	if self.HolsterSound then
		self:EmitSound("physics/metal/weapon_impact_soft"..math.random(1,3)..".wav")
	end
end

function SWEP:StartIronSights()
	self.BobScale = 0.05
end

function SWEP:StopIronSights()
	self.BobScale = 1
end

function SWEP:SetNewSlot(str)
	local slot = tonumber(str)
	self.Slot = slot
end

function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	local vm = self.Owner:GetViewModel()
	local angr = Angle(0, 0, 0)
	local posr = Vector(0, 0, 0)
	
	if self:GetHolstered() then
		angr.p = -30
		angr.r = -10
		self.LerpAngVM = math.Approach(self.LerpAngVM, 1, (1 / self.HolsterTime) * FrameTime())
		
		if not self.LastViewMod == angr or self.LastViewMod == nil then
			self.LastViewMod = angr
		end
	elseif self:GetOwner():IsSprinting() and self:GetOwner():GetVelocity():Length2D() > 50 and self.NextLerpTime < CurTime() and self:GetNextPrimaryFire() < CurTime() and self:GetReloadEnd() < CurTime() then
		angr = self.SprintAngles
		posr = self.SprintVector
		
		self.LerpAngVM = math.Approach(self.LerpAngVM, 1, FrameTime() * 2)
		
		if not self.LastViewMod == angr or self.LastViewMod == nil  then
			self.LastViewMod = angr
		end
		if not self.LastViewPos == posr or self.LastViewPos == nil then
			self.LastViewPos = posr
		end
	elseif self.LerpAngVM > 0 then
		angr = self.LastViewMod or Angle(0, 0, 0)
		posr = self.LastViewPos or Vector(0, 0, 0)
		self.LerpAngVM = math.Approach(self.LerpAngVM, 0, FrameTime() * 3)
		
		if self.LerpAngVM == 0 then
			self.LastViewMod = nil
			self.LastViewPos = nil
		end
	end
	
	pos = pos + posr.x * ang:Right() * self.LerpAngVM
		+ posr.y * ang:Forward() * self.LerpAngVM
		+ posr.z * ang:Up() * self.LerpAngVM
	
	ang:RotateAroundAxis(ang:Right(), angr.p * self.LerpAngVM)
	ang:RotateAroundAxis(ang:Forward(), angr.y * self.LerpAngVM)
	ang:RotateAroundAxis(ang:Up(), angr.r * self.LerpAngVM)
	
	return pos, ang
end

function SWEP:DrawHUD()
	if LocalPlayer().IsCrafting then return end
	if GetConVarNumber("noxrp_drawhud") == 1 then
		self:DrawCursor()
	end
end

local crosshair = Material("noxrp/crosshairs/crosshair1.png")
local crosshaira = Material("noxrp/crosshairs/crosshair1a.png")
function SWEP:DrawCursor()
	if self.Owner:InVehicle() then return end
	local ply = LocalPlayer()
		
	local length = 12
	
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	
	local cr = GetConVar("noxrp_crosshair_r"):GetInt()
	local cg = GetConVar("noxrp_crosshair_g"):GetInt()
	local cb = GetConVar("noxrp_crosshair_b"):GetInt()
	
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect( x - 1, y - 1, 3, 3)
	
	surface.DrawRect( x - length - 8, y - 1, length, 3)
	surface.DrawRect( x + 8, y - 1, length, 3)
	
	surface.DrawRect( x - 1, y - length - 8, 3, length)
	surface.DrawRect( x - 1, y + 8, 3, length)
	
	surface.SetDrawColor(cr, cg, cb)
	
	surface.DrawRect( x, y, 1, 1)

	surface.DrawRect( x - length - 7, y, length - 2, 1)
	surface.DrawRect( x + 9, y, length - 2, 1)
	
	surface.DrawRect( x, y - length - 7, 1, length - 2)
	surface.DrawRect( x, y + 9, 1, length - 2)
end