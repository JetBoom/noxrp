local white = surface.GetTextureID("vgui/white")
function draw.SlantedRectHoriz(xpos, ypos, width, height, angle, color, outlinecolor)
	--starts from top left, so that is the origin
	--should probably be redone too since it is technically wrong in the edge points
	
	if angle ~= 0 then
		local rads = math.rad(angle)
		local rect = {}
		
		if angle > 0 then
			rect = {
				{x = xpos + height * math.sin(rads), y = ypos},
				{x = xpos + width, y = ypos},
				{x = xpos + width - height * math.sin(rads), y = ypos + height - 1},
				{x = xpos, y = ypos + height - 1}}
		else
			rect = {
				{x = xpos, y = ypos},
				{x = xpos + width + height * math.sin(rads), y = ypos},
				{x = xpos + width, y = ypos + height - 1},
				{x = xpos - height * math.sin(rads), y = ypos + height - 1}}
		end
			
		surface.SetDrawColor(color)
		surface.SetTexture(white)
		surface.DrawPoly(rect)
		
		surface.SetDrawColor(outlinecolor)
		surface.DrawLine(rect[1].x, rect[1].y, rect[2].x, rect[2].y)
		surface.DrawLine(rect[2].x, rect[2].y, rect[3].x, rect[3].y)
		surface.DrawLine(rect[3].x, rect[3].y, rect[4].x, rect[4].y)
		surface.DrawLine(rect[1].x, rect[1].y, rect[4].x, rect[4].y)
	else
		surface.SetDrawColor(color)
		surface.DrawRect(xpos, ypos, width, height)
		
		surface.SetDrawColor(outlinecolor)
		surface.DrawLine(xpos, ypos, xpos + width, ypos)
		surface.DrawLine(xpos + width, ypos, xpos + width, ypos + height)
		surface.DrawLine(xpos, ypos + height, xpos + width, ypos + height)
		surface.DrawLine(xpos, ypos, xpos, ypos + height)
	end
	
	
	--TEST

	--	surface.SetDrawColor(Color(255, 0, 0))
	--	surface.DrawLine(xpos, ypos, xpos + width, ypos)
	--	surface.DrawLine(xpos + width, ypos, xpos + width, ypos + height)
	--	surface.DrawLine(xpos, ypos + height, xpos + width, ypos + height)
	--	surface.DrawLine(xpos, ypos, xpos, ypos + height)

	surface.SetDrawColor(255, 255, 255, 255)
end

function draw.SlantedRectHorizOffset(xpos, ypos, width, height, angle, color, outlinecolor, xoffset, yoffset)
	--starts from top left, so that is the origin
	--should probably be redone but whatever
		
	if angle ~= 0 then
		local rads = math.rad(angle)
		local rect = {
			{x = xpos + height * math.tan(rads), y = ypos},
			{x = xpos + width - xoffset, y = ypos},
			{x = xpos + width - height * math.tan(rads) - xoffset, y = ypos + height - yoffset},
			{x = xpos, y = ypos + height - yoffset}}

		surface.SetDrawColor(outlinecolor)
		surface.DrawLine(rect[1].x, rect[1].y, rect[2].x, rect[2].y)
		surface.DrawLine(rect[2].x, rect[2].y, rect[3].x, rect[3].y)
		surface.DrawLine(rect[3].x, rect[3].y, rect[4].x, rect[4].y)
		surface.DrawLine(rect[1].x, rect[1].y, rect[4].x, rect[4].y)
			
		for k,v in pairs(rect) do
			v.x = v.x + xoffset
			v.y = v.y + yoffset
		end
		
		surface.SetDrawColor(color)
		surface.SetTexture(white)
		surface.DrawPoly(rect)
	else
		surface.SetDrawColor(color)
		surface.DrawRect(xpos + xoffset, ypos + yoffset, width, height)
		
		surface.SetDrawColor(outlinecolor)
		surface.DrawLine(xpos, ypos, xpos + width, ypos)
		surface.DrawLine(xpos + width, ypos, xpos + width, ypos + height)
		surface.DrawLine(xpos, ypos + height, xpos + width, ypos + height)
		surface.DrawLine(xpos, ypos, xpos, ypos + height)
	end
	
	--[[surface.SetDrawColor(Color(255, 0, 0))
	surface.DrawLine(xpos, ypos, xpos + width, ypos)
	surface.DrawLine(xpos + width, ypos, xpos + width, ypos + height)
	surface.DrawLine(xpos + width, ypos + height, xpos, ypos + height)
	surface.DrawLine(xpos, ypos + height, xpos, ypos)]]
end

function draw.RotatedRect(xpos, ypos, width, height, angle, color)
	local rads = math.rad(angle)
	local rect = {
		{x = xpos, y = ypos},
		{x = xpos + width * math.cos(rads), y = ypos - height * math.sin(rads)},
		{x = xpos + width * math.cos(rads) + height * math.sin(rads), ypos + height - height * math.sin(rads)},
		{x = xpos + height * math.sin(rads), y = ypos - height + height * math.sin(width)}}
		
	surface.SetDrawColor(color)
	surface.SetTexture(white)
	surface.DrawPoly(rect)
	
	surface.SetDrawColor(255, 0, 0)
	surface.DrawLine(xpos, ypos, xpos + width * math.cos(rads), ypos - height * math.sin(rads))
	surface.DrawLine(xpos + width * math.cos(rads), ypos - height * math.sin(rads), xpos + width * math.cos(rads) + height * math.sin(rads), ypos + height - height * math.sin(rads))
	surface.DrawLine(xpos + width * math.cos(rads) + height * math.sin(rads), ypos + height - height * math.sin(rads), xpos + height * math.sin(rads), ypos + height - height * math.sin(rads))
	surface.DrawLine(xpos + height * math.sin(rads), ypos + height - height * math.sin(rads), xpos, ypos)
end

function draw.CenteredSprite(x, y, sz)
	surface.DrawTexturedRect(x - sz * 0.5,y - sz * 0.5, sz, sz)
end

function draw.CenteredSpriteRotated(x, y, sz, rot)
	surface.DrawTexturedRectRotated(x - sz * 0.5,y - sz * 0.5, sz, sz, rot)
end

function draw.ElongatedHexagonHorizontalOffset(xpos, ypos, width, height, sidelength, outlinecolor, innercolor, xoffset, yoffset)
	local rect = {
		{x = xpos, y = ypos + height * 0.5},
		{x = xpos + sidelength, y = ypos},
		{x = xpos + width - sidelength, y = ypos},
		{x = xpos + width - xoffset, y = ypos + height * 0.5 - yoffset},
		{x = xpos + width - sidelength - xoffset, y = ypos + height - yoffset},
		{x = xpos + sidelength - xoffset, y = ypos + height - yoffset}
	}
	
	surface.SetDrawColor(outlinecolor)
	surface.DrawLine(rect[1].x, rect[1].y, rect[2].x, rect[2].y)
	surface.DrawLine(rect[2].x, rect[2].y, rect[3].x, rect[3].y)
	surface.DrawLine(rect[3].x, rect[3].y, rect[4].x, rect[4].y)
	surface.DrawLine(rect[4].x, rect[4].y, rect[5].x, rect[5].y)
	surface.DrawLine(rect[5].x, rect[5].y, rect[6].x, rect[6].y)
	surface.DrawLine(rect[6].x, rect[6].y, rect[1].x, rect[1].y)
	
	for k,v in pairs(rect) do
		v.x = v.x + xoffset
		v.y = v.y + yoffset
	end
		
	surface.SetDrawColor(innercolor)
	surface.SetTexture(white)
	surface.DrawPoly(rect)

	draw.NoTexture()
end

function draw.ElongatedHexagonHorizontal(xpos, ypos, width, height, sidelength, outlinecolor, innercolor)
	local rect = {
		{x = xpos, y = ypos + height * 0.5},
		{x = xpos + sidelength, y = ypos},
		{x = xpos + width - sidelength, y = ypos},
		{x = xpos + width, y = ypos + height * 0.5},
		{x = xpos + width - sidelength, y = ypos + height},
		{x = xpos + sidelength, y = ypos + height}
	}
	
	surface.SetDrawColor(outlinecolor)
	surface.DrawLine(rect[1].x, rect[1].y, rect[2].x, rect[2].y)
	surface.DrawLine(rect[2].x, rect[2].y, rect[3].x, rect[3].y)
	surface.DrawLine(rect[3].x, rect[3].y, rect[4].x, rect[4].y)
	surface.DrawLine(rect[4].x, rect[4].y, rect[5].x, rect[5].y)
	surface.DrawLine(rect[5].x, rect[5].y, rect[6].x, rect[6].y)
	surface.DrawLine(rect[6].x, rect[6].y, rect[1].x, rect[1].y)
		
	surface.SetDrawColor(innercolor)
	surface.SetTexture(white)
	surface.DrawPoly(rect)
	
	draw.NoTexture()
end