include("shared.lua")

function ENT:Initialize()
end
	
function ENT:OnRemove()
end
	
local laser = Material("effects/laser1")
local glow = Material("sprites/glow04_noz")
function ENT:Draw()
	self:DrawModel()
	
	cam.Start3D2D(self:GetPos() + self:GetUp() * 55 + self:GetRight() * -6 + self:GetForward() * -5, self:GetAngles() + Angle(0,-90,90), 0.04)
		draw.RoundedBox(4, 30, 0, 300, 60, Color(20, 20, 20, 230))
		draw.SimpleText("Health: "..self:Health().."/"..self:GetMaxHealth(), "hidden28", 40, 0, Color(255,220,220,255), TEXT_ALIGN_LEFT)
		draw.SimpleText("Energy: "..self:GetEnergy().."/100", "hidden28", 40, 30, Color(220,220,255,255), TEXT_ALIGN_LEFT)
	cam.End3D2D()
	
	local data = {}
		data.start = self:ShootPos()
		data.endpos = data.start + self:GetForward() * 600 + self:GetUp() * math.sin(CurTime() * 3) * 100
		data.filter = self
		
	local tr = util.TraceLine(data)

	local endpos = tr.HitPos
	
	if self:GetTarget():IsValid() then
		endpos = self:GetTargetPos(self:GetTarget())
	end

	if self:GetEnergy() > 0 then
		render.SetMaterial(laser)
		render.DrawBeam(self:ShootPos(), endpos, 4, 0, 1, Color(255, 255, 100, 255))
		
		render.SetMaterial(glow)
		render.DrawSprite(self:ShootPos(), 4, 4, Color(255, 255, 255, 255))
		render.DrawSprite(self:ShootPos(), 16, 16, Color(255, 255, 100, 255))
		
		render.DrawSprite(endpos, 4, 4, Color(255, 255, 255, 255))
		render.DrawSprite(endpos, 16, 16, Color(255, 255, 100, 255))
	else
		render.SetMaterial(laser)
		render.DrawBeam(self:ShootPos(), endpos, 4, 0, 1, Color(255, 100, 100, 255))
		
		render.SetMaterial(glow)
		render.DrawSprite(self:ShootPos(), 4, 4, Color(255, 255, 255, 255))
		render.DrawSprite(self:ShootPos(), 16, 16, Color(255, 100, 100, 255))
		
		render.DrawSprite(endpos, 4, 4, Color(255, 255, 255, 255))
		render.DrawSprite(endpos, 16, 16, Color(255, 100, 100, 255))

	end
end