local PANEL = {}

function PANEL:Init()
	self.Pressed = false
end

function PANEL:Paint( w, h )
	local col = Color(20,20,20,180)
	if self.Hovered then
		col = Color(40,40,40,180)
	end
	//draw.SlantedRectHorizOffset(0, 0, w - 10, colh - 4, 10, col, Color(0, 0, 0, 255), 2, 2)
	draw.ElongatedHexagonHorizontalOffset(0, 0, w - 2, h - 4, 8, Color(0, 0, 0, 255), col, 2, 2)
	
	if self.ID then
		local recipe = RECIPEES[self.ID]
		
		draw.SimpleText(recipe.Display, "hidden14", w * 0.5, h * 0.5,Color(200,200,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:DoClick()
	surface.PlaySound("UI/buttonclickrelease.wav")

	local parent = self.InfoP
	parent.ID = self.ID
	parent:OpenRecipeInfo()
end

function PANEL:DoRightClick()
end

function PANEL:Think()
	if (input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)) and not self.Pressed and self.Hovered then
		self.Pressed = true
		if input.IsMouseDown(MOUSE_LEFT) then
			self:DoClick()
		elseif input.IsMouseDown(MOUSE_RIGHT) then
			self:DoRightClick()			
		end
	elseif (not input.IsMouseDown(MOUSE_LEFT) and not input.IsMouseDown(MOUSE_RIGHT)) and self.Pressed then
		self.Pressed = false
	end
end

vgui.Register( "dItemPanelCrafting", PANEL, "EditablePanel" )