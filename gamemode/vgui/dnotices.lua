local PANEL = {}

function PANEL:Init()
	self.m_fCreateTime = SysTime()

	AddOpenedVGUIElement(self)

	local w = ScrW()
	local h = ScrH()

	self:SetPos(w * -1, 0)
	self:SetSize(w, h)
	self:MoveTo(0, 0, 0.25, 0, 0.5)

	self:Setup()
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Paint( w, h )
	Derma_DrawBackgroundBlur(self, 0)

	surface.SetTexture(gradient)
	surface.SetDrawColor(20, 20, 20, 200)

	surface.DrawTexturedRect(0, 0, w * 0.4, h)

	surface.SetDrawColor(0, 0, 0, 250)
	surface.DrawTexturedRect(0, 30, 240, 30)
	draw.SimpleText("Notices", "hidden18", 15, 45, Color(180, 180, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:Setup()
	local scroll = vgui.Create("DScrollPanel", self)
		scroll:SetPos(5, 80)
		scroll:SetSize(self:GetWide() * 0.4, self:GetTall() - 70)

	self.NoticeList = vgui.Create( "DIconLayout", scroll)
		self.NoticeList:SetSize(scroll:GetWide() - 10, scroll:GetTall() - 60)
		self.NoticeList:SetPos(10, 10)
		self.NoticeList:SetSpaceY(10)
		self.NoticeList:SetSpaceX(5)

	if #LocalPlayer().c_AccountInfo.RPFlags == 0 then
		local nonotices = vgui.Create("DPanel")
			nonotices:SetSize(self.NoticeList:GetWide() - 10,30)
			nonotices:SetPos(5,40)
			nonotices.Paint = function(pnl, pw, ph)
				surface.SetTexture(gradient)
				surface.SetDrawColor(0, 0, 0, 200)

				surface.DrawTexturedRect(0, 0, pw, ph)

				draw.SimpleText("There are no outstanding notices.", "nulshock22", pw * 0.5, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

		self.NoticeList:Add(nonotices)
	else
		for _, flag in pairs(LocalPlayer().c_AccountInfo.RPFlags) do
			local pan = vgui.Create("DPanel")
			pan:SetSize(self.NoticeList:GetWide(), 40)
			pan.Paint = function(dpnl, pw, ph)
				surface.SetTexture(gradient)
				surface.SetDrawColor(0, 0, 0, 200)

				surface.DrawTexturedRect(0, 0, pw, ph)

				surface.SetDrawColor(50, 50, 100, 150)
				surface.DrawTexturedRect(0, 0, pw, 2)
				surface.DrawTexturedRect(0, ph - 2, pw, 2)

				draw.DrawText(ACCT_FLAG_TRANSLATE[flag], "Ethnocentric", pw * 0.5, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			end
			self.NoticeList:Add(pan)
		end
	end

	local backbtn = vgui.Create("dMainMenuButton", self)
		backbtn:SetSize(120, 25)
		--backbtn:SetPos(5, 5)
		backbtn.v_Text = "Exit"
		backbtn:SetIcon("icon16/arrow_left.png")
		backbtn:Setup()
		backbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			self:DoRemove()
		end

	self.NoticeList:Add(backbtn)
end

function PANEL:DoRemove()
	LocalPlayer().v_RecipeMenu = nil

	self:Remove()
end

function PANEL:DoClick()
end

vgui.Register( "dNotices", PANEL, "EditablePanel" )