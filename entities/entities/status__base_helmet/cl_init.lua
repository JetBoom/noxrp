include("shared.lua")
ENT.DisplayOnHud = false

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end
	if owner == LocalPlayer() then return end
	
	local pos, ang
	
	pos, ang = owner:GetBonePosition(owner:LookupBone(self.Bone))
	
	if pos then
		if self.Offset then
			pos = pos + ang:Up() * self.Offset.z + ang:Forward() * self.Offset.x + ang:Right() * self.Offset.y
		end
		self:SetPos(pos)
	end
	
	if ang then
		if self.Angle then
			ang:RotateAroundAxis(ang:Up(), self.Angle.y)
			ang:RotateAroundAxis(ang:Right(), self.Angle.p)
			ang:RotateAroundAxis(ang:Forward(), self.Angle.r)
		end
		self:SetAngles(ang)
	end
	
	if self.Scale then
		self:SetModelScale(self.Scale, 0)
	end
	
	self:DrawModel()
end