include("shared.lua")

SWEP.PrintName = "Melee Base"
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.SprintAngles = Angle(-30, -10, 0)
	
SWEP.Icon = "b"
SWEP.Font = "HL2Icons"
	
SWEP.NoHolsterModel = true

function SWEP:DrawWorldModel()
	if not self:GetHolstered() then
		self:Cons_DrawWorldModel()
	end
end
	
function SWEP:StartBlocking()
--	self:SetWeaponHoldType("melee2")
end

function SWEP:StopBlocking()
	self:SetNextPrimaryFire(CurTime() + 1)
	
--	self:SetWeaponHoldType(self.HoldType)
end

SWEP.LerpAngVM = 0
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
	elseif self:GetBlocking() then
		angr.r = 20
		angr.y = -30
		self.LerpAngVM = math.Approach(self.LerpAngVM, 1, FrameTime() * 4)
		
		if not self.LastViewMod == angr or self.LastViewMod == nil  then
			self.LastViewMod = angr
		end
	elseif self:GetOwner():IsSprinting() and self.NextLerpTime < CurTime() and self:GetNextPrimaryFire() < CurTime() then
		angr = self.SprintAngles
		posr = self.SprintVector
		
		self.LerpAngVM = math.Approach(self.LerpAngVM, 1, FrameTime() * 2)
		
		if not self.LastViewMod == angr or self.LastViewMod == nil  then
			self.LastViewMod = angr
		end
	elseif self.LerpAngVM > 0 then
		angr = self.LastViewMod
		self.LerpAngVM = math.Approach(self.LerpAngVM, 0, FrameTime() * 3)
		
		if self.LerpAngVM == 0 then
			self.LastViewMod = nil
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