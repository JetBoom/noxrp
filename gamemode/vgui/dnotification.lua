local PANEL = {}

function PANEL:Init()
	self.Text = "Label"
	self.DieTime = CurTime() + 5
	self.Color = Color(255, 255, 255, 255)
	self.Model = ""
	
	self:SetSize(300, 50)
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Paint( w, h )
	//draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 255))
	surface.SetTexture(gradient)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawTexturedRect(0, 0, w, h)
	
	draw.DrawText(self.Text, "Xolonium16", 60, h * 0.5 - 8, self.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:CreateModel()
	local icon = vgui.Create("DModelPanel", self)
		icon:SetPos(5, 5)
		icon:SetSize(32, 32)
		icon:SetModel(self.Model)
		
	
end

function PANEL:SetText(text)
	self.Text = text
end

function PANEL:SetDieTime(timet)
	self.DieTime = timet
end

function PANEL:OnClose()
	self:Remove()
end

function PANEL:Think()
	if self.DieTime < CurTime() then
		self:Remove()
	end
end

vgui.Register( "dNotification", PANEL, "Panel" )