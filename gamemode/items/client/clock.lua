local ITEM = {}
ITEM.DataName = "clock"

ITEM.Description = "A small clock that tells time."
ITEM.OverrideDraw = true
	
function ITEM:LocalDraw()
	if self:GetLockedDown() then
		local tim = os.date("*t")
		local hour = tim.hour
		local tmin = tim.min
		if tmin < 10 then
			tmin = "0"..tmin
		end
		local ampm = "am"
		if 12 <= hour then
			hour = hour - 12
			ampm = "pm"
			if hour == 0 then
				hour = 12
			end
		else
			if hour == 0 then
				hour = 1
			end
		end
		local disp = hour..":"..tmin.." "..ampm
			
		local pos = self:GetPos() + self:GetUp() * 4
		local ang = self:GetForward():Angle()
			ang.p = ang.p + 180
			ang.y = 0
			ang.r = 0
			
			
		cam.Start3D2D(pos, ang, 0.04)
			surface.SetFont("hidden48")
			
			local tw, th = surface.GetTextSize(disp)
			
			draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 - 5, tw + 10, th + 10, Color(20, 20, 20, 180))
			draw.SimpleText(disp, "hidden48", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

RegisterItem(ITEM)