function SendNewCharInfo()
	local info = LocalPlayer().v_CharacterMenu.NewCharInfo
	if not info then
		return
	end

	net.Start("sendNewCharInfo")
		net.WriteTable(info)
	net.SendToServer()
end

function GetCharInfo()
	local status = net.ReadInt(4)
	if status == ACCT_FLAG_VALID then
		local data = net.ReadTable()
		LocalPlayer().c_AccountInfo = data
		LocalPlayer().v_CharacterMenu:OpenCharacterMenu()
	else
		LocalPlayer().v_CharacterMenu:OpenInvalidCharInfo(status)
	end
end
net.Receive("sendCharInfo",GetCharInfo)

function GetAccountInfo()
	local acct = net.ReadTable()
	if acct then
		LocalPlayer().c_AccountInfo = acct

		if acct.Inventory then
			LocalPlayer().c_Inventory = RecreateInventory(acct.Inventory)
		end

		if acct.Character.Equipment then
			LocalPlayer().c_Equipment = acct.Equipment
		end
	end
end
net.Receive("sendAccountInfo",GetAccountInfo)

function OnJoin()
	net.Start("onClientJoin")
	net.SendToServer()
end

function GM:OpenCharacterMenu()
	if not LocalPlayer().v_CharacterMenu then
		LocalPlayer().v_CharacterMenu = vgui.Create("dCharacterMenu")
	else
		LocalPlayer().v_CharacterMenu:OpenCharacterMenu()
	end
end