local PANEL = {}

CreateClientConVar("noxrp_lastviewedupdate", 0, true, false)

local Updates = {
	[1] = "4/20/2016 - Announcement - Testing Launch"
}

NoXRP_TotalUpdates = #Updates

local HTMLPanel = {}
HTMLPanel[1] = [[
This is the beginning of the testing of NoXRP 2. There are a few things to keep in mind while testing.
<ul>
<li>Report any bugs you find. If I find anyone exploiting a bug in the live, they're getting a ban or some other kind of punishment.</li>
<li>Use the help menu for general information you might need. If it isn't there, give a suggestion of what should be.</li>
<li>Keep an eye on this page and the forums for updates and announcements.</li>
<li>Give suggestions. I'll take suggestions and ideas as long as they are reasonable.</li>
<ul>
]]


Updates = table.Reverse(Updates)
HTMLPanel = table.Reverse(HTMLPanel)

function PANEL:Init()						
	local w = ScrW()
	local h = ScrH()
	
	AddOpenedVGUIElement(self)
	
	RunConsoleCommand("noxrp_lastviewedupdate", tonumber(NoXRP_TotalUpdates))
	
	self:SetPos(w * -1, 0)
	self:SetSize(w, h)
	
	self:MoveTo(0, 0, 0.25, 0, 0.5)
	
	local width = self:GetWide() * 0.3 - 20
	
	local htmlpanel = vgui.Create("DHTML", self)
		htmlpanel:SetPos(self:GetWide() * 0.4, 5)
		htmlpanel:SetSize(self:GetWide() * 0.6 - 10, self:GetTall())
	
	self.MainTopic = -1
		
	self.ScrollInv = vgui.Create("DScrollPanel",self)
		self.ScrollInv:SetPos(5, 45)
		self.ScrollInv:SetSize(width + 15, 30 + 45 * #Updates)
		
	self.itemList = vgui.Create( "DIconLayout", self.ScrollInv)
		self.itemList:SetSize(self.ScrollInv:GetWide() - 10, self.ScrollInv:GetTall() - 60)
		self.itemList:SetPos(10, 10)
		self.itemList:SetSpaceY(10)
		self.itemList:SetSpaceX(5)
		
	for k, v in pairs(Updates) do
		local helpbtn = vgui.Create("dMainMenuButton", self)
			helpbtn:SetSize(width, 35)
			helpbtn.v_Text = v
			helpbtn.v_Font = "hidden14"
			helpbtn:SetIcon("icon16/comment.png")
			helpbtn:Setup()
			
			helpbtn.DoClick = function(btn)
				surface.PlaySound("buttons/button9.wav")
				self.MainTopic = k
				htmlpanel:SetHTML([[<html>
					<head>
					<style type="text/css">
					body
					{
						font-family: "Times New Roman"
						font-size:14px;
						color:white;
						background-color:none;
						width:]].. htmlpanel:GetWide() - 48 ..[[px;
					}
					div p
					{
						margin:10px;
						padding:2px;
					}
					</style>
					</head>
					<body>
			<center><span style="font-size:22px;font-weight:bold;text-decoration:underline;">]]..Updates[k]..[[</span>
			</center><br><br><div>]]..HTMLPanel[k]..[[</div>
			</body>
			</html>]])
			end
			
		self.itemList:Add(helpbtn)
	end
	
	local backbtn = vgui.Create("dMainMenuButton", self)
		backbtn:SetSize(120, 25)
		backbtn:SetPos(15, self.ScrollInv:GetTall() + 40)
		backbtn.v_Text = "Back"
		backbtn:SetIcon("icon16/arrow_left.png")
		backbtn:Setup()
		backbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			self:DoRemove()
		end
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Paint( w, h )
	Derma_DrawBackgroundBlur( self, 0)
	
	surface.SetTexture(gradient)
	surface.SetDrawColor(20, 20, 20, 200)
	
	surface.DrawTexturedRect(0, 0, w * 0.4, h)
	
	surface.SetDrawColor(0, 0, 0, 250)
	surface.DrawTexturedRect(0, 10, 240, 30)
	draw.SimpleText("Help", "hidden18", 15, 25, Color(180, 180, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
--[[	if HelpText[self.MainTopic] then
		for line, text in pairs(HelpText[self.MainTopic]) do
			draw.SimpleText(text, "default", w * 0.35 + 15, 45 + 15 * line, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end]]
end

function PANEL:Think()
end

function PANEL:DoRemove()
	LocalPlayer().v_UpdateList = nil
	
	RemoveVGUIElement(self)
	
	LocalPlayer().v_MainMenu = vgui.Create("dMainMenu")
	self:Remove()
end

vgui.Register( "dUpdateList", PANEL, "EditablePanel" )