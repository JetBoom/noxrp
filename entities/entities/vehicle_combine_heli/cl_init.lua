include("shared.lua")

function ENT:Initialize()
	self:SetSequence("idle")
	
	self.AmbientSound = CreateSound(self, "npc/attack_helicopter/aheli_rotor_loop1.wav")
	self.AmbientSound:SetSoundLevel(100)
	
	
	self.DriverFiringSound = CreateSound(self, "npc/attack_helicopter/aheli_weapon_fire_loop3.wav")
	self.MaxRotorSpeed = 3
	self.RotorSpeed = 0
	self.RotorAng = 0
	
	self.NextRotorGroundEffect = 0
end

function ENT:RefillAmmo(slot)
	net.Start("refillVehAmmo")
		net.WriteInt(slot, 4)
	net.SendToServer()
end

function ENT:Examine()
	GAMEMODE:AddLocalNotification("This is a Combine Helicopter.", 8, Color(100, 255, 100), 1)
	GAMEMODE:AddLocalNotification("Integrity: "..self:Health().."/1000", 8, Color(100, 255, 100), 1)
	GAMEMODE:AddLocalNotification("Bullets: "..self:GetBulletAmount().."/1000", 8, Color(100, 255, 100), 1)
	GAMEMODE:AddLocalNotification("Missiles: "..self:GetMissileAmount().."/10", 8, Color(100, 255, 100), 1)
	GAMEMODE:AddLocalNotification("Fuel: "..self:GetFuel().."/1000", 8, Color(100, 255, 100), 1)
end

function ENT:ToInventory()
	net.Start("vehToInventory")
	net.SendToServer()
end

function ENT:AddWorldInteractionOptions(dmenu)
	--dmenu:AddOption("Refill Bullets", function() self:RefillAmmo(0) end)
	--dmenu:AddOption("Refill Missiles", function() self:RefillAmmo(1) end)
	--dmenu:AddOption("Refill Fuel", function() self:RefillAmmo(2) end)
	--dmenu:AddOption("Examine", function() self:Examine() end)
	
	LocalPlayer().WorldInteractionList = {
		{Title = "Refill Bullets", Function = function() self:RefillAmmo(0) end},
		{Title = "Refill Missiles", Function = function() self:RefillAmmo(1) end},
		{Title = "Refill Fuel", Function = function() self:RefillAmmo(2) end},
		{Title = "Examine", Function = function() self:Examine() end},
		{Title = "To Inventory", Function = function() self:ToInventory() end}
	}
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	if self:GetOn() then
		self.AmbientSound:Play()
		
		if self:GetDriverFiring() then
			self.DriverFiringSound:Play()
		else
			self.DriverFiringSound:Stop()
		end
		
		if self.RotorSpeed < self.MaxRotorSpeed then
			self.RotorSpeed = math.Approach(self.RotorSpeed, self.MaxRotorSpeed, FrameTime() * 0.8)
			
			self.AmbientSound:PlayEx(1, 100 * (self.RotorSpeed / self.MaxRotorSpeed))
		end
		
		if self:Health() < (self:GetMaxHealth() * 0.2) then
			if not self.NextAlarm then self.NextAlarm = 0 end
			if self.NextAlarm < CurTime() then
				self.NextAlarm = CurTime() + 1.5
				self:EmitSound("ambient/alarms/klaxon1.wav")
			end
		end
	else
		if self.RotorSpeed > 0 then
			self.RotorSpeed = math.Approach(self.RotorSpeed, 0, FrameTime() * 0.3)
			
			self.AmbientSound:PlayEx(1, 100 * (self.RotorSpeed / self.MaxRotorSpeed))
			
			if self.RotorSpeed == 0 then
				self.AmbientSound:Stop()
			end
		end
	end
end

local glow = Material("sprites/light_glow02_add")
local tube = Material("trails/tube")
function ENT:Draw()
	self:DrawModel()
	
	local emitter = ParticleEmitter(self:GetPos())
	
	self.RotorAng = self.RotorAng + 360 * FrameTime() * self.RotorSpeed
	
	local rotor = self:LookupBone("Chopper.Rotor_Blur")
	if rotor then
		self:ManipulateBoneAngles(rotor, Angle(self.RotorAng, 0, 0))
	end
	
	local rotorb = self:LookupBone("Chopper.Blade_Tail")
	if rotorb then
		self:ManipulateBoneAngles(rotorb, Angle(0, 0, self.RotorAng))
	end
	
	local rotorh = self:LookupBone("Chopper.Blade_Hull")
	if rotorh then
		self:ManipulateBoneAngles(rotorh, Angle(0, 0, self.RotorAng))
	end
	
	if self.RotorSpeed > 0 then
		if self.NextRotorGroundEffect < CurTime() then
			local trace = {mask = MASK_HOVER, filter = self}
			trace.start = self:GetPos()
			trace.endpos = trace.start + Vector(0, 0, -250)
			local tr = util.TraceLine(trace)

			if tr.Hit then
				if tr.MatType == MAT_SLOSH then
					local effect = EffectData()
						effect:SetOrigin(tr.HitPos)
						effect:SetNormal(tr.HitNormal)
						effect:SetScale(20)
					util.Effect("waterripple", effect)
					
					sound.Play("ambient/water/water_splash"..math.random(1, 3)..".wav", tr.HitPos, 100)
					
					self.NextRotorGroundEffect = CurTime() + 0.4
				else
					local effect = EffectData()
						effect:SetOrigin(tr.HitPos + tr.HitNormal * 1)
						effect:SetNormal(Vector(0, 0, tr.Fraction))
					util.Effect("dustpuff", effect)
					
					self.NextRotorGroundEffect = CurTime() + 0.05
				end
			end
		end
	end
	
	if self:Health() <= (self:GetMaxHealth() * 0.4) then
		for i = 1, 2 do
			local particle = emitter:Add("particle/smokestack", self:GetPos())
				particle:SetDieTime(2)
				particle:SetStartAlpha(150)
				particle:SetEndAlpha(0)
				particle:SetStartSize(18)
				particle:SetEndSize(18)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(50, 50, 50, 255)
				particle:SetVelocity(VectorRand() * 50)
				particle:SetAirResistance(math.random(10, 50))
		end
			
		if self:Health() <= (self:GetMaxHealth() * 0.3) then
			local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self:GetPos())
				particle:SetDieTime(0.5)
				particle:SetStartAlpha(150)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(12, 16))
				particle:SetEndSize(8)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
		end
			
		if self:Health() <= (self:GetMaxHealth() * 0.2) then
			local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self:GetPos() - self:GetForward() * 220 - self:GetRight() * 5)
				particle:SetDieTime(0.5)
				particle:SetStartAlpha(150)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(12, 16))
				particle:SetEndSize(8)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
		end
			
		if self:Health() <= (self:GetMaxHealth() * 0.1) then
			local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self:GetPos() + self:GetRight() * 60 - self:GetUp() * 40)
				particle:SetDieTime(0.5)
				particle:SetStartAlpha(150)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(12, 16))
				particle:SetEndSize(8)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
					
			local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self:GetPos() - self:GetRight() * 60 - self:GetUp() * 40)
				particle:SetDieTime(0.5)
				particle:SetStartAlpha(150)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(12, 16))
				particle:SetEndSize(8)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
		end
	end
		
	if self:GetOn() then
		if math.Round(CurTime()%2) == 1 then
			render.SetMaterial(glow)
			render.DrawSprite(self:GetPos() + self:GetRight() * 95 + self:GetUp() * -50 + self:GetForward() * 10, 64, 64, Color(255, 0, 0))
			render.DrawSprite(self:GetPos() - self:GetRight() * 95 + self:GetUp() * -50 + self:GetForward() * 10, 64, 64, Color(255, 0, 0))
			render.DrawSprite(self:GetPos() - self:GetUp() * 50 - self:GetForward() * 170, 64, 64, Color(255, 0, 0))
		end
		
		if LocalPlayer():KeyDown(IN_SPEED) and self:GetVelocity():Length2D() > 400 then
			local right = self:GetPos() + self:GetRight() * 95 + self:GetUp() * -50 + self:GetForward() * 10
			local left = self:GetPos() - self:GetRight() * 95 + self:GetUp() * -50 + self:GetForward() * 10
			
			local particle = emitter:Add("particle/smokestack", right)
				particle:SetDieTime(1)
				particle:SetStartAlpha(20)
				particle:SetEndAlpha(0)
				particle:SetStartSize(18)
				particle:SetEndSize(18)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255, 255, 255)
				particle:SetVelocity(VectorRand() * 10)
				particle:SetAirResistance(math.random(10, 50))
				particle:SetLighting(true)
				
			local particle = emitter:Add("particle/smokestack", left)
				particle:SetDieTime(1)
				particle:SetStartAlpha(20)
				particle:SetEndAlpha(0)
				particle:SetStartSize(18)
				particle:SetEndSize(18)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255, 255, 255)
				particle:SetVelocity(VectorRand() * 10)
				particle:SetAirResistance(math.random(10, 50))
				particle:SetLighting(true)
		end
	end
	
	emitter:Finish()
end

function ENT:DrawOnHUD()
	local ply = LocalPlayer()

	local data = {}
		data.start = ply:GetShootPos()
		data.endpos = data.start + ply:GetAimVector() * 2000
		data.filter = {ply, self}
	
	local tr = util.TraceLine(data)
	local screen = tr.HitPos:ToScreen()
		
	local length = 12
	
	local x = screen.x
	local y = screen.y
	
	local cr = GetConVar("noxrp_crosshair_r"):GetInt()
	local cg = GetConVar("noxrp_crosshair_g"):GetInt()
	local cb = GetConVar("noxrp_crosshair_b"):GetInt()
	
	surface.SetDrawColor(0, 0, 0)
	
	surface.DrawRect( x - 1, y - length - 8, 3, length)
	surface.DrawRect( x - 1, y + 8, 3, length)
	surface.DrawRect( x - 8 - length, y - 1, length, 3)
	surface.DrawRect( x + 8, y - 1, length, 3)
	
	surface.SetDrawColor(cr, cg, cb)
	
	surface.DrawRect( x, y - length - 7, 1, length - 2)
	surface.DrawRect( x, y + 9, 1, length - 2)
	surface.DrawRect( x - 7 - length, y, length - 2, 1)
	surface.DrawRect( x + 9, y, length - 2, 1)
	
	
	local ammo = self:GetBulletAmount()
	local missiles = self:GetMissileAmount()
	local health = self:Health()
	local fuel = self:GetFuel()
	local col = Color(255, 255, 255)
	
	surface.SetFont("hidden16")
	local str1 = "Ammo: "..ammo.."/1000"
	local lx, ly = surface.GetTextSize(str1)
	
	draw.SlantedRectHorizOffset(ScrW() - lx - 15, ScrH() - 200 - ly * 0.5, lx + 20, ly * 2, 5, Color(20, 20, 20, 200), Color(0, 0, 0, 255), 1, 1)
	
	if ammo == 0 then
		col = Color(200 + math.sin(CurTime() * 8) * 55, 0, 0)
	else
		col = Color(50, 255, 50)
	end
	draw.SimpleText(str1, "hidden16", ScrW() - 5, ScrH() - 200, col, TEXT_ALIGN_RIGHT)
	
	
	if missiles == 0 then
		col = Color(200 + math.sin(CurTime() * 8) * 55, 0, 0)
	else
		col = Color(50, 255, 50)
	end
	local str2 = "Missiles: "..missiles.."/10"
	lx, ly = surface.GetTextSize(str2)
	
	draw.SlantedRectHorizOffset(ScrW() - lx - 15, ScrH() - 160 - ly * 0.5, lx + 20, ly * 2, 5, Color(20, 20, 20, 200), Color(0, 0, 0, 255), 1, 1)
	draw.SimpleText(str2, "hidden16", ScrW() - 5, ScrH() - 160, col, TEXT_ALIGN_RIGHT)
	
	
	if fuel == 0 then
		col = Color(200 + math.sin(CurTime() * 8) * 55, 0, 0)
	else
		col = Color(50, 255, 50)
	end
	local str3 = "Fuel: "..fuel.."/1000"
	lx, ly = surface.GetTextSize(str3)
	
	draw.SlantedRectHorizOffset(ScrW() - lx - 15, ScrH() - 70 - ly * 0.5, lx + 20, ly * 2, 5, Color(20, 20, 20, 200), Color(0, 0, 0, 255), 1, 1)
	draw.SimpleText(str3, "hidden16", ScrW() - 5, ScrH() - 70, col, TEXT_ALIGN_RIGHT)
	
	
	if health >= self:GetMaxHealth() * 0.5 then
		col = Color(0, 255, 0)
	elseif health >= self:GetMaxHealth() * 0.35 then
		col = Color(255, 255, 0)
	elseif health >= self:GetMaxHealth() * 0.15 then
		col = Color(255, 150, 0)
	else
		col = Color(200 + math.sin(CurTime() * 8) * 55, 0, 0)
	end
	local str4 = "Integrity: "..health.."/1000"
	lx, ly = surface.GetTextSize(str4)
	
	draw.SlantedRectHorizOffset(ScrW() - lx - 15, ScrH() - 30 - ly * 0.5, lx + 20, ly * 2, 5, Color(20, 20, 20, 200), Color(0, 0, 0, 255), 1, 1)
	draw.SimpleText(str4, "hidden16", ScrW() - 5, ScrH() - 30, col, TEXT_ALIGN_RIGHT)
end

function ENT:GetViewTable(ply, pos, ang, fov)
	local data = {}
		data.start = pos
		data.endpos = pos + self:GetForward() * -500 + self:GetUp() * 200
		data.filter = {ply, self, self:GetDriverSeat()}
		data.mins = Vector(-4, -4, -4)
		data.maxs = Vector(4, 4, 4)
		
	local tr = util.TraceHull(data)
	
	local tab = {}
		tab.origin = tr.HitPos
		tab.angles = angles
		tab.fov = fov
		
	return tab
end