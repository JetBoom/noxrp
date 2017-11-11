SWEP.Base = "weapon_bullets_base"

if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.PrintName = "'AWP' Heavy Sniper"
	SWEP.PrintName2 = ".308 Sniper Rifle"
	
	SWEP.Font = "csKillIcons"
	SWEP.Icon = "r"
	
	SWEP.PosX = 0
	SWEP.PosY = 20
	
	SWEP.HUDPosY = 15
	
	SWEP.BoneDeltaAngles = {Up = 0, Right = 180, Forward = 180, MU = -12, MR = 3, MF = -8, Scale = 1}
	
	SWEP.SprintAngles = Angle(-10, 0, 40)
	SWEP.SprintVector = Vector(5, 0, 0)
	
	SWEP.Ammo3DBone = "v_weapon.awm_parent"
	SWEP.Ammo3DPos = Vector(-0.6, -7.2, 0)
	SWEP.Ammo3DAng = Angle(0, 0, 0)
	SWEP.Ammo3DScale = 0.013
end

SWEP.Item = "sniper_awp"
SWEP.AmmoItem = "ammobox_sniper"

SWEP.Slot = 7
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"

SWEP.ShootSound = Sound("Weapon_AWP.Single")
SWEP.ReloadSound = Sound("Weapon_AWP.Reload")

SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Recoil = 5
SWEP.Primary.Tracer = "HelicopterTracer"

SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 1

SWEP.HoldType = "ar2"
SWEP.WeaponType = WEAPON_TYPE_GUN

SWEP.NextZoom = 0
--[[
function SWEP:SetZoomed(bool)
	self:SetDTBool(2, bool)
end

function SWEP:GetZoomed()
	return self:GetDTBool(2)
end]]

function SWEP:SetZoomed(level)
	self:SetDTInt(2, level)
end

function SWEP:GetZoomLevel()
	return self:GetDTInt(2)
end

function SWEP:GetZoomed()
	return self:GetDTInt(2) > 0
end

function SWEP:SecondaryAttack()
	if self:GetHolstered() then return end
	self.NextZoom = self.NextZoom or CurTime()
	if CurTime() < self.NextZoom then return end
	self.NextZoom = CurTime() + 0.5
--[[
	local zoomed = self:GetZoomed()
	if SERVER then self:SetZoomed(not zoomed) end
	if zoomed then
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.3)
		end
		self.Weapon:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)
	else
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired") * 0.2, 0.4)
		end
		
		self.Weapon:EmitSound("weapons/sniper/sniper_zoomin.wav", 50, 100)
	end]]
	
	local zoomed = self:GetZoomLevel()
	if zoomed == 0 then
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired") * 0.2, 0.4)
		end
		
		self:EmitSound("weapons/sniper/sniper_zoomin.wav", 50, 100)
		
		self:SetZoomed(1)
	elseif zoomed == 1 then
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired") * 0.05, 0.4)
		end
		
		self:EmitSound("weapons/sniper/sniper_zoomin.wav", 50, 100)
		
		self:SetZoomed(2)
	else
		if SERVER then
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.3)
		end
		self.Weapon:EmitSound("weapons/sniper/sniper_zoomout.wav", 50, 100)
		
		self:SetZoomed(0)
	end
end

function SWEP:Holster()
	if CLIENT then
		if self.Owner.LoadoutEffect then
			self.Owner.LoadoutEffect:WeaponHolster(self)
		end
		if self:GetZoomed() then
			surface.PlaySound("weapons/sniper/sniper_zoomin.wav")
		end
	else
		if self:GetZoomed() then
			local zoomed = self.Owner:GetZoomed()
			self.Owner:SetFOV(self.Owner:GetInfo("fov_desired"), 0.4)
		end
	end
	return true
end


if CLIENT then
	function SWEP:AdjustMouseSensitivity()
		if self:GetZoomed() then
			if self:GetZoomLevel() == 1 then
				return 0.95
			elseif self:GetZoomLevel() == 2 then
				return 0.8
			end
		end
	end

	function SWEP:DrawHUD()
		local zoomed = self:GetZoomed()
		if zoomed then
			self:DrawZoomCursor()
			if self:HasEnhancement("echip_pulse") then
				self:DrawOverlayEffect()
			end
		else
			if GetConVarNumber("noxrp_drawhud") == 1 then
				self:DrawCursor()
			end
		end
	end
	
	function SWEP:PreDrawViewModel(vm)
		if self.ShowViewModel == false or self:GetZoomed() then
			render.SetBlend(0)
		end
	end

	function SWEP:PostDrawViewModel(vm)
		if self.ShowViewModel == false or self:GetZoomed() then
			render.SetBlend(1)
		end
		
	
		local pos, ang = self:GetAmmo3DPos(vm)
		
		if pos then
			self:Draw3DAmmo(vm, pos, ang)
		end
	end
	
	local texScope = surface.GetTextureID("gui/gradient", "smooth")
	function SWEP:DrawZoomCursor()
		local scrw, scrh = ScrW(), ScrH()
				
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(0, scrh * 0.5 - 5, scrw * 0.35, 10)
		surface.DrawRect(ScrW() * 0.65, scrh * 0.5 - 5, scrw * 0.35, 10)
		surface.DrawRect(ScrW() * 0.35, scrh * 0.5 - 2, scrw * 0.3, 4)
		
		surface.DrawRect(scrw * 0.5 - 5, 0, 10, scrh * 0.35)
		surface.DrawRect(scrw * 0.5 - 5, scrh * 0.65, 10, scrh * 0.35)
		surface.DrawRect(scrw * 0.5 - 2, scrh * 0.35, 4, scrh * 0.3)
				
		local size = math.min(scrw, scrh)
		surface.SetTexture(texScope)
		surface.SetDrawColor(10, 10, 10, 255)
		surface.DrawTexturedRect(0, 0, ScrW() * 0.5, ScrH())
		surface.DrawTexturedRectRotated(ScrW() * 0.5, ScrH() * 0.75, ScrH() * 0.5, ScrW(), 90)
		surface.DrawTexturedRectRotated(ScrW() * 0.5, ScrH() * 0.25, ScrH() * 0.5, ScrW(), -90)
		surface.DrawTexturedRectRotated(ScrW() * 0.75 + 2, ScrH() * 0.5, ScrW() * 0.5, ScrH(), 180)
	end
	
	function SWEP:DrawOverlayEffect()
		local scrw, scrh = ScrW(), ScrH()
		
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(ScrW() - 220, scrh * 0.5 - 25, 220, 20)
		surface.DrawRect(ScrW() - 220, scrh * 0.5 + 5, 220, 20)
		
		local tr = LocalPlayer():GetEyeTrace()
				
		local dist = tr.HitPos:Distance(LocalPlayer():GetShootPos())
				
		if dist >= 4000 then
			dist = "---"
		else
			dist = tostring(math.Round(dist))
		end
				
		draw.SimpleText("Distance: "..dist, "hidden18", ScrW() - 10, ScrH() * 0.5 - 15, Color(200, 255, 200, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		
		local name
		if tr.Entity:IsValid() then
			if tr.Entity:IsPlayer() then
				name = tr.Entity:Nick()
			elseif CLEANNAMES[tr.Entity:GetClass()] then
				name = CLEANNAMES[tr.Entity:GetClass()]
			end
			
			if name then
				draw.SimpleText("Target: "..name, "hidden18", ScrW() - 10, ScrH() * 0.5 + 15, Color(200, 255, 200, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end
		
	--	for _, ent in pairs(ents.FindInSphere(self:GetOwner():GetPos(), 4000)) do
	--		if self:GetOwner():IsFacing(ent, 0.7, self:GetOwner():GetAimVector()) then
	--		end
	--	end
	end
	
	function SWEP:PostDrawViewModel(vm)
		if self.ShowViewModel == false then
			render.SetBlend(1)
		end
		
		if self:GetZoomed() then return end
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
			self:Draw3DAmmo(vm, pos, ang)
		end
	end
end