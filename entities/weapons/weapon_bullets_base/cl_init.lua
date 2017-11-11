include("shared.lua")

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Icon = "a"
SWEP.Font = "csKillIcons"
SWEP.PosX = 0
SWEP.PosY = 0

SWEP.DLightColor = Color(255,255,255)
SWEP.DLightSize = 256
SWEP.DLightDecay = 256
SWEP.DLightBrightness = 1

SWEP.CrosshairScale = 1

SWEP.PrintName = "Bullets Base"

SWEP.SprintAngles = Angle(-5, 0, 30)
SWEP.SprintVector = Vector(5, 0, -1)

SWEP.Ammo3DBone = "base"
SWEP.Ammo3DPos = Vector(0, 0, 0)
SWEP.Ammo3DAng = Angle(180, 0, 0)
SWEP.Ammo3DScale = 0.02

SWEP.IronSightsPos = Vector(-3, 0, 0)
SWEP.IronSightsAng = Angle(0, 0, 0)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(2)

	self.BaseStats = {}

	self:Cons_SetupClientModels()

	local itemref = self:GetItemID()

	if self.Owner == LocalPlayer() then
		local item = self.Owner:GetItemByID(itemref)
		if item then
			--print("he have item!", item:GetDataName())
			self.Primary.Damage = item.Damage
			self.BaseStats.Damage = item.Damage

			self.Primary.NumShots = item.NumShots
			self.BaseStats.NumShots = item.NumShots

			self.Primary.Delay = item.Delay
			self.BaseStats.Delay = item.Delay

			self.Cone = item.Cone
			self.BaseStats.Cone = item.Cone

			self.Primary.ClipSize = item.ClipSize
			self.BaseStats.ClipSize = item.ClipSize

			--print(self.Primary.ClipSize)

			if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
				self.Owner.LoadoutEffect:WeaponInitialize(self)
			end

			self:UpdateEnhancements()
		end
	else
		self.Primary.ClipSize = -1
		self.Primary.Damage = 1
		self.Primary.NumShots = 1
		self.Primary.Delay = 0
		self.Cone = 0
	end

	if self.PostInitialize then
		self:PostInitialize()
	end
end

function SWEP:OnRemove()
	if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
		self.Owner.LoadoutEffect:WeaponRemove(self.Slot)
	end
end

function SWEP:HolsterEffect()
	if self.Owner.LoadoutEffect and self.Owner.LoadoutEffect ~= nil then
		if not self.DrawWhileHolstered then
			self.Owner.LoadoutEffect:WeaponHolster(self)
		end
	end
end

function SWEP:GetAmmoCounterColor()
	local line1, line2, line3 = Color(255, 255, 255, 255), Color(255, 255, 255, 255), Color(255, 255, 255, 255)

	if self:Clip1() <= 0 then
		line1 = Color(255, 100, 100, 255)
	elseif self:Clip1() <= (self.Primary.ClipSize * 0.3) then
		line1 = Color(255, 255, 0, 255)
	end

	if self:GetOwner():GetAmmoCount(self.Primary.Ammo) == 0 then
		line2 = Color(255, 100, 100, 255)
	elseif self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= (self.Primary.ClipSize * 2) then
		line2 = Color(255, 255, 100, 255)
	end

	if self:GetDurability() <= 30 then
		local times = 80 * math.sin(CurTime() * 4)
		if self:GetDurability() == 0 then
			line3 = Color(255, 50, 50, 175 + times)
		else
			line3 = Color(255, 255, 180, 175 + times)
		end
	end

	return line1, line2, line3
end

function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	local vm = self.Owner:GetViewModel()
	local angr = Angle(0, 0, 0)
	local posr = Vector(0, 0, 0)

	if self:GetReloadEnd() < CurTime() then
		if self:GetHolstered() then
			angr.p = -30
			angr.r = -10
			self.LerpAngVM = math.Approach(self.LerpAngVM, 1, (1 / self.HolsterTime) * FrameTime())

			if not self.LastViewMod == angr or self.LastViewMod == nil then
				self.LastViewMod = angr
			end
		elseif self:GetIronSights() then
			posr = self.IronSightsPos
			angr = self.IronSightsAng

			self.LerpAngVM = math.Approach(self.LerpAngVM, 1, FrameTime() * 2)
			if not self.LastViewPos == posr or self.LastViewPos == nil then
				self.LastViewPos = posr
			end
			if not self.LastViewMod == angr or self.LastViewMod == nil then
				self.LastViewMod = angr
			end
		elseif (self:GetOwner():IsSprinting() or self:GetOwner():KeyDown(IN_WALK)) and self:GetOwner():GetVelocity():Length2D() > 50 and self:GetNextSprintLerp() < CurTime() then
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
	end

	return pos, ang
end

local gradient = surface.GetTextureID("gui/gradient")
local Tex_Corner8 = surface.GetTextureID( "gui/corner8" )

function SWEP:Draw3DAmmo(vm, pos, ang)
	if not self:GetOwner():GetItemByID(self:GetItemID()) then return end
	local clip = self:Clip1()
	local maxclip = self.Primary.ClipSize
	local totalammo = self:GetOwner():GetAmmoCount(self.Primary.Ammo)
	local ammoboxes = self:GetOwner():GetItemCount(self.AmmoItem)

	local lc1, lc2, ic = self:GetAmmoCounterColor()
	local x = -200
	local y = 0
	local width = 200
	local height = 100
	local durability = self:GetDurability()
	local maxdur = self:GetOwner():GetItemByID(self:GetItemID()):GetData().MaxDurability or 150

	cam.Start3D2D(pos, ang, self.Ammo3DScale)
		draw.RoundedBoxEx(8, x, y, width, height, Color(0, 0, 0, 220), true, false, true, false)
		draw.SimpleText(clip.."/"..maxclip, "nulshock38", x + width * 0.4, y + 40, lc1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		lc1.a = 40
		draw.SimpleText(clip.."/"..maxclip, "nulshock38", x + width * 0.4 + 2, y + 42, lc1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(totalammo, "nulshock32", x + width * 0.4, y + 70, lc2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


		draw.SimpleText(" // ", "hidden18", x + width * 0.4, y + 10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if #self.Modifications > 0 then
			if self.Modifications[1] then
				local item = ITEMS[self.Modifications[1].Name]
				local col = item:GetLetterColor()

				draw.SimpleText(item.AmmoLetter, "hidden18", x + width * 0.4 + 10, y + 10, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("[N/A]", "hidden18", x + width * 0.4 + 10, y + 10, Color(255, 255, 255, 150 + 100 * math.sin(CurTime() * 4)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			if self.Modifications[2] then
				local item = ITEMS[self.Modifications[2].Name]
				local col = item:GetLetterColor()
				draw.SimpleText(item.AmmoLetter, "hidden18", x + width * 0.4 - 10, y + 10, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("[N/A]", "hidden18", x + width * 0.4 - 10, y + 10, Color(255, 255, 255, 150 + 100 * math.sin(CurTime() * 4)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		else
			draw.SimpleText("[N/A]", "hidden18", x + width * 0.4 + 10, y + 10, Color(255, 255, 255, 150 + 100 * math.sin(CurTime() * 4)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("[N/A]", "hidden18", x + width * 0.4 - 10, y + 10, Color(255, 255, 255, 150 + 100 * math.sin(CurTime() * 4)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		if durability == 0 then
			draw.SimpleText("[BROKE]", "hidden14", x + width * 0.25, y + height - 10, ic, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			local col = Color(255 - 255 * (durability / maxdur), 255 * (durability / maxdur), 0)
			//draw.SimpleText(math.Round(durability).."%", "nulshock22", x + width * 0.25 or 0, y + height - 10, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(x + 5, y + height - 10, width * 0.8, 6)
			surface.SetDrawColor(col)
			surface.DrawRect(x + 6, y + height - 9, (width * 0.8 - 2) * (durability / maxdur), 4)
		end
	cam.End3D2D()
end

function SWEP:GetAmmo3DPos(vm)
	if vm:ViewModelIndex() == 0 then
		local bone = vm:LookupBone(self.Ammo3DBone)
		if not bone then return end

		local m = vm:GetBoneMatrix(bone)
		if not m then return end

		local pos, ang = m:GetTranslation(), m:GetAngles()

		if self.ViewModelFlip then
			ang.r = -ang.r
		end

		local offset = self.Ammo3DPos
		local aoffset = self.Ammo3DAng

		pos = pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z

		if aoffset.yaw ~= 0 then ang:RotateAroundAxis(ang:Up(), aoffset.yaw) end
		if aoffset.pitch ~= 0 then ang:RotateAroundAxis(ang:Right(), aoffset.pitch) end
		if aoffset.roll ~= 0 then ang:RotateAroundAxis(ang:Forward(), aoffset.roll) end

		return pos, ang
	end
end

function SWEP:DrawHUD()
	if LocalPlayer().IsCrafting then return end

	if GetConVarNumber("noxrp_drawhud") == 1 then
		self:DrawCursor()
	end
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end

	local pos, ang = self:GetAmmo3DPos(vm)

	if self.Modifications then
		for _, mod in pairs(self.Modifications) do
			local gitem = ITEMS[mod.Name]
			if gitem.DrawViewModelEffects then
				gitem:DrawViewModelEffects(self, vm)
			end
		end
	end

	if pos then
		if self.DrawCustom3DAmmo then
			self:DrawCustom3DAmmo(vm, pos, ang)
		else
			self:Draw3DAmmo(vm, pos, ang)
		end
	end

	if self.ExtraPostDrawViewModel then
		self:ExtraPostDrawViewModel(vm)
	end
end

function SWEP:AdjustMouseSensitivity()
	return 1
end

function SWEP:GetCurrentCone()
	if self:GetIronSights() then
		return self.Cone * 0.8
	else
		return self.Cone
	end
end

local crosshair = Material("noxrp/crosshairs/crosshair1.png")
local crosshaira = Material("noxrp/crosshairs/crosshair1a.png")
local prevdist = 0
function SWEP:DrawCursor()
	if self.Owner:InVehicle() then return end
	local ply = LocalPlayer()

	local length = 4

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	local cr = GetConVar("noxrp_crosshair_r"):GetInt()
	local cg = GetConVar("noxrp_crosshair_g"):GetInt()
	local cb = GetConVar("noxrp_crosshair_b"):GetInt()

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect( x - 1, y - 1, 3, 3)

	local cone = self:GetCurrentCone()

	--local dist = 1000 * math.tan(math.rad(cone))
	prevdist = math.Approach(prevdist, 1000 * math.tan(math.rad(cone)), FrameTime() * 130)

	surface.DrawRect( x - prevdist - length, y - 1, length, 3)
	surface.DrawRect( x + prevdist + 1, y - 1, length, 3)

	surface.DrawRect( x - 1, y - prevdist - length, 3, length)
	surface.DrawRect( x - 1, y + prevdist + 1, 3, length)

	surface.SetDrawColor(cr, cg, cb)

	surface.DrawRect( x, y, 1, 1)

	surface.DrawRect( x - prevdist - length + 1, y, length - 2, 1)
	surface.DrawRect( x + prevdist + 2, y, length - 2, 1)

	surface.DrawRect( x, y - length - prevdist + 1, 1, length - 2)
	surface.DrawRect( x, y + prevdist + 2, 1, length - 2)
end