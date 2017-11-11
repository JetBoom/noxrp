function GetPlayerStamina()
	LocalPlayer().c_Stamina = net.ReadInt(8)
end
net.Receive("sendStamina", GetPlayerStamina)

function GetPlayerMaxStamina()
	LocalPlayer().c_MaxStamina = net.ReadInt(8)
end
net.Receive("sendMaxStamina", GetPlayerMaxStamina)

function GetPlayerBreathLevel()
	LocalPlayer().c_BreathLevel = net.ReadInt(8)
end
net.Receive("sendBreath", GetPlayerBreathLevel)

function GetPlayerSkills()
	LocalPlayer().c_Skills = net.ReadTable()
end
net.Receive("sendSkills", GetPlayerSkills)

function GetPlayerDiseases()
	LocalPlayer().c_Diseases = net.ReadTable()
end
net.Receive("sendDiseases", GetPlayerDiseases)

function GetPlayerCriminal()
	local tab = net.ReadTable()
	Entity(tab.Entity).c_CriminalFlag = tab
end
net.Receive("sendCriminalFlag", GetPlayerCriminal)

function GetClearedCriminalFlag()
	local tab = net.ReadTable()
	Entity(tab[1]).c_CriminalFlag = nil
end
net.Receive("clearCriminalFlag", GetClearedCriminalFlag)

function GetPlayerParty()
	LocalPlayer().c_Party = net.ReadTable()

	if #LocalPlayer().c_Party.Members > 0 then
		LocalPlayer().c_InParty = true
	else
		LocalPlayer().c_InParty = false
	end
end
net.Receive("sendParty", GetPlayerParty)

function GetPlayerEquipment()
	local ply = LocalPlayer()
	ply.c_Equipment = net.ReadTable()
	local simpleupdate = net.ReadBool()

	if simpleupdate then return end

	for _, item in pairs(ply.c_Equipment) do
		item = ply:GetItemByID(item)
		if item and item.SetupHud then
			item:SetupHud()
		end
	end

	if ply.LoadoutEffect then
		ply.LoadoutEffect:FlushModels()
	end

	if ply.c_InventoryPanel then
		ply.c_InventoryPanel:UpdateEquipped()
		ply.c_EquipmentPanel:OnChangedEquipment()
	end

	ply:SetCachedStamRegen(ply:GetStaminaRegeneration())
end
net.Receive("sendEquipedEquipment", GetPlayerEquipment)

function GetKnownRecipes()
	local tab = net.ReadTable()

	LocalPlayer().c_RecipeList = tab
end
net.Receive("sendKnownRecipes", GetKnownRecipes)

function GetPlayerStats()
	if not LocalPlayer().c_Stats then
		LocalPlayer().c_Stats = {}
	end

	LocalPlayer().c_Stats = net.ReadTable()
end
net.Receive("sendStats", GetPlayerStats)