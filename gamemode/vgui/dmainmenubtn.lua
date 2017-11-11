local PANEL = {}

function PANEL:Init()
	self.GAlpha = 240
	self.TCol = Color(255, 255, 255)
	self:SetText("")
	self.v_Text = ""
	self.v_MainTextColor = Color(255, 255, 255)
	self.v_HoverTextColor = Color(180, 180, 255)
	
	self.ClickSound = false
	
	if not self.MoveDist then
		self.MoveDist = 30
	end
	
	self.BaseSize = {x = 1, y = 1}
end

function PANEL:Setup()
	self.BaseSize = {x = self:GetWide(), y = self:GetTall()}
	self.XDistance = 0
	self:SetSize(self:GetWide() + self.MoveDist, self:GetTall())
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Paint( w, h )
	surface.SetTexture(gradient)
	surface.SetDrawColor(0, 0, 0, self.GAlpha)
	
	if self.Hovered and self.XDistance < self.MoveDist then
		self.XDistance = Lerp(FrameTime() * 4, self.XDistance, self.MoveDist)
	elseif not self.Hovered and self.XDistance > 0 then
		self.XDistance = Lerp(FrameTime() * 4, self.XDistance, 0)
	end
	
	surface.DrawTexturedRect(self.XDistance, 0, self.BaseSize.x, self.BaseSize.y)
				
	draw.NoTexture()
	
	if self.v_Icon then
		surface.SetMaterial(self.v_Icon)
		surface.SetDrawColor(200, 200, 200)
		surface.DrawTexturedRect(self.XDistance + 5, h * 0.5 - 8, 16, 16)
		
		draw.SimpleText(self.v_Text, self.v_Font or "nulshock22", self.XDistance + 30, h * 0.5, Color(self.TCol.r, self.TCol.g, self.TCol.b, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText(self.v_Text, self.v_Font or "nulshock22", self.XDistance + 15, h * 0.5, Color(self.TCol.r, self.TCol.g, self.TCol.b, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function PANEL:Think()
	if self.Hovered then
		if not self.ClickSound then
			self.ClickSound = true
			surface.PlaySound("buttons/lightswitch2.wav")
		end
		
		if self.GAlpha < 240 then
			self.GAlpha = math.min(self.GAlpha + 6, 240)
		end
					
		if self.TCol.r > self.v_HoverTextColor.r then
			self.TCol.r = math.min(self.TCol.r - 6, self.v_HoverTextColor.r)
		end
		
		if self.TCol.g > self.v_HoverTextColor.g then
			self.TCol.g = math.min(self.TCol.g - 6, self.v_HoverTextColor.g)
		end
		
		if self.TCol.b > self.v_HoverTextColor.b then
			self.TCol.b = math.min(self.TCol.b - 6, self.v_HoverTextColor.b)
		end
	else
		if self.ClickSound then
			self.ClickSound = false
		end
		
		if self.GAlpha > 180 then
			self.GAlpha = math.max(self.GAlpha - 6, 180)
		end
					
		if self.TCol.r ~= self.v_MainTextColor.r then
		--	self.TCol.r = math.min(self.TCol.r + 6, self.v_MainTextColor.r)
			self.TCol.r = Lerp(0.1, self.TCol.r, self.v_MainTextColor.r)
		end
		
		if self.TCol.g ~= self.v_MainTextColor.g then
		--	self.TCol.g = math.min(self.TCol.g + 6, self.v_MainTextColor.g)
			self.TCol.g = Lerp(0.1, self.TCol.g, self.v_MainTextColor.g)
		end
		
		if self.TCol.b ~= self.v_MainTextColor.b then
		--	self.TCol.b = math.min(self.TCol.b + 6, self.v_MainTextColor.b)
			self.TCol.b = Lerp(0.1, self.TCol.b, self.v_MainTextColor.b)
		end
	end
	
	self:LocalThink()
end

function PANEL:LocalThink()
end

function PANEL:SetTextColor(col)
	self.v_MainTextColor = col
end

function PANEL:SetTextHoverColor(col)
	self.v_HoverTextColor = col
end

function PANEL:SetIcon(path)
	if path and path ~= "" and path ~= self.v_IconPath then
		self.v_Icon = Material(path)
	elseif path == "" or not path then
		self.v_Icon = nil
	end
end

function PANEL:DoClick()
	surface.PlaySound("buttons/button9.wav")
end

vgui.Register( "dMainMenuButton", PANEL, "DButton" )