local matRefraction	= Material("refract_ring")
function EFFECT:Init( data )
	self.Origin = data:GetOrigin()
	local speed = data:GetMagnitude() or 1
	self.Speed = speed
	
	self.RefractBallDeath = CurTime() + math.max(0.4 - 0.1 * (speed - 1), 0.1)
	self.RefractSize = 0
	self.RefractAmount = 2
end

function EFFECT:Think()
	return self.RefractBallDeath > CurTime()
end

function EFFECT:Render()
	if self.RefractBallDeath > CurTime() then
		self.RefractSize = self.RefractSize + FrameTime() * 1000 * self.Speed
		self.RefractAmount = math.max(self.RefractAmount - FrameTime() * 3 * self.Speed, 0)
		
		local norm = LocalPlayer():GetAimVector() * -1
		
		matRefraction:SetFloat("$refractamount", self.RefractAmount)
		render.SetMaterial(matRefraction)
		render.UpdateRefractTexture()
		render.DrawQuadEasy(self.Origin, norm, self.RefractSize, self.RefractSize, color_white, 0)
		render.DrawQuadEasy(self.Origin, norm * -1, self.RefractSize, self.RefractSize, color_white, 0)
	end
end
