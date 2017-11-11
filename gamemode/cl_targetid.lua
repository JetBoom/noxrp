function GM:HUDDrawTargetID()
     return false
end

TARGETSDRAWN = {}

function EntityIsDrawn(ent)
	for target, _ in pairs(TARGETSDRAWN) do
		if target == ent then return true end
	end
	
	return false
end

function DrawPlayerInfo()
	for ent, fadetime in pairs(TARGETSDRAWN) do
		local alpha = math.min((fadetime - RealTime()) / 2, 1)
		
		local w = ScrW()
		local h = ScrH()
		
		if ent:IsValid() then
			local pos = (ent:GetPos() + ent:OBBCenter()):ToScreen()
			
			//if ent.Display then
			//	ent:Display(alpha, pos.x, pos.y)
			//end
			
			if ent.DrawOverheadName then
				ent:DrawOverheadName()
			end
				
			if ent:IsPlayer() then
				local col = Color(255, 255, 255, 255)
				
				if not ent:IsCriminal() then
					col = Color(100, 100, 255, 255)
				else
					if ent:GetKarma() <= KARMA_CRIMINAL then
						col = Color(255, 100, 100, 255)
					elseif ent:GetCriminalFlag() then
						local flag = ent:GetCriminalFlag()
						if (flag.Start + flag.Duration * 1.5) < (CurTime() + 2) then
							local rate = 2 - ((flag.Start + flag.Duration * 1.5) - CurTime())
							col = Color(100 + 150 * math.abs(math.cos(CurTime() * rate * 0.05)), 100, 100 + 150 * math.abs(math.sin(CurTime() * rate * 0.05)), 255)
						else
							col = Color(255, 100, 100, 255)
						end
					end
				end
				
				draw.SimpleText(ent:Nick(), "hidden16", pos.x, pos.y, Color(col.r, col.g, col.b, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if ent:GetDTString(0) ~= "" then
					draw.SimpleText("("..ent:GetDTString(0)..")", "hidden12", pos.x, pos.y + 15, Color(255, 255, 255, 255 * alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
	end
end
hook.Add("HUDPaint", "PaintingTargetInfo", DrawPlayerInfo)

function DrawTargetInfo()
	local trace = LocalPlayer():TraceLine(800)
	if trace.Entity and trace.Entity:IsValid() then
		TARGETSDRAWN[trace.Entity] = RealTime() + 4
		return
	end

	for target, fadetime in pairs(TARGETSDRAWN) do
		if fadetime < RealTime() or not target:IsValid() then
			TARGETSDRAWN[target] = nil
		elseif target:IsValid() and target:GetPos():Distance(LocalPlayer():GetPos()) > 300 then
			TARGETSDRAWN[target] = nil
		end
	end
end
hook.Add("Think", "TargetTracing", DrawTargetInfo)