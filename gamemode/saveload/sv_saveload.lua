function GM:EntityShouldPersist(ent)
	if ent:CreatedByMap() then return false end

	if ent.ShouldPersist == true then return true end
	if ent.ShouldPersist == false then return false end

	return not ent.WorldMine and not ent.ParentSpawner and ent.GetVarsToSave and ent.ShouldPersist and ent:ShouldPersist()
end

function GM:SaveMapFile()
	local data = {}

	data.Entities = {}
	data.Doors = {}

	--[[for k, v in pairs(ents.GetAll()) do
		if v:IsValid() and GAMEMODE:EntityShouldPersist(v) then
			local tab = {}
			tab.Entity = v:GetClass()
			tab.Position = v:GetPos()
			tab.Angles = v:GetAngles()
			tab.Velocity = v:GetVelocity()
			tab.Skin = v:GetSkin()
			if v.Serialize then
				tab.SerializedData = v:Serialize()
			end
			tab.Parameters = v:GetVarsToSave() or {}
			table.insert(data.Entities, tab)
		end
	end]]

	for _, ent in pairs(ents.GetAll()) do
		if ent:IsValid() and gamemode.Call("EntityShouldPersist", ent) then
			local tab = {}
			if not ent.OnSave or not ent:OnSave(tab) then
				tab[1] = ent:GetClass()
				tab[2] = ent:GetPos()
				tab[3] = ent:GetAngles()
				local mdl = ent:GetModel()
				if mdl ~= "models/error.mdl" then
					tab[4] = mdl
				end
				tab[5] = ent:GetMaterial()
				tab[6] = ent:GetSkin()
				tab[7] = curtime - (ent.Created or 0)
				tab[8] = ent:GetCollisionGroup()
				tab[9] = ent:GetSolid()
				tab[10] = ent.LockedDown
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					tab[11] = phys:GetVelocity()
					tab[12] = phys:GetAngleVelocity()
					tab[13] = phys:IsMoveable()
					tab[14] = phys:GetMass()
					tab[15] = phys:GetMaterial()
				end
				tab[16] = ent:GetItem()
				local decay = ent:GetDecay()
				if decay then
					tab[17] = decay - curtime
				end
				tab[18] = ent.SpawnerUID
			end

			if ent.OnSaved then ent:OnSaved(tab) end

			table.insert(data.Entities, tab)
		end
	end

	local alldoors = ents.FindByClass("prop_door_rotating")
	alldoors = table.Add(alldoors, ents.FindByClass("func_door"))

	for _, door in pairs(alldoors) do
		local doortab = {}
		doortab[1] = door:GetPos()
		doortab[2] = door.Locked

		table.insert(data.Doors, doortab)
	end

	file.Write("noxrp/maps/"..game.GetMap()..".txt", Serialize(data))

	gamemode.Call("ProcessProperties")
	file.Write("noxrp/properties/"..game.GetMap()..".txt", Serialize(PROPERTIES))

	gamemode.Call("SavePlayers")
end

function GM:ProcessProperties()
	for _, tab in pairs(PROPERTIES) do
		if tab.Owner ~= "Nobody" and IsValid(tab.PropertyStone) then
			if tab.DecayTime >= 0 then
				tab.DecayTime = tab.DecayTime + 60 * GLOBAL_SAVEINTERVAL
				tab.PropertyStone:SetDecayTime(tab.DecayTime)
				if tab.DecayTime >= PROPERTY_DECAYTIME then
					tab.Owner = "Nobody"
					tab.Name = "An unnamed property"
					tab.DecayTime = 0
					tab.PropertyStone:SetDecayTime(tab.DecayTime)

					for _, ent2 in pairs(ents.FindInBox(tab.VecMin, tab.VecMax)) do
						if ent2.LockedDown then
							ent2.LockedDown = nil
							ent2.Property = nil
							local phys = ent2:GetPhysicsObject()
							if phys:IsValid() then
								phys:EnableMotion(true)
								phys:Wake()
							end
						end
					end

					if ent2:IsDoor() then
						ent2:Fire("Unlock", "", 0)
					end
				end
			end
		end
	end
end

function GM:ShutDown()
	gamemode.Call("SaveAll")
end

function GM:SaveAll()
	gamemode.Call("SaveMapFile")

	gamemode.Call("SavePlayers")
end

timer.Create("NRP_SaveTimer", 60 * GLOBAL_SAVEINTERVAL, 0, function() gamemode.Call("SaveAll") end)

function GM:RemoveMapEntities()
	--[[for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		ent:Remove()
	end]]

	--No weapons
	for _, ent in pairs(ents.FindByClass("weapon_*")) do
		ent:Remove()
	end
	--stuff like map healthkits if they're there for some reason
	for _, ent in pairs(ents.FindByClass("game_player_equip")) do
		ent:Remove()
	end
	--wtf paralake
	if string.find(game.GetMap(), "paralake", 1, true) then
		for _, ent in pairs(ents.FindByClass("trigger_teleport")) do
			ent:Remove()
		end
	end
end

function GM:InitPostEntity()
	gamemode.Call("RemoveMapEntities")

	gamemode.Call("LoadMapEntities")
	gamemode.Call("LoadMapProperties")

	--There is a very strange thing where if a nextbot is created on InitPostEntity, it gets created and then immediately deleted.
	--This timer makes it spawn all entities afterthis, and seems to work.
	--NVM, this is being fixed with the april update
	timer.Simple(2, function() gamemode.Call("PostLoadMapEntities") end)
end

function GM:LoadMapEntities()
	if not file.Exists("noxrp/maps/"..game.GetMap()..".txt", "DATA") then return end

	local data = Deserialize(file.Read("noxrp/maps/"..game.GetMap()..".txt", "DATA"))

	if data.Doors then
		local alldoors = ents.FindByClass("prop_door_rotating")
		alldoors = table.Add(alldoors, ents.FindByClass("func_door"))

		for _, doortab in pairs(data.Doors) do
			for __, thedoor in pairs(alldoors) do
				if thedoor:GetPos() == doortab[1] then
					thedoor.Locked = doortab[2]
					if doortab[2] then
						thedoor:Fire("lock", "", 0)
					end
				end
			end
		end
	end
end

function GM:PostLoadMapEntities()
	if not file.Exists("noxrp/maps/"..game.GetMap()..".txt", "DATA") then return end

	local data = Deserialize(file.Read("noxrp/maps/"..game.GetMap()..".txt", "DATA"))

	for k, v in pairs(data.Entities) do
		local ent = ents.Create(v.Entity)
		if ent:IsValid() then
			ent:SetPos(v.Position)
			ent:SetAngles(v.Angles)
			ent:SetVelocity(v.Velocity)
			ent:Spawn()

			ent:SetSkin(v.Skin)

			if ent.SetVarsToLoad then
				if v.Parameters then
					ent:SetVarsToLoad(v.Parameters)
				end
			end

			if ent.Deserialize and v.SerializedData then
				ent:Deserialize(v.SerializedData)
			end
		end
	end
end

function GM:LoadMapProperties()
	local propfile = file.Exists("noxrp/properties/"..game.GetMap()..".txt", "DATA")
	if propfile then
		local readtab = file.Read("noxrp/properties/"..game.GetMap()..".txt", "DATA")
		local data = Deserialize(readtab)

		for _,property in pairs(data) do
			local stone = ents.Create("property_stone")
			if stone then
				property.PropertyStone = stone
				stone:SetInfo(property)
				stone:SetPos(property.SignPos)
				stone:SetAngles(property.SignAng)
				stone:Spawn()

				property.PropertyStone = stone
			end

			for _, ent in pairs(ents.FindInBox(property.VecMin, property.VecMax)) do
				if string.sub(ent:GetClass(), 1, 12) == "prop_physics" and not ent.LockedDown then
					ent:Remove()
				elseif ent:IsDoor() then
					ent.Property = property
				end
			end
		end

		PROPERTIES = data
	end
end

function GM:OnReloaded()
	for _, stone in pairs(ents.FindByClass("property_stone")) do
		stone:Remove()
	end

	gamemode.Call("LoadMapProperties")
end

function GM:SavePlayers()
	for k, v in pairs(player.GetAll()) do
		v:SavePlayerInfo()
	end
end

local meta = FindMetaTable("Player")
if not meta then return end

function meta:SavePlayerInfo()
	if not self.AccountLoaded then return end

	local data = {}
	self:InsertData(data)
	self:SavePlayerAccount(data, true)
end

function meta:InsertData(data)
	data.CurrentMap = self.CurrentMap or game.GetMap()
	data.Position = self:GetPos()
	data.Angles = self:GetAngles()
	data.Velocity = self:GetVelocity()
	data.Health = self:Health()
	--data.Stamina = self:GetStamina()
	data.IsDead = not self:Alive()
	data.EquippedUIDs = self:GetEquippedUIDs()
	data.ItemData = self:GetContainer()
	data.Karma = self:GetKarma() or 0
	data.Bank = self.Bank
	data.Skills = self:GetSkills() or {}
	data.Equipment = self:GetEquipment() or {}
	data.Recipes = self:GetRecipes() or {}
	data.Stats = self:GetStats() or {}

	data.Weapons = {}
	for k, v in pairs(self:GetWeapons()) do
		if v:GetClass() ~= "weapon_melee_fists" then
			local wep = {}
			wep.Class = v:GetClass()
			wep.Clip = v:Clip1()

			if v.GetItemID then
				wep.ItemID = v:GetItemID()
			end

			table.insert(data.Weapons, wep)
		end
	end

	local wep = self:GetActiveWeapon()
	if wep:IsValid() then
		data.ActiveWeapon = wep:GetClass()
		if wep.GetHolstered and wep:GetHolstered() then
			data.Holstered = true
		end
	end

	data.AmmoCount = {}
	local ammotypes = {"smg1", "pistol", "sniperround", "357"}
	for k,v in pairs(ammotypes) do
		data.AmmoCount[v] = self:GetAmmoCount(v)
	end

	data.Statuses = {}
	for _, status in pairs(ents.FindByClass("status_*")) do
		if status.ShouldSave and status:GetOwner() == self then
			local tab = {}
			tab.Class = string.sub(status:GetClass(), 8)
			tab.DieTime = status:GetDieTime() - CurTime()

			table.insert(data.Statuses, tab)
		end
	end

	--data.PlayTime = math.Round(CurTime() - (self.c_StartPlayTime or CurTime()) + acctinfo.PlayTime)

	data.LastUsedName = self:Name()
end
