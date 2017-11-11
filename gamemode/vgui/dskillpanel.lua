local PANEL = {}

function PANEL:Init()
	self.Pressed = false
	self.HeaderColor = Color(200, 255, 220, 255)
end

function PANEL:Paint( w, h )
	local col = Color(40, 40, 40, 180)
	if self.Hovered then
		col = Color(60, 60, 60, 180)
	end

	draw.SlantedRectHorizOffset(0, 0, w, h, 10, col, Color(0, 0, 0, 255), 2, 2)
	
	if self.Skill then
		local skill = SKILLS[self.Skill].Name
		local have = LocalPlayer():GetSkill(self.Skill)
		
		draw.SimpleText(skill.." ["..self.Req.."]", "hidden14", w * 0.5, 5, Color(200, 200, 255, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText("Have: "..have, "hidden14", w * 0.5, 20, self.HeaderColor, TEXT_ALIGN_CENTER)
	end
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:Think()
	if self.Skill then
		if LocalPlayer():GetSkill(self.Skill) < self.Req then
			self.HeaderColor = Color(255, 180, 180, 255)
		end
	end
end

vgui.Register( "dSkillReq", PANEL, "EditablePanel" )