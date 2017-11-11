EFFECT.LifeTime = 0.05

function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	local normal = data:GetNormal()
	self.Normal = normal
	self.Size = 16
	self.Seed = math.Rand(0, 360)

	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	return CurTime() <= self.DieTime
end

local matFlash = Material("effects/muzzleflash4")
local colSprite = Color(255, 255, 255, 255)
function EFFECT:Render()
	local delta = (self.DieTime - CurTime()) / self.LifeTime
	local rot = self.Seed
	local size = delta * self.Size
	local hsize = size * 0.1
	local pos = self.Pos

	render.SetMaterial(matFlash)
	render.DrawQuadEasy(pos, self.Normal, size, hsize, colSprite, rot)
	render.DrawQuadEasy(pos, self.Normal * -1, size, hsize, colSprite, rot)
	render.DrawQuadEasy(pos, self.Normal, size, hsize, colSprite, rot + 45)
	render.DrawQuadEasy(pos, self.Normal * -1, size, hsize, colSprite, rot + 45)
	render.DrawQuadEasy(pos, self.Normal, size, hsize, colSprite, rot + 90)
	render.DrawQuadEasy(pos, self.Normal * -1, size, hsize, colSprite, rot + 90)
	render.DrawQuadEasy(pos, self.Normal, size, hsize, colSprite, rot + 135)
	render.DrawQuadEasy(pos, self.Normal * -1, size, hsize, colSprite, rot + 135)
	
	render.DrawQuadEasy(pos, self.Normal, size, size, colSprite, rot)

	--[[render.DrawQuadEasy(pos, self.Normal, size, size * 0.2, colSprite, rot)
	render.DrawQuadEasy(pos, self.Normal, size * 0.2, size, colSprite, rot)
	render.DrawQuadEasy(pos, self.Normal * -1, size, size * 0.2, colSprite, rot)
	render.DrawQuadEasy(pos, self.Normal * -1, size * 0.2, size, colSprite, rot)
	render.DrawSprite(pos, size * 0.25, size * 0.25, colSprite)]]
end
