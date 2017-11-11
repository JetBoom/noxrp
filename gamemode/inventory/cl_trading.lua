--Make this into a single vgui element

function OfferItemAmount(btn, item, parent)
	local itemamt = item.Amount
		
	local frame = vgui.Create("DFrame")
		frame:SetSize(400, 100)
		frame:SetPos(ScrW() * 0.5 - 100, ScrH() * 0.5 - 50)
		frame:SetTitle("Offering "..item:GetItemName())
		frame:SetDeleteOnClose(true)
		frame:ShowCloseButton(true)
		frame:SetDraggable(true)
		frame:SetMouseInputEnabled(true)
		frame:MakePopup()
		
	frame.OfferAmount = 1
		
	local slider = vgui.Create("Slider", frame)
		slider:SetPos(5, 30)
		slider:SetSize(frame:GetWide() - 10, 30)
		slider:SetMin(1)
		slider:SetMax(itemamt)
		slider:SetDecimals(0)
		slider:SetValue(1)
		slider.OnValueChanged = function(sld, val)
			frame.OfferAmount = math.Round(val)
		end
		slider.TextArea:SetTextColor(Color(255, 255, 255, 255))
		
	local offerbtn = vgui.Create("DButton", frame)
		offerbtn:SetText("Offer")
		offerbtn:SetPos(10, frame:GetTall() - 30)
		offerbtn:SetSize(frame:GetWide() - 20, 25)
		offerbtn.DoClick = function()
			btn.IsAnOffer = true
			
			local tab = item:GetCopy()
				tab:SetIDRef(item:GetIDRef())
				tab:SetAmount(frame.OfferAmount)
			btn.Offer = tab
																
			item.Trade_IsBeingOffered = true
			SendTradeSelf()
			AddSelfOffer(parent)
			
			frame:Close()
		end
end

function AddSelfOffer(parent)
	local startoffer = vgui.Create("DButton")
		startoffer:SetSize(parent:GetWide() - 5, 20)
		startoffer:SetText("")
		startoffer.Paint = function(btn, bw, bh)
			draw.SlantedRectHorizOffset(0, 0, bw, bh, 1, Color(20, 20, 20, 180), Color(0, 0, 0, 255), 2, 2)
			
			local col = Color(255, 255, 255, 255)
			if btn.Hovered then
				col = Color(0, 100, 255, 255)
			end
			
			if not btn.IsAnOffer then
				draw.SimpleText("Add Offer", "hidden14", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(btn.Offer:GetItemName().."  ("..btn.Offer.Amount..")", "hidden14", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		
	startoffer.IsAnOffer = false
		
	startoffer.DoClick = function(btn)
		if not btn.IsAnOffer then
			local menu = DermaMenu()
			menu:AddOption("Items To Offer:")
			menu:AddSpacer()
			
			for k, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
				if not item:GetData().Trade_IsBeingOffered then
					local slot = menu:AddOption(item:GetItemName(), function()
													if item:GetAmount() > 1 then
														OfferItemAmount(btn, item, parent)
													else
														btn.IsAnOffer = true
														btn.Offer = item
																
														item:GetData().Trade_IsBeingOffered = true
														SendTradeSelf()
														AddSelfOffer(parent)
													end
												end)
				end
			end
			
			menu:Open()
		else
			for k, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
				if item:GetData().Trade_IsBeingOffered and item:GetIDRef() == btn.Offer:GetIDRef() then
					item:GetData().Trade_IsBeingOffered = nil
					break
				end
			end
			
			btn.IsAnOffer = false
			btn.Offer = nil
			btn:Remove()
			
			SendTradeSelf()
		end
	end
		
	parent:Add(startoffer)
end


function ReceiveTradeOther()
	if not LocalPlayer().v_TradingWindowOther then return end
	if not LocalPlayer().v_TradingWindowOtherList then return end
	if not LocalPlayer().IsTrading then return end
	
	local offers = {}
	
	for _, item in pairs(net.ReadTable()) do
		table.insert(offers, RecreateItem(item))
	end
	
	PrintTable(offers)
	
	local list = LocalPlayer().v_TradingWindowOtherList

	for _, child in pairs(list:GetChildren()) do
		child:Remove()
	end

	for _, offer in pairs(offers) do
		local panel = vgui.Create("DPanel")
		panel:SetSize(list:GetWide() - 5, 20)
			
		panel.Offer = offer
			
		panel.Paint = function(pnl, bw, bh)
			draw.SlantedRectHorizOffset(0, 0, bw, bh, 1, Color(20, 20, 20, 180), Color(0, 0, 0, 255), 2, 2)
				
			local col = Color(255, 255, 255, 255)
			col = Color(50, 255, 50, 255)

			draw.SimpleText(offer:GetItemName().."  ("..pnl.Offer.Amount..")", "hidden14", bw * 0.5, bh * 0.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
			
		list:Add(panel)
	end
end
net.Receive("sendTradeOffersOther", ReceiveTradeOther)

function SendTradeSelf()
	if not LocalPlayer().IsTrading then return end

	local list = LocalPlayer().v_TradingWindowSelfList
	if not list then return end
	
	local offers = {}
	
	for k,v in pairs(list:GetChildren()) do
		if v.IsAnOffer then
			local tab = {}
				tab.ID = v.Offer:GetIDRef()
				tab.Amount = v.Offer:GetAmount()
			table.insert(offers, tab)
			
			PrintTable(tab)
		end
	end
	
	net.Start("sendTradeOffers")
		net.WriteTable(offers)
	net.SendToServer()
end

function CancelTrade()
	net.Start("CancelTrade")
	net.SendToServer()
end

function ReceiveCancelTrade()
	if LocalPlayer().v_TradingWindowSelf then
		print(LocalPlayer().v_TradingWindowSelf)
		LocalPlayer().v_TradingWindowSelf:OnOtherCancelTrade()
	end
end
net.Receive("CancelTrade", ReceiveCancelTrade)

function ReceiveCloseTrade()
	if LocalPlayer().v_TradingWindowSelf then
		print(LocalPlayer().v_TradingWindowSelf)
		LocalPlayer().v_TradingWindowSelf:OnOtherCancelTrade()
	end
end
net.Receive("CloseTrade", ReceiveCloseTrade)

function SendReadyTrade(bool)
	bool = bool or false
	net.Start("ReadyTrade")
		if bool then
			net.WriteInt(1, 2)
		else
			net.WriteInt(0, 2)
		end
	net.SendToServer()
end

function ReceiveReadyTrade()
	local int = net.ReadInt(2)
	if int == 0 then
		LocalPlayer().v_TradingWindowOtherReady = false
	else
		LocalPlayer().v_TradingWindowOtherReady = true
	end
end
net.Receive("ReadyTrade", ReceiveReadyTrade)

function AcceptTrade()
	net.Start("AcceptTrade")
	net.SendToServer()
end

function OpenTradingWindow()
	LocalPlayer().IsTrading = true
	local w, h = ScrW(), ScrH()
	gui.EnableScreenClicker(true)
	
	local selfpanel = vgui.Create("DPanel")
		selfpanel:SetPos(w * 0.15, h * 0.2)
		selfpanel:SetSize(w * 0.35 - 5, h * 0.5)
		selfpanel.Paint = function(pnl, pw, ph)
			draw.SlantedRectHorizOffset(0, 0, pw - 1, ph - 1, 0, Color(20, 20, 20, 220), Color(0, 0, 0, 255), 2, 2)
			
			//draw.RoundedBox(6, pw * 0.5 - 60, 5, 120, 20, Color(60, 60, 60, 255))
			draw.SlantedRectHorizOffset(pw * 0.5 - 60, 5, 120, 20, 0, Color(60, 60, 60, 255), Color(0, 0, 0, 255), 2, 2)
			draw.SimpleText("My Offers", "hidden14", pw * 0.5, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			//draw.RoundedBox(6, 5, ph * 0.1, pw - 10, ph * 0.9 - 5, Color(60, 60, 60, 255))
			draw.SlantedRectHorizOffset(5, ph * 0.1, pw - 10, ph * 0.9 - 5, 0, Color(60, 60, 60, 255), Color(0, 0, 0, 255), 2, 2)
		end
		
	local selfofferscroll = vgui.Create("DScrollPanel", selfpanel)
		selfofferscroll:SetPos(5, selfpanel:GetTall() * 0.1)
		selfofferscroll:SetSize(selfpanel:GetWide() - 10, selfpanel:GetTall() * 0.9 - 5)
		
	selfofferlist = vgui.Create( "DIconLayout", selfofferscroll)
		selfofferlist:SetSize(selfofferscroll:GetWide() - 10, selfofferscroll:GetTall() - 10)
		selfofferlist:SetPos(10, 10)
		selfofferlist:SetSpaceY(5)
		selfofferlist:SetSpaceX(20)
		
	AddSelfOffer(selfofferlist)
	
	local AcceptedTradeSelf = vgui.Create( "DCheckBoxLabel", selfpanel)
		AcceptedTradeSelf:SetPos(20, 25)
		AcceptedTradeSelf:SetText("Not Ready")
		AcceptedTradeSelf:SetValue(0)
		AcceptedTradeSelf:SizeToContents()
		AcceptedTradeSelf.OnChange = function(ck, val)
			if val then
				ck:SetText("Ready")
			else
				ck:SetText("Not ready")
			end
			SendReadyTrade(val)
		end
		
	local otherpanel = vgui.Create("DPanel")
		otherpanel:SetPos(w * 0.5 + 5, h * 0.2)
		otherpanel:SetSize(w * 0.35, h * 0.5)
		otherpanel.Paint = function(pnl, pw, ph)
			draw.SlantedRectHorizOffset(0, 0, pw - 1, ph - 1, 0, Color(20, 20, 20, 220), Color(0, 0, 0, 255), 2, 2)
			
			//draw.RoundedBox(6, pw * 0.5 - 60, 5, 120, 20, Color(60, 60, 60, 255))
			draw.SlantedRectHorizOffset(pw * 0.5 - 60, 5, 120, 20, 0, Color(60, 60, 60, 220), Color(0, 0, 0, 255), 2, 2)
			draw.SimpleText("Their Offers", "hidden14", pw * 0.5, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			//draw.RoundedBox(6, 5, ph * 0.1, pw - 10, ph * 0.9 - 5, Color(60, 60, 60, 255))
			draw.SlantedRectHorizOffset(5, ph * 0.1, pw - 10, ph * 0.9 - 5, 0, Color(60, 60, 60, 220), Color(0, 0, 0, 255), 2, 2)
			
			if LocalPlayer().v_TradingWindowOtherReady then
				draw.SimpleText("They are ready to trade!", "hidden14", pw * 0.5, 35, Color(180, 255, 180, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else	
				draw.SimpleText("They are not ready to trade.", "hidden14", pw * 0.5, 35, Color(255, 180, 180, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		
	local otherofferscroll = vgui.Create("DScrollPanel", otherpanel)
		otherofferscroll:SetPos(5, otherpanel:GetTall() * 0.1)
		otherofferscroll:SetSize(otherpanel:GetWide() - 10, otherpanel:GetTall() * 0.9 - 5)
		
	local otherofferlist = vgui.Create("DIconLayout", otherofferscroll)
		otherofferlist:SetSize(otherofferscroll:GetWide() - 10, otherofferscroll:GetTall() - 10)
		otherofferlist:SetPos(10, 10)
		otherofferlist:SetSpaceY(5)
		otherofferlist:SetSpaceX(20)
		
	local btmpanel = vgui.Create("DPanel")
		btmpanel:SetPos(w * 0.15, h * 0.7 + 5)
		btmpanel:SetSize(w * 0.7 - 5, 100)
		btmpanel.Paint = function(pnl, pw, ph)
			//draw.RoundedBox(6, 0, 0, pw, ph, Color(40, 40, 40, 255))3
			draw.SlantedRectHorizOffset(0, 0, pw, ph, 1, Color(60, 60, 60, 220), Color(0, 0, 0, 255), 2, 2)
		end
	
	selfpanel.OnRemove = function(pnl)
		LocalPlayer().IsTrading = false
		for _, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
			if item.Trade_IsBeingOffered then
				item.Trade_IsBeingOffered = nil
			end
		end
		
		otherpanel:Remove()
		btmpanel:Remove()
		
		LocalPlayer().TradingWith = nil
		
		pnl:Remove()
		gui.EnableScreenClicker(false)
	end
	
	selfpanel.OnOtherCancelTrade = function(pnl)
		LocalPlayer().IsTrading = false

		for _, item in pairs(LocalPlayer():GetInventory():GetContainer()) do
			if item:GetData().Trade_IsBeingOffered then
				item:GetData().Trade_IsBeingOffered = nil
			end
		end
		
		otherpanel:Remove()
		btmpanel:Remove()
		
		LocalPlayer().TradingWith = nil
		LocalPlayer().v_TradingWindowSelf = nil
		LocalPlayer().v_TradingWindowSelfList = nil
		LocalPlayer().v_TradingWindowOther = nil
		LocalPlayer().v_TradingWindowOtherList = nil
		LocalPlayer().v_TradingWindowOtherReady = nil
		
		pnl:Remove()
		gui.EnableScreenClicker(false)
		
		CancelTrade()
	end
	
	local cancel = vgui.Create("DButton", btmpanel)
		cancel:SetPos(btmpanel:GetWide() * 0.5 - 80, 5)
		cancel:SetSize(160, 20)
		cancel:SetText("Cancel")
		cancel.DoClick = function()
			selfpanel:OnOtherCancelTrade()
		end
		
	local accept = vgui.Create("DButton", btmpanel)
		accept:SetPos(btmpanel:GetWide() * 0.5 - 80, 50)
		accept:SetSize(160, 20)
		accept:SetText("Accept")
		accept.DoClick = function()
			AcceptTrade()
		end
		
	LocalPlayer().v_TradingWindowSelf = selfpanel
	LocalPlayer().v_TradingWindowSelfList = selfofferlist
	
	LocalPlayer().v_TradingWindowOther = otherpanel
	LocalPlayer().v_TradingWindowOtherList = otherofferlist
	LocalPlayer().v_TradingWindowOtherReady = false
end

function ReceiveTradingPartner()
	LocalPlayer().TradingWith = net.ReadEntity()
	
	OpenTradingWindow()
end
net.Receive("OpenTradeWindow", ReceiveTradingPartner)

function OpenTestTrade()
	OpenTradingWindow()
end
concommand.Add("OpenTestTrade", OpenTestTrade)