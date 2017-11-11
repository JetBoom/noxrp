local ITEM = {}
ITEM.DataName = "powerbox1"

ITEM.Description = "A small powerbox for distributing electricity in properties."
	
function ITEM:LocalDraw()
	if self:GetPos():Distance(EyePos()) < 300 then
		local origin = self:GetAngles()
		origin:RotateAroundAxis(self:GetUp(), 90)
		origin:RotateAroundAxis(self:GetRight(), -90)
			
		cam.Start3D2D(self:GetPos() + self:GetForward() * 6, origin, 0.05)
			surface.SetDrawColor(20, 20, 20, 240)
			surface.DrawRect(-100, -10, 200, 20)
			surface.DrawRect(-100, 30, 200, 40)
				
			local rate = self:GetNWFloat("Rate")
			local float = math.cos(CurTime() * 4)
				
			if rate > 0 then
				surface.SetDrawColor(50, 150, 50, 225 + float * 30)
				surface.DrawRect(-95, 35, 190 * (rate / self.PowerRate), 30)
				
				draw.SimpleText("Power: "..math.Round(rate, 3).."/"..self.PowerRate, "nulshock16", 0, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif rate <= 0 then
				surface.SetDrawColor(150, 50, 50, 225 + float * 30)
				surface.DrawRect(-95 * rate, 35, 95 * rate, 30)
					
				draw.SimpleText("Power: 0", "nulshock16", 0, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end

RegisterItem(ITEM)