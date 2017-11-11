local meta = FindMetaTable("Player")
if not meta then return end

util.AddNetworkString( "sendTradeOffers" )
util.AddNetworkString( "sendTradeOffersOther" )
util.AddNetworkString( "OpenTradeWindow")
util.AddNetworkString( "CancelTrade" )
util.AddNetworkString( "ReadyTrade" )
util.AddNetworkString( "AcceptTrade" )
util.AddNetworkString( "CloseTrade" )

function RequestTrade(pl)
	--if true then return end

	local tr = pl:GetEyeTrace(250)
	local otherpl = tr.Entity

	if otherpl:IsPlayer() then
		if otherpl.RequestingTrade then
			if otherpl.RequestingTrade.Player == pl then
				otherpl.RequestingTrade = nil

				otherpl.TradingWith = {Player = pl}
				pl.TradingWith = {Player = otherpl}

				net.Start("OpenTradeWindow")
					net.WriteEntity(pl)
				net.Send(otherpl)

				net.Start("OpenTradeWindow")
					net.WriteEntity(otherpl)
				net.Send(pl)
			end
		else
			pl.RequestingTrade = {
				TimeOut = CurTime() + 10,
				Player = otherpl
			}

			otherpl:SendNotification(pl:Nick().." wishes to trade with you.")
		end
	end
end
concommand.Add("RequestTrade", RequestTrade)

function DoSelfTrade(pl)
	if not pl:IsSuperAdmin() then return end

	pl.TradingWith = {Player = pl}

	net.Start("OpenTradeWindow")
		net.WriteEntity(pl)
	net.Send(pl)
end
concommand.Add("RequestTradeSelf", DoSelfTrade)

hook.Add("Think", "Trading.TimeOut", function()
	for k, v in pairs(player.GetAll()) do
		if v.RequestingTrade then
			if v.RequestingTrade.TimeOut < CurTime() then
				v.RequestingTrade = nil
			end
		end
	end
end)

function ReceiveOffer(len, pl)
	if not pl.TradingWith then return end

	local verifyitems = net.ReadTable()

	for _, item in pairs(verifyitems) do
		if pl:GetItemByID(item.ID) == nil then
			return
		end
	end

	pl.TradingWith.SelfOffers = verifyitems

	local items = {}
	for _, item in pairs(verifyitems) do
		if type(item.ID) ~= "number" or type(item.Amount) ~= "number" then
			net.Start("CancelTrade")
			net.Send({pl, pl.TradingWith.Player})

			local otherpl = pl.TradingWith.Player
			pl.TradingWith = nil
			otherpl.TradingWith = nil
			return
		end

		local tab = pl:GetItemByID(item.ID):GetCopy()
			tab:SetAmount(item.Amount)
		table.insert(items, tab)
	end

	net.Start("sendTradeOffersOther")
		net.WriteTable(items)
	net.Send(pl.TradingWith.Player)
end
net.Receive("SendTradeOffers", ReceiveOffer)

function CancelTrade(len, pl)
	if not pl.TradingWith then return end
	local otherpl = pl.TradingWith.Player
	pl.TradingWith = nil

	net.Start("CancelTrade")
	net.Send(otherpl)

	otherpl.TradingWith = nil
end
net.Receive("CancelTrade", CancelTrade)

function ReadyTrade(len, pl)
	if not pl.TradingWith then return end

	local int = net.ReadInt(2)
	local otherpl = pl.TradingWith.Player
	if int == 1 then
		pl.TradingWith.Ready = true
	else
		pl.TradingWith.Ready = false
	end

	net.Start("ReadyTrade")
		net.WriteInt(int, 2)
	net.Send(otherpl)
end
net.Receive("ReadyTrade", ReadyTrade)

function AcceptTrade(len, pl)
	print("okay lets start trading")
	if not pl.TradingWith then return end
	print("we're trading")
	if not pl.TradingWith.Ready then return end
	print("we're ready")
	if pl.TradingWith.Evaluating then return end
	print("we're not already trading")

	local otherpl = pl.TradingWith.Player
	if not otherpl.TradingWith.Ready then return end

	if not pl.TradingWith.SelfOffers and not otherpl.TradingWith.SelfOffers then return end

	pl.TradingWith.Evaluating = true
	otherpl.TradingWith.Evaluating = true

	--make sure all items are legit, not trusting clients
	local legit = true
	local ploffers = {}
	local otherploffers = {}

	print("testing the first player for legitimacy")
	if pl.TradingWith.SelfOffers then
		for k, v in pairs(pl.TradingWith.SelfOffers) do
			if not pl:HasItemID(v.ID, v.Amount) then
				legit = false
			else
				local tab = pl:GetItemByID(v.ID):GetCopy()
					tab:SetIDRef(v.ID)
					tab:SetAmount(v.Amount)
				table.insert(ploffers, tab)
			end
		end

		if not legit then
			net.Start("CancelTrade")
			net.Send({pl, otherpl})

			pl.TradingWith = nil
			otherpl.TradingWith = nil

			return
		end
	end

	print("testing the second player for legitimacy")
	if otherpl.TradingWith.SelfOffers then
		legit = true
		for k, v in pairs(otherpl.TradingWith.SelfOffers) do
			if not otherpl:HasItemID(v.ID, v.Amount) then
				legit = false
				break
			else
				local tab = otherpl:GetItemByID(v.ID):GetCopy()
					tab:SetIDRef(v.ID)
					tab:SetAmount(v.Amount)
				table.insert(otherploffers, tab)
			end
		end

		if not legit then
			net.Start("CancelTrade")
			net.Send({pl, pl.TradingWith.Player})

			pl.TradingWith = nil
			otherpl.TradingWith = nil

			return
		end
	end

	--all items are legit
	print("all items are legit!")

	for k, v in pairs(ploffers) do
		pl:DestroyItem(v:GetIDRef(), v:GetAmount())
	end

	for k, v in pairs(otherploffers) do
		otherpl:DestroyItem(v:GetIDRef(), v:GetAmount())
	end

	for k, v in pairs(ploffers) do
		v:GetData().Trade_IsBeingOffered = nil

		otherpl:InventoryAdd(v)
	end

	for k, v in pairs(otherploffers) do
		v:GetData().Trade_IsBeingOffered = nil

		pl:InventoryAdd(v)
	end

	pl.TradingWith = nil
	otherpl.TradingWith = nil

	net.Start("CloseTrade")
	net.Send(pl)

	net.Start("CloseTrade")
	net.Send(otherpl)
end
net.Receive("AcceptTrade", AcceptTrade)


function GM:OnPlayerBuyItem(pl, item)
end

function GM:OnPlayerSellItem(pl, sellitem)
end