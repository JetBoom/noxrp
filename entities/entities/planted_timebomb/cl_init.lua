include("shared.lua")

util.PrecacheSound("weapons/c4/c4_click.wav")

local matGlow = Material("sprites/light_glow02_add")

function ENT:Initialize()
	self.Death = CurTime() + 17.5
	self.Time = 0.7
	self.NextBeep = RealTime()
end

function ENT:Think()
	if RealTime() >= self.NextBeep then
		self.Entity:EmitSound("weapons/c4/c4_click.wav")

		self.Time = math.Clamp((self.Death - CurTime()) * 0.12, 0.2, 1.5) --self.Time - FrameTime() * 2)
		self.NextBeep = RealTime() + self.Time
	end
end

function ENT:Draw()
	self:DrawModel()

	local tim = (math.max(self.NextBeep - RealTime(), 0.2)) * 32
	render.SetMaterial(matGlow)
	render.DrawSprite(self:GetPos() + self:GetUp() * 8, tim, tim, Color(255,0,0))
	
	local ang = self:GetAngles()
	local pos = self:GetPos()
	
	local len = 400
	local hei = 20
	
--	local tim = self:GetNetworkedFloat("dif", 0)
	local diff = self:GetDiffuse()
	local per = (diff / 10)
	
	cam.Start3D2D(pos + ang:Up() * 9.5 + ang:Forward() * 2 + ang:Right() * 2, ang + Angle(0, -90, 0), 0.05)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(-len * 0.5, -hei * 0.5, len, hei)
		
		surface.SetDrawColor(50, 255, 50, 255)
		surface.DrawRect(-len * 0.5 + 1, -hei * 0.5 + 1, (len - 2) * per, hei - 2)
	cam.End3D2D()
end
--[[
function ENT:Display(fade, x, y)
	local tim = self.Entity:GetNetworkedFloat("dif", 0)

	local right = LocalPlayer():GetAimVector():Angle():Right() * 8
	local meterbegin = (self.Entity:GetPos() + Vector(0,0,-8) + right * -1):ToScreen()
	local meterend = (self.Entity:GetPos() + Vector(0,0,-8) + right):ToScreen()
	local meterwidth = meterend.x - meterbegin.x

	surface.SetDrawColor(0, 0, 0, fade)
	surface.DrawRect(meterbegin.x, meterbegin.y, meterwidth, meterwidth * 0.08)
	surface.SetDrawColor(200, 20, 20, fade)
	surface.DrawRect(meterbegin.x, meterbegin.y, meterwidth * (tim / 10), meterwidth * 0.08)
	surface.SetDrawColor(200, 200, 200, fade)
	surface.DrawOutlinedRect(meterbegin.x, meterbegin.y, meterwidth, meterwidth * 0.08)
end]]
