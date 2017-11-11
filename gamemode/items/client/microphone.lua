local ITEM = {}
ITEM.DataName = "microphone"

	ITEM.Description = "A small radio that can tune to stations."
	
function ITEM:OpenFrequencyMenu()
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() * 0.4, ScrH() * 0.3)
	frame:SetSize(400, 80)
	frame:SetTitle("Set Broadcast Frequency")
	frame:ShowCloseButton(true)
	frame:MakePopup()
		
	local entry = vgui.Create("DTextEntry", frame)
		entry:Dock( TOP )
		entry:SetSize(75, 25)
			
	local setbtn = vgui.Create("DButton", frame)
	setbtn:SetPos(5, frame:GetTall() - 25)
	setbtn:SetSize(75, 20)
	setbtn:SetText("Set")
	setbtn.DoClick = function()
		--	RunConsoleCommand("container_transfer", entry:GetValue())
		frame:Close()
	end
end
	
ITEM.AdditionalList = {
	{Title = "Set Broadcast Frequency", Function = function() ITEM:OpenFrequencyMenu() end}
}

RegisterItem(ITEM)