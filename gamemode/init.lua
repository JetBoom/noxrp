--[[

	NoXRP 2


]]

-- TODO: Properties should just be self-contained in to persisting entities. If we need to index them then use ents.FindByClass

--Initialize chat commands before we start including files
GM.NoXRP_ChatCommands = {}

function AddNoXRPChatCommand(text, command)
	if text then
		table.insert(GM.NoXRP_ChatCommands, {Text = text, Cmd = command})
	end
end

AddCSLuaFile("obj_item.lua")

--cl_files
AddCSLuaFile("cl_chat.lua")
AddCSLuaFile("cl_crafting.lua")
AddCSLuaFile("cl_dermaskin.lua")
AddCSLuaFile("cl_draw_custom.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_inventory.lua")
AddCSLuaFile("cl_net.lua")
AddCSLuaFile("obj_extend_player_cl.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_skills.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_worldinteraction.lua")
AddCSLuaFile("saveload/cl_charactermenu.lua")
AddCSLuaFile("inventory/cl_trading.lua")
AddCSLuaFile("areas/cl_management.lua")

--Shared files
AddCSLuaFile("globals.lua")
AddCSLuaFile("sh_serialize.lua")
AddCSLuaFile("sh_items_datastructure.lua")
AddCSLuaFile("sh_items.lua")
AddCSLuaFile("sh_bullets.lua")
AddCSLuaFile("obj_extend_player_sh.lua")
AddCSLuaFile("sh_recipees.lua")
AddCSLuaFile("sh_skillnotes.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("obj_extend_entity_sh.lua")
AddCSLuaFile("obj_extend_npc.lua")
AddCSLuaFile("obj_extend_weapon.lua")
AddCSLuaFile("removehooks.lua")
AddCSLuaFile("sh_diseases.lua")
--AddCSLuaFile("sh_itemstructure.lua")
AddCSLuaFile("inventory/sh_inventory.lua")
AddCSLuaFile("areas/sh_management.lua")

--AddCSLuaFile("weathersystem/cl_weather.lua")

--Dev files
AddCSLuaFile("dev/cl_devmode.lua")
AddCSLuaFile("dev/sh_devmode.lua")

--Send all the recipe files to client
for _,recipe in pairs(file.Find("gamemodes/noxrp/gamemode/recipes/*.lua", "GAME")) do
	AddCSLuaFile( "recipes/"..recipe )
end

--Send all VGUI files to client
for _,vgui in pairs(file.Find("gamemodes/noxrp/gamemode/vgui/*.lua", "GAME")) do
	AddCSLuaFile( "vgui/"..vgui )
end

--Includes
include("sv_uniqueid.lua")
include("sv_globals.lua")

include("shared.lua")
include("obj_extend_player_sv.lua")
include("obj_extend_entity_sv.lua")

include("saveload/sv_saveload.lua")
include("saveload/sv_accountlogin.lua")

include("dev/sv_devmode.lua")
include("dev/sh_devmode.lua")

include("areas/sv_management.lua")

include("animationsapi/boneanimlib.lua")

include("inventory/sv_inventory.lua")
include("inventory/sv_trading.lua")
include("inventory/sv_worldinteraction.lua")

include("sh_skillnotes.lua")
include("sv_worldrecipes.lua")
include("vehicle_basescript.lua")

--include("weathersystem/sv_weather.lua")

--Initialize all of the resources
function GM:Initialize()
	--Map ID
	resource.AddWorkshop("579409868")

	--Resource Pack
	resource.AddWorkshop("579407884")


	--Fonts
	--TODO:Sort these and get rid of most of them
	resource.AddFile("resource/fonts/D3Circuitism.ttf")
	resource.AddFile("resource/fonts/NEUROPOL.ttf")
	resource.AddFile("resource/fonts/vinque.ttf")
	resource.AddFile("resource/fonts/Xolonium-Regular.ttf")
	resource.AddFile("resource/fonts/nulshock bd.ttf")

	--Models
	resource.AddFile("models/nayrbarr/Sword/sword.mdl")
	resource.AddFile("models/nayrbarr/iron/iron.mdl")

	resource.AddFile("models/noxrp/camp_fire/bundle.mdl")
	resource.AddFile("models/noxrp/camp_fire/deployed.mdl")

	--Materials
	resource.AddFile("materials/nayrbarr/Sword/blade.vmt")
	resource.AddFile("materials/nayrbarr/Sword/counter weight.vmt")
	resource.AddFile("materials/nayrbarr/Sword/guard.vmt")
	resource.AddFile("materials/nayrbarr/Sword/handle.vmt")
	resource.AddFile("materials/nayrbarr/Iron/scuffed metal.vmt")

	resource.AddFile("materials/noxrp/gradient_left.vmt")
	resource.AddFile("materials/noxrp/noxrp2.png")
	resource.AddFile("materials/noxrp/combine_binocoverlay.png")

	resource.AddFile("materials/noxrp/statusicons/status_onfire.png")
	resource.AddFile("materials/noxrp/statusicons/status_bulletimpact.png")
	resource.AddFile("materials/noxrp/statusicons/status_bleed.png")
	resource.AddFile("materials/noxrp/statusicons/status_bluntimpact.png")
	resource.AddFile("materials/noxrp/statusicons/status_speed.png")
end

--If we somehow get HL2 weapons, then don't pick them up
function GM:PlayerCanPickupWeapon(pl, wep)
	return wep.Primary ~= nil
end

function GM:EntityTakeDamage(ent, dmginfo)
	local inflictor = dmginfo:GetInflictor()
	local attacker = dmginfo:GetAttacker()
	--local amount = dmginfo:GetDamage()

	--This is to stop projectiles from dealing crush damage from moving
	if attacker:IsValid() and attacker:IsProjectile() and dmginfo:GetDamageType() == DMG_CRUSH then
		dmginfo:SetDamage(0)
		return
	end

	--Stop glass from breaking
	--prop_dynamics shouldn't be breaking anyway
	if ent:GetClass() == "prop_dynamic" or string.find(ent:GetClass(), "breakable", 1, true) or string.find(ent:GetClass(), "glass", 1, true) then
		dmginfo:SetDamage(0)
		return
	end

	if attacker ~= ent and attacker:IsPlayer() and ent:IsPlayer() and not ent:IsCriminal() then
		--If their karma is worse than KARMA_CRIMINAL, then they're considered a criminal anyway
		if attacker:GetCriminalFlag() and attacker:GetKarma() > KARMA_CRIMINAL then
			local duration = attacker:GetCriminalFlag().Duration * 2
			attacker:SetCriminalFlag(CurTime(), duration)
			attacker:SendNotification("Your criminal duration has been extended to "..tostring(duration).." seconds.")
		else
			attacker:SetCriminalFlag(CurTime(), 5)
			attacker:SendNotification("You have been flagged as a criminal!")
		end
	end

	--If the victim was a player
	if ent:IsPlayer() then
		--If the damage is fall damage, we aren't going to reduce it
		--If they haven't even joined yet, then don't scale it either
		if dmginfo:IsFallDamage() or ent:Team() == TEAM_UNASSIGNED then
			return
		end

		if attacker:IsPlayer() or attacker.NextBot then
			ent:AddAttacker(attacker)
		end

		--See if the victim's current weapon can block the attack (sword blocking another sword)
		local wep = ent:GetActiveWeapon()
		if wep:IsValid() and wep.OnHitWhileBlocked and wep.CanBlockHit and wep:GetBlocking() then
			wep:OnHitWhileBlocked(attacker, inflictor, dmginfo)
			return
		end

		--Scale the damage based on our equipment
		--Should change the scaling around
		local scale = 1

		local bodyit = ent:GetEquipmentSlot(EQUIP_ARMOR_BODY)
		if bodyit then
			local item = ent:GetItemByID(bodyit)
			if item.Durability and item.Durability > 0 and item.ArmorBonus then
				--Currently it is a linear combination, meaning all of the damage reductions linearly stack
				for stat, val in pairs(item.ArmorBonus) do
					if dmginfo:IsDamageType(stat) then
						scale = scale - val
					end
				end
			end
		end

		--Scale the damage
		dmginfo:ScaleDamage(math.Clamp(scale, 0, 1))

		--Update the durability of our equipment
		ent:UpdateArmorDurability(HITGROUP_CHEST, dmginfo)
	elseif ent:IsNPC() then
		ent:AddAttacker(attacker)
	end
end

function GM:PlayerUse(pl, ent)
	--If we're in a property, then holding attack2 will let us lock doors
	if ent.Property and pl:KeyDown(IN_ATTACK2) and ent:IsDoor() then
		return false
	end

	if ent:IsDoor() then
		if CurTime() >= (ent.NextDoorUse or 0) then -- Prevent doors being spam used to block them
			ent.NextDoorUse = CurTime() + 0.5
			return true
		end

		return false
	end

	return true
end

function GM:PlayerDisconnected(pl)
	pl:SavePlayerInfo()

	if pl:InParty() then
		pl:LeaveParty()
	end
end

function GM:PlayerLeaveVehicle(ply, veh)
	if veh:GetVehicleParent():IsValid() then
		if veh:GetVehicleParent().PlayerExitSeat then
			veh:GetVehicleParent():PlayerExitSeat(ply, veh)
		end
	end
end

--Calculate it better, but fine for now
function GM:GetFallDamage( ply, speed )
	if speed > 300 then
		ply:AddStamina((speed - 300) * -0.1)
		ply:SendStamina()

		if speed >= 600 then
			ply:KnockDown(math.ceil((speed - 600) / 100))
		end

		return (speed - 300) * 0.04
	end

	return 0
end

function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
	 if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage( 1.2 )
	 end

	if hitgroup == HITGROUP_LEFTARM
		or hitgroup == HITGROUP_RIGHTARM
		or hitgroup == HITGROUP_LEFTLEG
		or hitgroup == HITGROUP_RIGHTLEG
		or hitgroup == HITGROUP_GEAR then
		dmginfo:ScaleDamage(0.8)
	 end
end

function GM:ScalePlayerDamage(pl, hitgroup, dmginfo)
	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(1.2)
	end

	if hitgroup == HITGROUP_LEFTARM
		or hitgroup == HITGROUP_RIGHTARM
		or hitgroup == HITGROUP_LEFTLEG
		or hitgroup == HITGROUP_RIGHTLEG
		or hitgroup == HITGROUP_GEAR then
		dmginfo:ScaleDamage(0.8)
	end

	 pl:UpdateArmorDurability(hitgroup, dmginfo)
end

function GM:PlayerDeath(victim, inflictor, attacker )
	victim:RemoveAllAmmo()
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	--If we didn't do a ton of damage, just ragdoll their corpse
	--If it was a ton, have gibs fly off of them.
	pl:CreateRagdoll()
	if pl:Health() <= -45 or dmginfo:IsDamageType(DMG_BLAST) then
		pl:Gib(dmginfo)
	end

	--If there are functions on entities that do OnOtherKilled, then call them
	--See if we can do something else other than ents.getall
	for k, v in pairs(ents.GetAll()) do
		if v.OnOtherKilled then
			v:OnOtherKilled(pl, attacker, dmginfo)
		end
	end

	--If they have a disease that has the DeathCures flag (meaning the disease is removed on death), then do it
	if pl.c_Diseases then
		local removes = {}
		for index, disease in pairs(pl.c_Diseases) do
			if DISEASES[disease.Name].DeathCures then
				table.insert(removes, index)
			end
		end

		for _, index in pairs(removes) do
			table.remove(pl.c_Diseases, index)
			index = index - 1
		end
	end

	pl:RemoveAllStatus(true, true)

	pl:KilledBy(attacker)

	pl.NextSpawn = CurTime() + 2
end

function GM:PlayerDeathThink(pl)
	if pl.NextSpawn and CurTime() >= pl.NextSpawn and pl:KeyDown(IN_ATTACK) then
		pl:Spawn()
	end
end

function GM:PlayerSelectSpawn( pl )
	--This is mostly here so if we end up using paralake, then it doesn't spawn everyone in that teleporter room.
	--Also, will handle map transitions when it comes to it
	local spawns = ents.FindByClass( pl:GetKarma() <= KARMA_CRIMINAL and "point_nox_spawn_karma" or "point_nox_spawn" )
	if #spawns == 0 then
		spawns = ents.FindByClass( "info_player_start" )
	end

	return spawns[ math.random( #spawns ) ]
end

function GM:PlayerConnect(name, ip)
end

function GM:PlayerInitialSpawn(pl)
	pl:SetTeam(TEAM_UNASSIGNED)
	pl:Spectate(OBS_MODE_NONE)
	pl:SetNoDraw(true)

	self:SetupPlayerDefaults(pl)
end

function GM:PlayerSpawn(pl)
	pl:StripWeapons()

	--If the player just joined, then have them as a spectator
	if pl:Team() == TEAM_UNASSIGNED then
		pl:Spectate( OBS_MODE_NONE )
		pl:SetNoDraw(true)
		pl:SetPos(pl:GetPos() + Vector(0, 0, 50))
		return
	end

	local dead = false

	--If they just now spawned after creating a character/hitting play, then start giving them everything from their account
	if not pl.AccountLoaded then
		pl:SetNoDraw(false)
		pl:SetCanZoom(false)
		--Time tracker for how long they played
		pl.c_StartPlayTime = CurTime()

		local data = pl:GetServerPlayerAccountInfo()
		--If we can load their account, start loading it
		if data then
			if data.Character then --saveload/sv_saveload.lua
				--The reason we store c_MainModel is so we can swap their model and still store the one they wanted
				local modelname = data.Character.Model
				pl.c_MainModel = modelname
				pl:SetModel(modelname)

				--Setup stats
				if data.Character.Stats then
					pl:SetupStats(data.Character.Stats, data.Character.New)
				else
					pl:SetupStats()
				end

				--Setup health
				if data.Character.Health then
					if data.Character.Health > 0 then
						pl:SetHealth(data.Character.Health)
					else
						dead = true
					end
				elseif not data.Character.New then
					pl:SetHealth(GAME_BASEHEALTH)
				end

				--Setup all the recipes they know
				if data.Character.Recipes then
					pl:SetRecipes(data.Character.Recipes)
				else
					pl:SetDefaultRecipes()
				end

				--If the player was last on this map, put them back at their coordinates
				local map = data.Character.CurrentMap
				if map == game.GetMap() and not dead then
					if data.Character.Angles then
						pl:SetEyeAngles(data.Character.Angles)
					end

					if data.Character.Position then
						pl:SetPos(data.Character.Position)
					end

					if data.Character.Velocity then
						pl:SetVelocity(data.Character.Velocity)
					end
				end

				--Setup their skills
				if data.Character.Skills then
					pl:SetSkills(data.Character.Skills)
				else
					pl:SetDefaultSkills(data)
				end

				--Reset their inventory
				if not data.Character.Inventory then
					pl:GiveNewAccountItems(data.Character)
				else
					pl:SetInventory(RecreateInventory(data.Character.Inventory, "container_playerinventory"), true)
				end

				--Set their equipment up
				if data.Character.Equipment then
					for slot, id in pairs(data.Character.Equipment) do
						local item = pl:GetItemByID(id)

						pl:SetEquipment(slot, item)
					end
				else
					pl.c_Equipment = {}
				end

				--Give them their weapons
				if data.Character.Weapons then
					for k,v in pairs(data.Character.Weapons) do
						local wep = pl:Give(v.Class)
						if v.Clip then
							wep:SetClip1(v.Clip)
						end

						if v.ItemID then
							wep:SetItemID(v.ItemID)
						end

						if wep.SetupItemVariables then
							wep:SetupItemVariables()
						end
					end

					if data.Character.ActiveWeapon then
						pl:SelectWeapon(data.Character.ActiveWeapon)

						if data.Character.Holstered then
							pl:GetWeapon(data.Character.ActiveWeapon):SetHolstered(data.Character.Holstered)
						end
					end
				end

				--Ammo
				if data.Character.AmmoCount then
					for ammotype, amount in pairs(data.Character.AmmoCount) do
						pl:GiveAmmo(amount, ammotype, true)
					end
				end

				--Status
				if data.Character.Statuses then
					for k, tab in pairs(data.Character.Statuses) do
						pl:GiveStatus(tab.Class, tab.DieTime)
					end
				end

				--Karma
				if data.Character.Karma then
					pl:SetKarma(data.Character.Karma)
				else
					pl:SetKarma(0)
				end
			else
				pl:SetDefaultSkills()
				pl:SetModel("models/player/barney.mdl")
				pl:GiveNewAccountItems()
				pl.c_Equipment = {}
			end
		else
			pl:SetDefaultSkills()
			pl:SetModel("models/player/barney.mdl")
			pl:GiveNewAccountItems()
			pl.c_Equipment = {}
		end
		pl.AccountLoaded = true
	else
		--do something for non-initial spawns
		pl:UpdateMaxHealth()
		pl:SetHealth(pl:GetMaxHealth())
	end

	if dead then
		pl:UpdateMaxHealth()
		pl:SetHealth(pl:GetMaxHealth())
	end

	pl:RemoveCriminalFlag()

	pl:SetBreathLevel(100)
	pl:SetStamina(pl:GetMaxStamina())
	pl:RecalcMoveSpeed()

	pl.Attackers = {}

	--self:SetupPlayerDefaults(pl)

	pl:SetRunSpeed(pl.c_RunSpeed)

	pl:SetupHands()
	pl:SavePlayerInfo()

	pl:SendLua("GAMEMODE:OnInitialSpawn()")
end

function GM:SetupPlayerDefaults(pl)
	pl.c_NextStaminaUpdate = pl.c_NextStaminaUpdate or 0
	pl.c_NextBreath = pl.c_NextBreath or 0
	pl.c_NextHealthRegen = pl.c_NextHealthRegen or 0
end

--1024^2 = 1048576
function CallCops(pl)
	if pl:IsPlayer() and pl:Karma() <= KARMA_CRIMINAL then return pl:ChatPrint("Your karma is too low for anyone to care.") end

	local curtime = CurTime()

	if pl.GetAttackers then
		for attacker, lastattack in pairs(pl:GetAttackers()) do
			if attacker:IsValid() and curtime <= lastattack + 20 and (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) and attacker:Health() > 0 and attacker:GetPos():DistToSqr(pl:GetPos()) <= 1048576 and not (attacker:IsPlayer() and attacker:HasItem("policebadge")) then -- 1024^2
				for __, police in pairs(ents.FindByClass("npc_nox_police")) do
					if police ~= pl and not police:GetTarget() and police:GetPos():DistToSqr(attacker:GetPos()) <= 1048576 then
						police:SomeoneCalled(pl, attacker)
					end
				end
			end
		end
	end
end
AddNoXRPChatCommand("/police", CallCops)
AddNoXRPChatCommand("!police", CallCops)
AddNoXRPChatCommand("police", CallCops)
AddNoXRPChatCommand("/guards", CallCops)
AddNoXRPChatCommand("guards", CallCops)

function SetTitle(pl, title)
	if title ~= "" then
		local newtitle = string.sub(title, 0, 25)

		pl:SetRPTitle(newtitle)
	end
end
AddNoXRPChatCommand("/setrptitle", SetTitle)

function GM:PlayerSwitchFlashlight(pl, enabled)
	return true
end

function GM:PlayerSetHandsModel(pl, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName( pl:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		--ent:SetBodyGroups( info.body )
		ent:SetBodyGroups("0000000")
		--ent:SetBodygroup(1, 0)
		ent:SetBodygroup(1, 1)
	end
end

local function CheckPlayerStamina(pl)
	local wep = pl:GetActiveWeapon()

	if pl:IsSprinting() then
		if pl:GetStamina() > 0 then
			if not pl:InVehicle() and pl.c_NextStaminaUpdate < CurTime() and pl:GetVelocity():Length2D() > 30 then
				pl.c_NextStaminaUpdate = CurTime() + 0.2
				pl:AddStamina(-1)
			end
		else
			pl:SendStamina()
			pl:SetSprinting(false)

			pl:SetRunSpeed(pl.c_WalkSpeed)
		end
	elseif pl:GetStamina() < pl:GetMaxStamina() and pl.c_NextStaminaUpdate < CurTime() then
		local regen = false
		if wep:IsValid() then
			if wep.CanBlock then
				if not wep:GetBlocking() then
					regen = true
				end
			else
				regen = true
			end
		else
			regen = true
		end

		if regen then
			pl.c_NextStaminaUpdate = CurTime() + pl:GetCachedStamRegen()
			pl:AddStamina(1)

			if pl:GetStamina() >= 5 and not pl:IsSprinting() and not pl:KeyDown(IN_SPEED) and math.Round(pl:GetRunSpeed(), 1) == pl.c_WalkSpeed then
				pl:SetRunSpeed(pl.c_RunSpeed)
			end

			if pl:GetStamina() == pl:GetMaxStamina() then
				pl:SendStamina()
			end
		end
	end
end

local function CheckPlayerBreath(pl)
	if pl.c_NextBreath <= CurTime() then
		if pl:WaterLevel() == 3 then
			pl:AddBreathLevel(-1)

			if pl:GetBreathLevel() <= 0 then
				pl.c_NextBreath = CurTime() + 0.2

				pl:TakeDamage(1)
			else
				pl.c_NextBreath = CurTime() + 0.15
			end
		elseif pl:GetBreathLevel() < 100 then
			pl:AddBreathLevel(1)
			pl.c_NextBreath = CurTime() + 0.2
		end
	end
end

function GM:SecondTick()
	--[[for _, pl in pairs(player.GetAll()) do
		if pl:Alive() and pl:Team() ~= TEAM_UNASSIGNED then
		end
	end]]
end

GM.NextTick = 0
function GM:Think()
	if CurTime() >= self.NextTick then
		self.NextTick = CurTime() + 1
		self:SecondTick()
	end

	for _, pl in pairs(player.GetAll()) do
		--Make sure they actually spawned
		if pl:Alive() and pl:Team() ~= TEAM_UNASSIGNED then
			if pl.c_Holding == NULL then pl.c_Holding = nil end

			if pl:Health() < pl:GetMaxHealth() then
				if not pl.c_NextHealthRegen then pl.c_NextHealthRegen = 10 end

				local rate = 0.5

				if pl:GetVelocity() == vector_origin then
					rate = rate + 0.5

					if pl:Crouching() then
						rate = rate + 1
					end
				end

				pl.c_NextHealthRegen = pl.c_NextHealthRegen - math.Round(FrameTime() * rate, 3)

				if pl.c_NextHealthRegen <= 0 then
					pl.c_NextHealthRegen = 10
					pl:SetHealth(math.min(pl:Health() + 1, pl:GetMaxHealth()))
				end
			end

			CheckPlayerStamina(pl)

			CheckPlayerBreath(pl)

			if pl:GetCriminalFlag() then
				local flag = pl:GetCriminalFlag()
				if (flag.Start + flag.Duration * 1.5) < CurTime() then
					pl:RemoveCriminalFlag()
					pl:SendNotification("You are no longer flagged as a criminal.")
				end
			end

			if pl.c_Diseases then
				for index, disease in pairs(pl.c_Diseases) do
					if disease.Duration and CurTime() >= disease.Duration then
						DISEASES[disease.Name]:OnCured(pl)
						table.remove(pl.c_Diseases, index)
						break
					elseif DISEASES[disease.Name].DiseaseThink then
						DISEASES[disease.Name]:DiseaseThink(pl, disease)
					end
				end
			end
		end
	end
end

function GM:KeyPress(pl, key)
	if pl:GetObserverMode() ~= OBS_MODE_NONE then return end

	if pl.IsCrafting then
		return pl.IsCrafting:OnKeyPress(key)
	end

	if pl:InVehicle() then return end

	if key == IN_ATTACK then
		if not pl.c_Holding then
			local wep = pl:GetActiveWeapon()
			if not wep:IsValid() then
				pl:Give("weapon_melee_fists")
			end

			if pl:GetStatus("equipping") then
				pl:RemoveStatus("equipping", nil, true)
			end
		end
	elseif key == IN_SPEED then
		if not pl.Sprinting then
			pl:SendStamina()
			pl:SetSprinting(true)

			local wep = pl:GetActiveWeapon()
			if wep.GetIronSights and wep:GetIronSights() then
				wep:SetIronSights2(false)
			end
		end
	elseif key == IN_JUMP then
		--Walljump
		--TODO: this needs to be shared for prediction reasons
		if not pl:OnGround() and not pl:IsOnGround() and pl:GetStat(STAT_AGILITY) >= 10 and pl:GetStamina() > 15 then
			local data = {}
				data.start = pl:GetShootPos()
				data.endpos = data.start + pl:GetAimVector() * 70
				data.mask = MASK_SOLID_BRUSHONLY --data.filter = pl
			local tr = util.TraceLine(data)

			if tr.HitWorld then
				pl:EmitSound("weapons/physcannon/energy_sing_flyby"..math.random(2)..".wav", 70, 100, 0.9)
				pl:SetAnimation(PLAYER_JUMP)
				pl:ViewPunch(Angle(-5, 0, 0))
				pl:SetLocalVelocity(tr.HitNormal * 200 + Vector(0, 0, 300))
				pl:AddStamina(-15)
				pl:SendStamina()

				local effect = EffectData()
					effect:SetOrigin(tr.HitPos)
					effect:SetMagnitude(0.2)
				util.Effect("genericrefractring", effect, true, true)
			end
		end
	elseif key == IN_USE then
		local worlduse = pl.c_UsingWithWorld
		if worlduse then
			pl.c_UsingWithWorld = nil
			worlduse:UseWithWorld(pl)
		end
	elseif key == IN_ZOOM then
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() then
			wep:ToggleHolstered(not wep:GetHolstered())
		end
	end
end

function GM:KeyRelease(pl, key)
	if key == IN_SPEED then
		if pl:IsSprinting() then
			pl:SendStamina()
			pl:SetSprinting(false)
		end

		if math.Round(pl:GetRunSpeed(), 1) == pl.c_WalkSpeed and pl:GetStamina() >= 5 then
			pl:SetRunSpeed(pl.c_RunSpeed)
		end
	end
end

function NoXRP_CheckPlayerSay(pl, text, all)
	if not pl:Alive() then return false end

	--If we have an entity waiting on chat input, then feed the inputs to them first
	if pl.EntityChatInput then
		if pl.EntityChatInput:IsValid() then
			pl.EntityChatInput:ChatInput(pl, text)
			return false
		end
	end

	--Start checking commands for them
	local command = {}
	for k,v in pairs(GAMEMODE.NoXRP_ChatCommands) do
		--If the player gave a whole command IE /testcommand, then use that
		if text == v.Text then
			command.cmd = v.Cmd
			break
		--If that was not a whole command but part of it IE /testcommand arg0, then check that
		elseif string.sub(text, 0, #v.Text) == v.Text then
			command.cmd = v.Cmd
			command.txt = v.Text
		end
	end

	--If we found a command, then use it
	if command.cmd then
		if command.txt then
			local str = string.Right(text, #text - #command.txt - 1)
			command.cmd(pl, str)
		else
			command.cmd(pl)
		end

		return ""
	end

	--If we have a disease that changes our speech, then modify it
	if pl.c_Diseases then
		for index, dis in pairs(pl.c_Diseases) do
			local disease = DISEASES[dis.Name]
			if disease.OnPlayerSay then
				local newtext = disease:OnPlayerSay(pl, text)
				if newtext then
					text = newtext
				end
			end
		end
	end

	--Max distance that the sentence can reach to entities
	local maxdist = 600
	if string.sub(text, 1, 2) == "/w" then
		maxdist = 150
	end

	--If there is an entity around us that has a OnHearSentence function, then call it
	--Examples are microphones
	for _, item in pairs(ents.FindInSphere(pl:GetPos(), maxdist)) do
		if item.OnHearSentence then
			item:OnHearSentence(pl, text)
		end
	end
end
hook.Add("PlayerSay", "NoXRP.CheckPlayerSay", NoXRP_CheckPlayerSay)

function NoXRP_CanSeePlayersChat(text, team, listener, speaker)
	--Whisper
	if string.sub(text, 1, 2) == "/w" then
		return listener:GetPos():Distance(speaker:GetPos()) <= 150
	--Global
	elseif string.sub(text, 1, 2) == "/g" or string.sub(text, 1, 2) == "--" then
		return true
	--Default Distance
	else
		return listener:GetPos():Distance(speaker:GetPos()) <= 600
	end

	--Party Chat
	if string.sub(text, 1, 2) == "/p" then
		return listener:IsInParty(speaker)
	end

	return false
end
hook.Add("PlayerCanSeePlayersChat", "NoXRP.CanSeePlayerChat", NoXRP_CanSeePlayersChat)

-- TODO: This needs to be optimized. Probably PlayerBindPress +voicerecord should send server a bit for on/off and we check that as a preliminary.
function GM:PlayerCanHearPlayersVoice( listener, talker )
	-- Do quick distance check before bothering with other stuff. Second variable means positional audio.
	if listener:GetPos():DistToSqr(talker:GetPos()) <= 360000 then --600^2
		return true, true
	end

	--See if the talker is near a microphone
	for _, ent in pairs(ents.FindByClass("item_microphone")) do
		if ent:GetClass() == "item_microphone" then
			if ent:CanPlayerTransmitVoice(talker) then
				for _, receiver in pairs(ent:GetReceivers()) do
					if receiver:PlayerCanHearRadio(listener) then
						return true
					end
				end
			end
		end
	end

	return false
end

function GM:ShowHelp(pl)
	pl:SendLua("ToggleF1Menu()")
end

function GM:ShowTeam(pl)
end

function GM:ShowSpare1(pl)
	pl:SendLua("GAMEMODE:OpenInventory()")
end

function GM:ShowSpare2(pl)
end

--TODO: Have it so the plyaer needs to accept the invitation before it automatically throws you into a party
--They can just press and hit leave party, but still
function InviteToParty(pl, cmd, args)
	local aimvec = Vector(tonumber(args[1]) or 0, tonumber(args[2]) or 0, tonumber(args[3]) or 0)
	local data = {}
		data.start = pl:GetShootPos()
		data.endpos = data.start + aimvec * 70
		data.filter = pl

	local tr = util.TraceLine(data)
	if tr.Entity:IsValid() then
		if tr.Entity:IsPlayer() and tr.Entity != pl then

			if tr.Entity:InParty() then
				pl:SendNotification("They are already in a party.")
				return
			end

			pl:InviteToParty(tr.Entity)
		end
	end
end
concommand.Add("noxrp_invitetoparty", InviteToParty)

function LeaveParty(pl)
	if not pl:InParty() then return end
	pl:LeaveParty()
end
concommand.Add("noxrp_leaveparty", LeaveParty)