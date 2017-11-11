include("shared.lua")

ENT.OverrideTargetID = true

function ENT:CLSetPropName()
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() * 0.4, ScrH() * 0.3)
	frame:SetSize(400, 80)
	frame:SetTitle("Set Property Name")
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
		RunConsoleCommand("noxrp_renameproperty", entry:GetValue())
		frame:Close()
	end
end

function ENT:CLSellProperty()
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() * 0.4, ScrH() * 0.3)
	frame:SetSize(400, 80)
	frame:SetTitle("Sell Property")
	frame:ShowCloseButton(true)
	frame:MakePopup()
	
	local text = vgui.Create("DLabel", frame)
		text:SetPos(5, 30)
		text:SetText("Do you really wish to sell this property?")
		text:SizeToContents()
		
	local yesbtn = vgui.Create("DButton", frame)
	yesbtn:SetPos(5, frame:GetTall() - 25)
	yesbtn:SetSize(390, 20)
	yesbtn:SetText("Yes")
	yesbtn.DoClick = function()
		RunConsoleCommand("noxrp_sellproperty")
		frame:Close()
	end
	
end

function ENT:AddWorldInteractionOptions()
	AddWorldInteractionOption("Set Property Name", function() self:CLSetPropName() end)
	AddWorldInteractionOption("Sell Property", function() self:CLSellProperty() end)
	//AddWorldInteractionOption("Check Co-Owners/Friends", function() RunConsoleCommand("noxrp_checkproperty") end)
end


function ENT:Draw()
	self:DrawModel()
	
	local pos = self:GetPos() + self:GetForward() * 4 + self:GetUp() * 30
	local ang = self:GetAngles() + Angle(0, 90, 90)
	
	cam.Start3D2D(pos, ang, 0.05)
		local name = self:GetPropertyName()
		
		surface.SetFont("hidden32")
		local tw, th = surface.GetTextSize(name)
		
		draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 - 5, tw + 10, th + 10, Color(20, 20, 20, 180))
		draw.SimpleText(name, "hidden32", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		
		if self:GetPropertyOwner() ~= "Nobody" then
			local owner = "Owner: "..self:GetPropertyOwner()
			
			surface.SetFont("hidden32")
			tw, th = surface.GetTextSize(owner)
			
			draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 + 65, tw + 10, th + 10, Color(20, 20, 20, 180))
			draw.SimpleText(owner, "hidden32", 0, 70, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			for i=#PROPERTY_DECAYTIMES, 1, -1 do
				if self:GetDecayTime() >= PROPERTY_DECAYTIMES[i] then
					local col
					if i > 5 then
						col = Color(255, 0, 0, 255)
					elseif i > 2 then
						col = Color(255, 255, 0, 255)
					else
						col = Color(20, 255, 20, 255)
					end
					
					local age = PROPERTY_DECAYNAMES[i] or "No decay time available."
					
					surface.SetFont("hidden24")
					tw, th = surface.GetTextSize(age)
					
					draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 + 135, tw + 10, th + 10, Color(20, 20, 20, 180))
					
					draw.SimpleText(age, "hidden24", 0, th + 105, col, TEXT_ALIGN_CENTER)
					break
				end
			end
			
			if LocalPlayer():SteamID64() == self:GetPropertyOwner() then
				local tax = math.floor((self:GetDecayTime() / PROPERTY_DECAYTIME) * (self:GetDecayTime() * 0.1))
				if tax > 0 then
					surface.SetFont("hidden32")
					tw, th = surface.GetTextSize(tax)
					
					draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 + 205, tw + 10, th + 10, Color(20, 20, 20, 180))
					
					draw.SimpleText("Tax: "..tax, "hidden32", 0, 205, Color(255, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		else
			local price = "Price: "..self:GetPrice()
			
			surface.SetFont("hidden32")
			tw, th = surface.GetTextSize(price)
			
			draw.RoundedBox(8, tw * -0.5 - 5, th * -0.5 + 65, tw + 10, th + 10, Color(20, 20, 20, 180))
			draw.SimpleText(price, "hidden32", 0, 70, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end

function ENT:OnRemove()
end
