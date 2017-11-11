/*
	ReceiveSkillNotification:
	Receives net messages about skill level ups. Parses them for the HUDPaint hook
	
	TODO:
		-Move the skill up notifications away from the party so they aren't directly under it
*/

local skillNotifications = {}
function ReceiveSkillNotification()
	local skill = net.ReadInt(10)
	local removetime = net.ReadFloat(10) or 5
	local points = net.ReadInt(10)
	
	for i, panel in pairs(skillNotifications) do
		if panel.Skill == skill then
			panel.DieTime = CurTime() + removetime
			panel.Points = panel.Points + points
			
			return
		end
	end
	
	table.insert(skillNotifications, {Skill = skill, DieTime = CurTime() + removetime, Points = points})
end
net.Receive("SendSkillNotification", ReceiveSkillNotification)

function PaintSkillNotification()
	for i, panel in pairs(skillNotifications) do
		local skill = LocalPlayer():GetSkill(panel.Skill)
		local per = skill / SKILL_MAX_SINGLE
		local posx = ScrW() * 0.5 - 100
		local posy = i * 45
		
		draw.RoundedBox(6, posx, posy, 200, 40, Color(30, 30, 30, 220))
		draw.SimpleText(SKILLS[panel.Skill].Name.." [+"..panel.Points.."]", "hidden12", posx + 100, posy + 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(posx + 10, posy + 25, 180, 8)
		
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawRect(posx + 11, posy + 26, 178 * per, 6)
		
		surface.SetDrawColor(180, 255, 180, 255)
		surface.DrawRect(posx + 11, posy + 26 + 178 * per, 178 * (panel.Points / SKILL_MAX_SINGLE), 6)
	end
end
hook.Add("HUDPaint", "Skills.PaintNotifications", PaintSkillNotification)

function ThinkSkillNotification()
	for i, panel in pairs(skillNotifications) do
		if panel.DieTime < CurTime() then
			table.remove(skillNotifications, i)
		end
	end
end
hook.Add("Think", "Skills.ThinkNotifications", ThinkSkillNotification)