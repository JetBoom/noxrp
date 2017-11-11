AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.EngineStartSound = Sound("vehicles/sgmcars/mp4-12c/start.wav")
ENT.EngineStopSound = Sound("vehicles/sgmcars/mp4-12c/stop.wav")

ENT.Torque = 2000

ENT.FirstGearSpeed = 200

function ENT:Initialize()
	self:SetModel("models/buggy.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("metal")
		phys:SetMass(1)
		phys:EnableMotion(true)
		phys:EnableDrag(false)
		phys:Wake()
	end

	--self:StartMotionController()

	self:SetUseType(SIMPLE_USE)

	self:SetSequence("idle")

	self.MainDriver = NULL
	self:CreateVehicleParts()

	--[[for i = 1, self:GetBoneCount() - 1 do
		print(self:GetBoneName(i))
	end]]
end

function ENT:OnTakeDamage(cdmg)
end

function ENT:CreateVehicleParts()
	--self:SetPos(self:GetPos() + Vector(0, 0, 200))
	local vPos = self:GetPos()

--	for _, tab in pairs(self.VehicleSeats) do
	local ent = ents.Create("prop_vehicle_jeep")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())

		ent:SetKeyValue("model", self:GetModel())
		ent:SetKeyValue("vehiclescript", "scripts/vehicles/sentry/mp4-12c.txt")
		ent:SetKeyValue("solid", "6")
		ent:SetAngles(self:GetAngles())
		ent:Spawn()

		self:SetParent(ent)
	end
end

function ENT:GetDriverSeat()
	return self.DriverSeat
end

function ENT:Use(pl)
	if not self:GetDriverSeat():GetDriver():IsValid() then
		self:PlayerEnterSeat(pl, self:GetDriverSeat())
		self:SetEngineOn(true)

		self.DoFullyOn = CurTime() + 1.5

		self.EngineOnSound = CreateSound(self, self.EngineStartSound)
	end
end

function ENT:PlayerEnterSeat(pl, veh)
	if veh == self:GetDriverSeat() then
		pl:EnterVehicle(veh)
		self.MainDriver = pl
		self:GetPhysicsObject():EnableGravity(false)

		self.EngineOnSound = CreateSound(self, self.EngineStartSound)
	end
end

function ENT:PlayerExitSeat(pl, veh)
	if veh == self:GetDriverSeat() then
		self:SetEngineOn(false)
		self:SetFullyOn(false)
		self.MainDriver = NULL

		if self.EngineOnSound then
			self.EngineOnSound:Stop()
			self.EngineOnSound = nil
		end

		self.EngineOffSound = CreateSound(self, self.EngineStopSound)
	end
end

function ENT:Think()
	if self.PhysData then
		local data = self.PhysData
		self.PhysData = nil

		if data.Speed > 500 then
			sound.Play("physics/metal/metal_canister_impact_hard"..math.random(1, 3)..".wav", data.HitPos, 75, 100, 1)
		end
	end

	if self.EngineOffSound then
		self.EngineOffSound:Play()
	end

	if self.EngineOnSound then
		self.EngineOnSound:Play()
	end

	if self.DoFullyOn then
		if self.DoFullyOn < CurTime() then
			self.DoFullyOn = nil

			if self.MainDriver:IsValid() then
				self:SetFullyOn(true)
			end
		end
	end

	if not self:GetFullyOn() then return end
	local driver = self.MainDriver

	self:NextThink( CurTime() )
	return true
end

--[[function ENT:PhysicsSimulate(phys, frametime)
	phys:Wake()

	local driver = self.MainDriver
	local vel = self:GetVelocity() * (1 - frametime)

	local data = {}
		data.start = self:GetPos()
		data.endpos = data.start - Vector(0, 0, 1)
		data.filter = self

	local tr = util.TraceLine(data)
	if tr.Hit then
		self:SetPos(tr.HitPos + tr.HitNormal * 0.1)
		vel = vel + tr.HitNormal * 600 * frametime
	end

	vel = vel - Vector(0, 0, 600) * frametime

	if not self:GetFullyOn() or not driver:IsValid() then
		phys:SetAngleDragCoefficient(1)

		phys:SetVelocityInstantaneous(vel)
		return SIM_NOTHING
	end

	if driver:KeyDown(IN_FORWARD) then
		local forward = self:GetRight() * -1

		vel = vel + forward * frametime * self.FirstGearSpeed
	end

	phys:SetAngleDragCoefficient(2000000)
	phys:SetVelocityInstantaneous(vel)

	return SIM_NOTHING
end]]

function ENT:PhysicsCollide(data, physobj)
	self.PhysData = data
	self:NextThink(CurTime())
end

function ENT:GetVarsToSave()
end

function ENT:SetVarsToLoad(tab)
end