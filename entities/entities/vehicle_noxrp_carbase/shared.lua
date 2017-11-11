ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.IsCraftedVehicle = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "EngineOn")
	self:NetworkVar("Bool", 1, "FullyOn")
	self:NetworkVar("Bool", 2, "HeadlightsOn")
	
	self:NetworkVar("Int", 0, "RPM")
	self:NetworkVar("Int", 1, "Gear")
end

ENT.VehicleSeats = {
	{Position = Vector(-15, -20, 23), Angles = Angle(0, 0, 0), IsDriverSeat = true, NoDraw = false}
}

ENT.Wheels = {
}