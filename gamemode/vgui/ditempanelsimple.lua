local PANEL = {}

function PANEL:Init()
	self.Pressed = false
	self.HeaderColor = Color(200, 200, 255, 255)
end

function PANEL:Paint( w, h )
	local col = Color(40, 40, 40, 180)
	if self.Hovered then
		col = Color(60, 60, 60, 180)
	end
	--draw.SlantedRectHorizOffset(0, 0, w - 10, h - 4, 10, col, Color(0, 0, 0, 255), 2, 2)
	draw.ElongatedHexagonHorizontalOffset(0, 0, w - 2, h - 4, 8, Color(0, 0, 0, 255), col, 2, 2)

	if self.ID then
		local iteminfo = ITEMS[self.ID.Name]
		local namestr = iteminfo.Name.." ["..self.ID.Amount.."]"

		draw.SimpleText(namestr, "nulshock16", w * 0.9, 5, self.HeaderColor, TEXT_ALIGN_RIGHT)

		local items = LocalPlayer():GetItemCount(self.ID.Name)

		draw.SimpleText("Have: "..items, "nulshock16", w * 0.9, h * 0.6, self.HeaderColor, TEXT_ALIGN_RIGHT)
	end
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:DoClick()
end

function PANEL:DoRightClick()
end

function PANEL:SetupItem()
	if self.ID then
		local itemref = ITEMS[self.ID.Name]
		if itemref.ToolTip then
			self:SetTooltip(itemref.ToolTip)
		end

		local icon = vgui.Create("DModelPanel", self)
			icon:SetPos(15, 5)
			icon:SetSize(64, 64)
			icon:SetModel(itemref.Model)
			local size = icon:GetEntity():GetModelBounds()
				size.x = size.x * -1 + 5
				size.y = size.y * -1 + 5
				size.z = size.z * -1 + 5

			icon:SetLookAt(Vector(0, 0, 0))
			icon:SetCamPos(Vector(size.x, size.y, size.z))

			if itemref.ItemPanelMaterial then
				icon.Entity:SetMaterial(itemref.ItemPanelMaterial)
			end

			if itemref.DermaMenuSetup then
				itemref:DermaMenuSetup(icon)
			end
	end
end

function PANEL:Think()
	if self.Hovered and not self.Pressed then
		if input.IsMouseDown(MOUSE_LEFT) then
			self.Pressed = true
			self:DoClick()
		elseif input.IsMouseDown(MOUSE_RIGHT) then
			self.Pressed = true
			self:DoRightClick()
		end
	elseif not self.Hovered and self.Pressed then
		if not input.IsMouseDown(MOUSE_LEFT) and input.IsMouseDown(MOUSE_RIGHT) then
			self.Pressed = false
		end
	end

	if self.ID then
		if not LocalPlayer():HasItem(self.ID.Name, self.ID.Amount) then
			self.HeaderColor = Color(255, 180, 180, 255)
		end
	end
end

vgui.Register( "dItemPanelSimple", PANEL, "EditablePanel" )