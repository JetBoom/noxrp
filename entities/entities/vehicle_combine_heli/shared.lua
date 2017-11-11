ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.IsCraftedVehicle = true
ENT.VehicleName = "Combine Helicopter"

MASK_HOVER = bit.bor(CONTENTS_OPAQUE, CONTENTS_GRATE, CONTENTS_HITBOX, CONTENTS_DEBRIS, CONTENTS_SOLID, CONTENTS_WATER, CONTENTS_SLIME, CONTENTS_WINDOW, CONTENTS_LADDER, CONTENTS_PLAYERCLIP, CONTENTS_MOVEABLE, CONTENTS_DETAIL, CONTENTS_TRANSLUCENT)
MASK_HOVER_NOWATER = bit.bor(CONTENTS_OPAQUE, CONTENTS_GRATE, CONTENTS_HITBOX, CONTENTS_DEBRIS, CONTENTS_SOLID, CONTENTS_WINDOW, CONTENTS_LADDER, CONTENTS_PLAYERCLIP, CONTENTS_MOVEABLE, CONTENTS_DETAIL, CONTENTS_TRANSLUCENT)

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "On")
	self:NetworkVar("Bool", 1, "DriverFiring")
	self:NetworkVar("Bool", 2, "SpotLight")
	
	self:NetworkVar("Float", 0, "NextBullet")
	self:NetworkVar("Float", 1, "NextMissile")
	
	self:NetworkVar("Int", 0, "Fuel")
	self:NetworkVar("Int", 1, "BulletAmount")
	self:NetworkVar("Int", 2, "MissileAmount")
	
	self:NetworkVar("Entity", 0, "DriverSeat")
	self:NetworkVar("Entity", 1, "MainDriver")
end

ENT.DebrisParts = {
	{
		Pos = Vector(0, 0, 0),
		Ang = Angle(0, 0, 0),
		Model = "models/Gibs/helicopter_brokenpiece_06_body.mdl",
	},
	{
		Pos = Vector(0, 130, 0),
		Ang = Angle(0, 0, 0),
		Model = "models/Gibs/helicopter_brokenpiece_04_cockpit.mdl",
	},
	{
		Pos = Vector(0, -50, 0),
		Ang = Angle(0, 0, 0),
		Model = "models/Gibs/helicopter_brokenpiece_05_tailfan.mdl",
	},
}

local randoms = {"models/Gibs/helicopter_brokenpiece_02.mdl", "models/Gibs/helicopter_brokenpiece_03.mdl", "models/Gibs/helicopter_brokenpiece_01.mdl"}
function ENT:GenerateRandomDebris()
	local tab = {}
	for i = 1, math.random(2, 4) do
		table.insert(tab, {Pos = VectorRand() * 5, Ang = Angle(0, 0, 0), Model = randoms[math.random(#randoms)]})
	end
	return tab
end