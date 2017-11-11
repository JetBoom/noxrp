include("obj_item.lua")

include("globals.lua")
include("sh_serialize.lua")
include("obj_extend_entity_sh.lua")
include("obj_extend_npc.lua")
include("obj_extend_player_sh.lua")
include("obj_extend_weapon.lua")
include("sh_items_datastructure.lua")
include("sh_items.lua")
include("sh_recipees.lua")
include("sh_diseases.lua")

include("removehooks.lua")

include("areas/sh_management.lua")

include("inventory/sh_inventory.lua")
include("sh_bullets.lua")

--include("sh_itemstructure.lua")

GM.Name 	= "NoXRP"
GM.Author 	= "Nightmare"
GM.Email 	= "N/A"
GM.Website 	= "noxiousnet.com"
GM.Version  = "1.0.0"

TEAM_PLAYERS = 1

team.SetUp(TEAM_PLAYERS, "Players", Color(0, 180, 255, 255))

local function DisableNoclip( ply )
	return ply:IsAdmin()
end
hook.Add("PlayerNoClip", "DisableNoclip", DisableNoclip )

function GM:CalcMainActivity(pl, velocity)
	pl.CalcIdeal = ACT_MP_STAND_IDLE
	pl.CalcSeqOverride = -1

	self:HandlePlayerLanding( pl, velocity, pl.m_bWasOnGround )

	if not ( self:HandlePlayerJumping( pl, velocity ) or self:HandlePlayerDucking( pl, velocity ) or self:HandlePlayerSwimming( pl, velocity ) ) then
		if pl:InVehicle() then
			self:HandlePlayerDriving(pl, velocity)
		else
			local len2d = velocity:Length()

			local wep = pl:GetActiveWeapon()
			if len2d > (pl:GetRunSpeed() * 0.75) and pl:IsSprinting() then
				if wep:IsValid() then
					if wep.GetHolstered then
						if wep:GetHolstered() or (wep:GetNextSprintLerp() < CurTime()) then
							if wep.CanBlock then
								if wep:GetBlocking() then
									pl.CalcIdeal = ACT_MP_RUN
								else
									pl.CalcSeqOverride = pl:LookupSequence("run_all_02")
								end
							else
								pl.CalcSeqOverride = pl:LookupSequence("run_all_02")
							end
						else
							pl.CalcIdeal = ACT_MP_RUN
						end
					else
						pl.CalcIdeal = ACT_MP_RUN
					end
				else
					pl.CalcSeqOverride = pl:LookupSequence("run_all_02")
				end
			elseif len2d > 150 then
				pl.CalcIdeal = ACT_MP_RUN
			elseif len2d > 0.5 then
				pl.CalcIdeal = ACT_MP_WALK
			end
		end
	end

	pl.m_bWasOnGround = pl:IsOnGround()

	return pl.CalcIdeal, pl.CalcSeqOverride
end

function GM:Move(pl, move)
	if pl.IsCrafting then
		move:SetSideSpeed(0)
		move:SetForwardSpeed(0)

		move:SetMaxSpeed(0)
		move:SetMaxClientSpeed(0)
	end

	if hook.Run("PreMove", pl, move) then return end

	if move:GetForwardSpeed() < 0 then
		move:SetMaxSpeed(move:GetMaxSpeed() * 0.75)
		move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.75)
	end

	local wep = pl:GetActiveWeapon()
	if wep.GetIronSights then
		if wep:GetIronSights() then
			move:SetMaxSpeed(move:GetMaxSpeed() * 0.5)
			move:SetMaxClientSpeed(move:GetMaxClientSpeed() * 0.5)
		end
	end

	if hook.Run("PostMove", pl, move) then
		return true
	end
end

function table.Compare( tbl1, tbl2 )
	for k, v in pairs( tbl1 ) do
		if ( tbl2[k] ~= v ) then return false end
	end
	for k, v in pairs( tbl2 ) do
		if ( tbl1[k] ~= v ) then return false end
	end
	return true
end

-- TODO: Re-evaluate this
function GM:ShouldCollide(ent1, ent2)
--	if (string.find(ent1:GetClass(), "npc_nox_") and ent2:IsPlayer()) or (ent1:IsPlayer() and string.find(ent2:GetClass(), "npc_nox_")) then
--		return false
--	end

	if (ent1:GetClass() == ent2:GetClass()) or string.find(ent1:GetClass(), ent2:GetClass()) or string.find(ent2:GetClass(), ent1:GetClass()) then
		return false
	end

	if (string.find(ent1:GetClass(), "npc_nox_charger") and ent2:GetClass() == "nox_charger_hive")
		or (string.find(ent2:GetClass(), "npc_nox_charger") and ent1:GetClass() == "nox_charger_hive") then
		return false
	end

	if (ent1.IsBullet and ent2:IsPlayer()) or (ent1:IsPlayer() and ent2.IsBullet) then
		return false
	end

	return true
end

local allowedtypes = {}
allowedtypes["string"] = true
allowedtypes["number"] = true
allowedtypes["table"] = true
allowedtypes["Vector"] = true
allowedtypes["Angle"] = true
allowedtypes["boolean"] = true
function table.CopyNoUserdata(t, lookup_table)
	if not t then return end

	local copy = {}
	setmetatable(copy, getmetatable(t))
	for i, v in pairs(t) do
		if allowedtypes[type(i)] and allowedtypes[type(v)] then
			if type(v) ~= "table" then
				copy[i] = v
			else
				lookup_table = lookup_table or {}
				lookup_table[t] = copy
				if lookup_table[v] then
					copy[i] = lookup_table[v]
				else
					copy[i] = table.CopyNoUserdata(v, lookup_table)
				end
			end
		end
	end

	return copy
end