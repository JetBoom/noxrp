AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Combine_Helicopter.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
		phys:SetMass(1500)
		phys:EnableMotion(true)
		phys:EnableDrag(false)
		phys:Wake()
	end
	
	self:StartMotionController()
	
	self:SetUseType(SIMPLE_USE)
	
	self:CreateVehicleParts()
	
	self:SetSequence("idle")
	
	self:SetBulletAmount(0)
	self:SetMissileAmount(0)
	self:SetOn(false)
	self:SetHealth(1000)
	self:SetMaxHealth(1000)
	self:SetFuel(0)
	
	self.MissileAlt = false
	self.TurnOnTime = 0
	self.NextEngineToggle = 0
	self.NextConsumeFuel = 0

	self.NextAmmoAlert = 0
end

function ENT:OnTakeDamage(cdmg)
	if cdmg:GetInflictor() == self or cdmg:GetDamageType() == DMG_NONLETHAL then cdmg:SetDamage(0) return end
	if self:GetDriverSeat():GetDriver():IsValid() then
		if cdmg:GetAttacker() == self:GetDriverSeat():GetDriver() then cdmg:SetDamage(0) return end
	end
	
	if cdmg:IsBulletDamage() then
		cdmg:ScaleDamage(0.15)
	end
	
	self:SetHealth(self:Health() - cdmg:GetDamage())
	
	if self:Health() <= 0 and not self.ExplodeTime then
		self.ExplodeTime = CurTime() + 3
		self:EmitSound("npc/attack_helicopter/aheli_damaged_alarm1.wav")
	end
end

function ENT:CreateVehicleParts()
	--self:SetPos(self:GetPos() + Vector(0, 0, 200))
	local vPos = self:GetPos()
	
	local ent = ents.Create("prop_vehicle_prisoner_pod")
	if ent:IsValid() then
		ent:SetKeyValue("model", "models/props_phx/carseat2.mdl")
		ent:SetKeyValue("solid", "6")
		ent:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
		ent:SetPos(vPos + self:GetForward() * 130 + self:GetUp() * -55)
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		
		--ent:SetNoDraw(true)
		ent:SetVehicleParent(self)
		ent:GetPhysicsObject():SetMass(20)
		--constraint.Weld(self, ent, 0, 0, 0, 1)
		ent:SetParent(self)
		ent:SetLocalAngles(Angle(0, -90, 0))
		
		self:SetDriverSeat(ent)
		
		self:DeleteOnRemove(ent)
	end
end

function ENT:Use(pl)
	if not self:GetDriverSeat():GetDriver():IsValid() then
		self:PlayerEnterSeat(pl, self:GetDriverSeat())
	end
end

function ENT:PlayerGiveAmmo(pl, slot)
	if slot == 0 then
		if pl:HasItem("ammobox_smg") then
			pl:DestroyItemByName("ammobox_smg", 1)
			
			self:SetBulletAmount(self:GetBulletAmount() + 30)
			
			self:EmitSound("npc/turret_floor/click1.wav")
			
			pl:SendNotification("You put one ammobox in the guns.")
		else
			pl:SendNotification("You don't have any ammoboxes!")
		end
	elseif slot == 1 then
		if pl:HasItem("ammobox_missile") then
			pl:DestroyItemByName("ammobox_missile", 1)
			
			self:SetMissileAmount(self:GetMissileAmount() + 1)
			
			self:EmitSound("items/ammo_pickup.wav")
			
			pl:SendNotification("You put one missile in the mounts.")
		else
			pl:SendNotification("You don't have any missiles!")
		end
	elseif slot == 2 then
		if pl:HasItem("gasoline") then
			pl:DestroyItemByName("gasoline", 1)
			
			self:SetFuel(self:GetFuel() + 100)
			
			self:EmitSound("ambient/water/water_spray3.wav")
			
			pl:SendNotification("You put some gasoline in the tanks.")
		else
			pl:SendNotification("You don't have any gasoline!")
		end
	end
end

function ENT:PlayerEnterSeat(pl, veh)
	if veh == self:GetDriverSeat() then
		pl:EnterVehicle(veh)
		self:SetMainDriver(pl)
		self:GetPhysicsObject():EnableGravity(false)
		
		if self:GetFuel() > 0 then
			self:SetOn(true)
			self.TurnOnTime = CurTime() + 2
			self.FullyOn = false
		end
	end
end

function ENT:PlayerExitSeat(pl, veh)
	if veh == self:GetDriverSeat() then
		self:SetOn(false)
		self:SetMainDriver(NULL)
		self.FullyOn = false
	end
end

function ENT:Think()
	if self:WaterLevel() > 2 then
		self:Explode()
		return
	end
	
	if self.ExplodeTime then
		if self.ExplodeTime < CurTime() then
			self.ExplodeTime = nil
			self:Explode()
			return
		end
	end
	
	if self.PhysData then
		local data = self.PhysData
		self.PhysData = nil
		
		if data.Speed > 500 then
			local damage = data.Speed - 500
			damage = damage * 0.15
			
			self:TakeDamage(damage)
			
			sound.Play("physics/metal/metal_canister_impact_hard"..math.random(1, 3)..".wav", data.HitPos, 75, 100, 1)
		end
	end
	
	local driver = self:GetDriverSeat():GetDriver()
	if driver:IsValid() then
		if self:GetFuel() >= 0 then
			if driver:KeyDown(IN_RELOAD) then
				if not self.NextEngineToggle then self.NextEngineToggle = 0 end
				if self.NextEngineToggle < CurTime() then
					self.NextEngineToggle = CurTime() + 5
						
					self:SetOn(not self:GetOn())
					if not self:GetOn() then
						self.FullyOn = false
					else
						self.TurnOnTime = CurTime() + 2
					end
				end
			end
		end
	end
	
	if not self:GetOn() then return end
	
	if self:GetFuel() > 0 then
		if self.NextConsumeFuel < CurTime() then
			self.NextConsumeFuel = CurTime() + 1
			self:SetFuel(self:GetFuel() - 1)
		end
		if self.TurnOnTime < CurTime() and not self.FullyOn then
			self.FullyOn = true
			self:GetPhysicsObject():EnableGravity(false)
		end
	elseif self:GetOn() then
		self:SetOn(false)
		self.FullyOn = false
	end

	if driver:IsValid() then
		if driver:KeyDown(IN_ATTACK) then
			if self:GetBulletAmount() > 1 then
				if self:GetNextBullet() < CurTime() then
					local gun = self:LookupBone("Chopper.Gun")
					if gun then
						local bp, ba = self:GetBonePosition(gun)
						local data = {}
							data.start = driver:GetShootPos()
							data.endpos = data.start + driver:GetAimVector() * 2000
							data.filter = {driver, self, self:GetDriverSeat()}
						
						local tr = util.TraceLine(data)
						
						local dir = (tr.HitPos - (bp + ba:Forward() * 75)):GetNormalized()
						
						--[[local bullet = {}
						bullet.Src = bp + ba:Forward() * 75
						bullet.Dir = dir
						bullet.Distance = 2000
						bullet.Num = 2
						bullet.Tracer = 1
						bullet.Spread = Vector(math.Rand(-0.05, 0.05), math.Rand(-0.05, 0.05), 0)
						bullet.Damage = 20
						bullet.Attacker = driver
						bullet.TracerName = "AirboatGunTracer"
						
						self:FireBullets(bullet)]]
						
						local filter = {}
						filter = driver:GetAttackFilter()
						
						table.insert(filter, self)
						table.insert(filter, self:GetDriverSeat())
						
						for i=1, 2 do
							local pos = bp + ba:Forward() * 75
							local ang = AngleCone(dir:Angle(), 1)

							CreateBullet(pos, ang:Forward(), driver, self, 20, 2800, "projectile_asbullet", false, true, filter)
						end
						
						if not self:GetDriverFiring() then
							self:SetDriverFiring(true)
							self:EmitSound("NPC_CombineGunship.CannonStartSound")
						end
						
						self:SetBulletAmount(self:GetBulletAmount() - 2)
						self:SetNextBullet(CurTime() + 0.15)
					end
				end
			elseif self.NextAmmoAlert < CurTime() then
				self.NextAmmoAlert = CurTime() + 0.5
				self:SetNextBullet(CurTime() + 0.2)
				self:EmitSound("npc/turret_floor/ping.wav")
				if self:GetDriverFiring() then
					self:SetDriverFiring(false)
					self:EmitSound("NPC_CombineGunship.CannonStopSound")
				end
			end
		elseif self:GetDriverFiring() then
			self:SetDriverFiring(false)
			self:EmitSound("NPC_CombineGunship.CannonStopSound")
		end
		
		if driver:KeyDown(IN_ATTACK2) then
			if self:GetMissileAmount() > 0 then
				if self:GetNextMissile() < CurTime() then
					self:SetNextMissile(CurTime() + 1)
					
					local missile = ents.Create("projectile_missile")
					if missile then
						local data = {}
							data.start = driver:GetShootPos()
							data.endpos = data.start + driver:GetAimVector() * 2000
							data.filter = {driver, self, self:GetDriverSeat()}
							
						local tr = util.TraceLine(data)

						if self.MissileAlt then
							missile:SetPos(self:GetPos() + self:GetRight() * 65 + self:GetUp() * -70 + self:GetForward() * 10)
						else
							missile:SetPos(self:GetPos() - self:GetRight() * 65 + self:GetUp() * -70 + self:GetForward() * 10)
						end
						self.MissileAlt = not self.MissileAlt
						
						local dir = (tr.HitPos - missile:GetPos()):GetNormalized()
						local ang = dir:Angle()
						if ang.p > 180 then ang.p = 0 end
						ang.p = math.Clamp(ang.p, 0, 30)
						
						missile:SetAngles(ang)
						missile:Spawn()
						missile:SetOwner(driver)
						missile.Inflictor = driver
						missile.Attacker = driver
						
						local phys = missile:GetPhysicsObject()
						if phys:IsValid() then
							local fwd = missile:GetForward()
							phys:SetVelocityInstantaneous(fwd * 2000)
						end
						
						self:SetMissileAmount(self:GetMissileAmount() - 1)
						self:EmitSound("npc/env_headcrabcanister/launch.wav")
					end
				end
			elseif self.NextAmmoAlert < CurTime() then
				self.NextAmmoAlert = CurTime() + 0.5
				self:SetNextBullet(CurTime() + 0.2)
				self:EmitSound("npc/turret_floor/ping.wav")
				if self:GetDriverFiring() then
					self:SetDriverFiring(false)
					self:EmitSound("NPC_CombineGunship.CannonStopSound")
				end
			end
		end
	end
	
	self:NextThink( CurTime() )
	return true
end

function ENT:GetAttackFilter()
	local driver = self:GetDriverSeat():GetDriver()
	if driver:IsValid() then
		return driver:GetAttackFilter()
	end
	
	return {self}
end

function ENT:OnWelded(wep, pl, tr)
	if self:Health() < self:GetMaxHealth() then
		self:SetHealth(math.min(self:Health() + 1, self:GetMaxHealth()))
		return true
	else
		return false
	end
end

function ENT:Explode()
	local vPos = self:GetPos()
	
	util.BlastDamage(self, self, vPos, 700, 1200)
	
	local effectdata = EffectData()
		effectdata:SetOrigin(vPos)
	util.Effect("vehicle_explode", effectdata)
	
	util.ScreenShake(self:GetPos(), 15, 160, 2, 4000)
	
	local debristab = self.DebrisParts
	local morerand = self:GenerateRandomDebris()
	
	for _, part in pairs(debristab) do
		local debris = ents.Create("vehicle_gib")
		if debris:IsValid() then
			debris:SetPos(self:GetPos() + self:GetRight() * part.Pos.x + self:GetForward() * part.Pos.y + self:GetUp() * part.Pos.z)
			debris:SetAngles(self:GetAngles() + part.Ang)
			debris:Spawn()
			debris:SetModel(part.Model)

			local fire = ents.Create("env_fire_trail")
			if fire:IsValid() then
				fire:SetPos(debris:GetPos())
				fire:Spawn()
				fire:SetParent(debris)
			end

			local phys = debris:GetPhysicsObject()
			if phys:IsValid() then
				local vel = self:GetVelocity()
				vel.z = vel.z * 0.2
				
				phys:Wake()
				phys:SetVelocityInstantaneous(vel + (self:GetPos() - debris:GetPos()):GetNormalized() * (debris:GetPos():Distance(self:GetPos())) * math.Rand(0.2, 0.7) + Vector(0, 0, 400) + VectorRand() * 300)
				phys:AddAngleVelocity(VectorRand() * 10)
			end
		end
	end
	
	for _, part in pairs(morerand) do
		local debris = ents.Create("vehicle_gib")
		if debris:IsValid() then
			debris:SetPos(self:GetPos() + self:GetRight() * part.Pos.x + self:GetForward() * part.Pos.y + self:GetUp() * part.Pos.z)
			debris:SetAngles(self:GetAngles() + part.Ang)
			debris:Spawn()
			debris:SetModel(part.Model)

			local fire = ents.Create("env_fire_trail")
			if fire:IsValid() then
				fire:SetPos(debris:GetPos())
				fire:Spawn()
				fire:SetParent(debris)
			end

			local phys = debris:GetPhysicsObject()
			if phys:IsValid() then
				local vel = self:GetVelocity()
				vel.z = vel.z * 0.2
				
				phys:Wake()
				phys:SetVelocityInstantaneous(vel + (self:GetPos() - debris:GetPos()):GetNormalized() * (debris:GetPos():Distance(self:GetPos())) * math.Rand(0.2, 0.7) + Vector(0, 0, 400) + VectorRand() * 300)
				phys:AddAngleVelocity(VectorRand() * 10)
			end
		end
	end
	
	if self.SpotLight then
		self.SpotLight:Fire("Kill", "")
	end
	self:Remove()
end

function ENT:PhysicsSimulate(phys, frametime)
	phys:Wake()

	local driver = self:GetDriverSeat():GetDriver()

	if not driver:IsValid() or not self.FullyOn or self:Health() <= 0 then
		phys:EnableGravity(true)
		phys:SetAngleDragCoefficient(1)

		return SIM_NOTHING
	end

	phys:SetAngleDragCoefficient(2000000)

	local vel = self:GetVelocity() * (1 - frametime)

	local getangles = self:GetAngles()

	local desiredroll = getangles.roll * -1
	local desiredpitch = getangles.pitch * -1
	local hovering = false
	local trace = {mask = MASK_HOVER_NOWATER, filter = self}
	trace.start = self:GetPos()
	trace.endpos = trace.start + Vector(0, 0, -200)
	local tr = util.TraceLine(trace)

	if tr.Hit then
		hovering = true
	end

	if driver:KeyDown(IN_FORWARD) then
		local forward = self:GetForward()
		forward.z = 0
		forward:Normalize()
		if not hovering then
			desiredpitch = 15
			if driver:KeyDown(IN_SPEED) then
				vel = vel + frametime * 850 * forward
			else
				vel = vel + frametime * 450 * forward
			end
		else
			desiredpitch = 0
			vel = vel + frametime * 200 * forward
		end
		local vellength = vel:Length()
		if 1150 < vellength then
			vel = vel * (1150 / vellength)
		end
	elseif driver:KeyDown(IN_BACK) then
		local forward = self:GetForward()
		forward.z = 0
		forward:Normalize()
		if not hovering then
			desiredpitch = -15
			vel = vel + frametime * -450 * forward
		else
			desiredpitch = 0
			vel = vel + frametime * -200 * forward
		end
		local vellength = vel:Length()
		if 1150 < vellength then
			vel = vel * (1150 / vellength)
		end
	end
	
	if driver:KeyDown(IN_MOVELEFT) then
		local right = self:GetRight()
		right.z = 0
		right:Normalize()
		if not hovering then
			desiredroll = -20
			if driver:KeyDown(IN_SPEED) then
				vel = vel + frametime * -150 * right
			else
				vel = vel + frametime * -250 * right
			end
		else
			desiredpitch = 0
			vel = vel + frametime * -100 * right
		end
		local vellength = vel:Length()
		if 1150 < vellength then
			vel = vel * (1150 / vellength)
		end
	elseif driver:KeyDown(IN_MOVERIGHT) then
		local right = self:GetRight()
		right.z = 0
		right:Normalize()
		if not hovering then
			desiredroll = 20
			if driver:KeyDown(IN_SPEED) then
				vel = vel + frametime * 150 * right
			else
				vel = vel + frametime * 250 * right
			end
		else
			desiredpitch = 0
			vel = vel + frametime * 100 * right
		end
		local vellength = vel:Length()
		if 1150 < vellength then
			vel = vel * (1150 / vellength)
		end
	end
	
	if driver:KeyDown(IN_JUMP) then
		vel = vel + Vector(0, 0, frametime * 100)
		local vellength = vel:Length()
		if 1150 < vellength then
			vel = vel * (1150 / vellength)
		end
	elseif driver:KeyDown(IN_DUCK) then
		vel = vel + Vector(0, 0, frametime * -100)
		local vellength = vel:Length()
		if 1150 < vellength then
			vel = vel * (1150 / vellength)
		end
	end

	local aimang = driver:EyeAngles()

	local diffangles = self:WorldToLocalAngles(aimang)
	if driver:KeyDown(IN_SPEED) then
		diffangles = diffangles * 0.5
	end
	local diffangles2 = self:WorldToLocalAngles(Angle(desiredpitch, getangles.yaw, desiredroll))

	getangles:RotateAroundAxis(getangles:Up(), diffangles.yaw * frametime * 0.6)
	getangles:RotateAroundAxis(getangles:Forward(), diffangles2.roll * frametime)
	getangles:RotateAroundAxis(getangles:Right(), diffangles2.pitch * frametime * -1)

	self:SetAngles(getangles)
	phys:SetVelocityInstantaneous(vel)

	return SIM_NOTHING
end

function ENT:PhysicsCollide(data, physobj)
	self.PhysData = data
	self:NextThink(CurTime())
end

function ENT:GetVarsToSave()
	local tab = {
		["Bullets"] = self:GetBulletAmount(),
		["Missiles"] = self:GetMissileAmount(),
		["Fuel"] = self:GetFuel(),
		["Health"] = self:Health()
	}
	
	return tab
end

function ENT:SetVarsToLoad(tab)
	if tab.Bullets then
		self:SetBulletAmount(tab.Bullets)
	end
	
	if tab.Missiles then
		self:SetMissileAmount(tab.Missiles)
	end
	
	if tab.Fuel then
		self:SetFuel(tab.Fuel)
	end
	
	if tab.Health then
		self:SetHealth(tab.Health)
	end
end