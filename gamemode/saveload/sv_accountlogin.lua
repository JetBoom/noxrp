include("sh_accountvars.lua")
include("sh_charactervars.lua")

AddCSLuaFile("sh_accountvars.lua")
AddCSLuaFile("sh_charactervars.lua")

local meta = FindMetaTable("Player")
if not meta then return end

util.AddNetworkString( "sendAccountStatus" )
util.AddNetworkString( "sendAccountInfo" )
util.AddNetworkString( "sendRegistrationInfo" )
util.AddNetworkString( "sendLoginInfo" )
util.AddNetworkString( "sendCharInfo" )
util.AddNetworkString( "sendNewCharInfo" )
util.AddNetworkString( "onClientJoin" )

function meta:GetAccountID()
	return self:SteamID64() or self.c_CachedSteamID64
end

function GetAccountFile(id)
	return "noxrp/accounts/"..id:sub(-2).."/"..id..".txt"
end

function meta:GetAccountFile()
	return GetAccountFile(self:GetAccountID())
end

function meta:SendAccountStatus(status)
	net.Start("sendAccountStatus")
		net.WriteInt(status, 4)
	net.Send(self)
end

function GetLastUsedNameFromSteamID(id)
	local filename = GetAccountFile(tostring(id))
	if file.Exists(filename, "DATA") then
		local tab = Deserialize(file.Read(filename, "DATA"))
		if tab and tab.LastUsedName then
			return tab.LastUsedName
		end
	end

	return "Unknown"
end

net.Receive("onClientJoin", function(len, pl)
	if not pl:IsPlayer() or pl.AccountLoaded then return end

	local data = pl:GetServerPlayerAccountInfo()
	pl.c_CachedSteamID64 = pl:SteamID64()

	if data then
		pl:SendAccountInformation()

		local modelname = data.Model
		if modelname then
			pl.c_MainModel = modelname
			pl:SetModel(modelname)
		end
	else
		pl:CreatePlayerAccount()
	end
end)

function meta:GetServerPlayerAccountInfo()
	local accountfile = self:GetAccountFile()
	if file.Exists(accountfile, "DATA") then
		return Deserialize(file.Read(accountfile, "DATA"))
	end
end

function meta:VerifyAccountInfo()
	local data = self:GetServerPlayerAccountInfo()

	if data then
		if data.Skills then
			for i = 0, #SKILLS do
				if not data.Skills[i] then
					data.Skills[i] = 0
				end
			end

			local tab = {}
			for i = 0, #data.Skills do
				if not SKILLS[i] then
					table.insert(tab, i)
				end
			end

			for _, i in pairs(tab) do
				table.remove(data.Skills, i)
				i = i - 1
			end

			-- Needed to revalidate
			if #tab > 0 then
				local accountfile = self:GetAccountFile()
				file.CreateDir(string.GetPathFromFilename(accountfile))
				file.Write(accountfile, Serialize(data))
			end
		end
	end

	return data
end

function meta:SendAccountInformation()
	if self:VerifyAccountInfo() then
		net.Start("sendAccountInfo")
			net.WriteTable(self:GetClientPlayerAccountInfo())
		net.Send(self)
	end
end

function meta:CreatePlayerAccount()
	local data = {}
	data.LastUsedName = self:Nick()
	data.PlayTime = 0
	data.RPFlags = {ACCT_FLAG_REQUIRE_CHARSETUP}

	local accountfile = self:GetAccountFile()
	file.CreateDir(string.GetPathFromFilename(accountfile))
	file.Write(accountfile, Serialize(data))

	self:SendAccountInformation()
end

function meta:SavePlayerAccount(data, notify)
	local accountfile = self:GetAccountFile()
	file.CreateDir(string.GetPathFromFilename(accountfile))
	file.Write(accountfile, Serialize(data))

	if notify then
		self:ChatPrint("Your account has been saved.")
	end
end

function meta:AddAccountFlag(flag)
	local data = self:GetServerPlayerAccountInfo()
	if data.RPFlags and not table.HasValue(data.RPFlags) then
		table.insert(data.RPFlags, flag)
	end
	self:SavePlayerAccount(data)
end

--This is mostly so if certain account flags or whatever are added that only the server cares about, or we only want the server to see, then we can
--filter those out here. The table from here gets sent to the client when they initially join.
function meta:GetClientPlayerAccountInfo(acctid)
	local accountfile = self:GetAccountFile()
	if file.Exists(accountfile, "DATA") then
		return Deserialize(file.Read(accountfile, "DATA"))
	end
end

function meta:SendNewCharStatus(status)
	local data = self:GetClientPlayerAccountInfo()
	net.Start("sendCharInfo")
		net.WriteInt(status, 4)
		if status == ACCT_FLAG_VALID then
			net.WriteTable(data)
		end
	net.Send(self)
end

--This is sent from the character menu when a player creates a character.
net.Receive("sendNewCharInfo", function(len, pl)
	--If some idiot decided to try and change their character, don't let them
	local rawtab = file.Read(pl:GetAccountFile(), "DATA")
	if rawtab then
		local data = Deserialize(rawtab)
		if not table.HasValue(data.RPFlags, ACCT_FLAG_REQUIRE_CHARSETUP) then return end
	end

	local info = net.ReadTable()
	if not info then pl:SendNewCharStatus(ACCT_FLAG_INVALID_CHAR) return end

	--Make sure they didn't change what model they want to be out of the valid models
	--Like being a washing machine or something
	local havemodel = false
	if info.Model and type(info.Model) == "string" then
		for _, tab in pairs(ValidPlayerModels) do
			if tab.Model == info.Model then
				havemodel = true
				break
			end
		end
	end
	if not havemodel then
		info.Model = ValidPlayerModels[1]
	end

	--Check the stats they wanted
	local validstats = false
	if info.Stats and type(info.Stats) == "table" and #info.Stats == 3 then
		--This is the max amount of points the player can have
		local maxs = STATS_ALLOCATE_BASE * 4 + STATS_FREEPOINTS
		local cur = 0
		validstats = true
		for k, v in pairs(info.Stats) do
			if type(v) == "number" then
				cur = cur + v
				--Make sure they gave us a number less than or equal to the max for a single stat.
				if v > STATS_MAXPERSTAT then
					validstats = false
					break
				end
			end
		end

		--Make sure the total stat count is not greater than the max possible points
		if cur > maxs then
			validstats = false
		end
	end
	if not validstats then
		pl:SendNewCharStatus(ACCT_FLAG_INVALID_STATS)
		return
	end

	--Finally, check the skill they wanted
	local validskills = false
	if info.SelectedSkills and type(info.SelectedSkills) == "table" and #info.SelectedSkills <= SKILL_STARTING_PICKS then
		validskills = true

		for _, skill in pairs(info.SelectedSkills) do
			if not SKILLS[skill] then
				validskills = false
			end
		end
	end
	if not validskills then
		pl:SendNewCharStatus(ACCT_FLAG_INVALID_CHAR)
		return
	end

	--If everything is valid, then approve it
	local dat = pl:GetServerPlayerAccountInfo()
	dat.Model = info.Model
	dat.StartingSkills = info.SelectedSkills
	dat.New = true

	local stats = {}
	for k, v in pairs(info.Stats) do
		stats[k] = {}
		stats[k].Base = v
	end

	dat.Stats = stats
	for k, v in pairs(dat.RPFlags) do
		if v == ACCT_FLAG_REQUIRE_CHARSETUP then
			table.remove(dat.RPFlags, k)
			break
		end
	end
	pl:SavePlayerAccount(dat)
	pl:SendNewCharStatus(ACCT_FLAG_VALID)
end)

concommand.Add("nox_play", function(pl)
	--If they don't have a character profile then don't let them play if they try to get around not having an account
	local rawtab = file.Read(pl:GetAccountFile(), "DATA")
	if not rawtab then return end
	local data = Deserialize(rawtab)
	if table.HasValue(data.RPFlags, ACCT_FLAG_REQUIRE_CHARSETUP) then return end

	if pl:Team() == TEAM_UNASSIGNED then
		pl:SetNoDraw(false)
		pl:SetTeam(1)
		pl:UnSpectate()
		pl:Spawn()
	end
end)
