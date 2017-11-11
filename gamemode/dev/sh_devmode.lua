DEV_ENTITIES = {
	["ent_mine"] = {
		["IronMat"] = {Disp = "Iron Material", Func = function(tab, entity, value) entity:UpdateMat(value) end}
	},
	["nox_npc_spawner"] = {
		["Class"] = {Disp = "Spawn", Func = function(tab, entity, value) entity.m_Class = value end},
		["SpawnRadius"] = {Disp = "Spawn Radius", DrawRadi = true, RadiusColor = Color(255, 100, 100), Func = function(tab, entity, value) entity.m_SpawnRadius = tonumber(value) end},
		["MaxCount"] = {Disp = "Max Count", Func = function(tab, entity, value) entity.m_MaxCount = tonumber(value) end},
		["MoveRadius"] = {Disp = "Child Move Radius", DrawRadi = true, RadiusColor = Color(100, 255, 100), Func = function(tab, entity, value) entity.m_MoveRadius = tonumber(value) end},
		["SpawnTime"] = {Disp = "Spawn Time", Func = function(tab, entity, value) entity.m_SpawnTime = tonumber(value) end}
	},
	["nox_item_spawner"] = {
		["SpawnItem"] = {Disp = "Spawn Item", Func = function(tab, entity, value) entity.SpawnItem = value end},
		["SpawnRadius"] = {Disp = "Spawn Radius", DrawRadi = true, RadiusColor = Color(255, 100, 100), Func = function(tab, entity, value) entity.SpawnRadius = value end},
		["MaxCount"] = {Disp = "Max Count", Func = function(tab, entity, value) entity.MaxCount = value end},
		["SpawnTime"] = {Disp = "Spawn Time", Func = function(tab, entity, value) entity.SpawnTime = value end}
	},
	["ent_tree"] = {
		["WoodMat"] = {Disp = "Wood Material", Func = function(tab, entity, value) entity:SetWoodMat(value) end},
		["AreaType"] = {Disp = "Area Type", Func = function(tab, entity, value) entity.AreaType = value entity:SetModelForArea(value) end}
	},
	["npc_merchant"] = {},
	["npc_banker"] = {},
	["npc_repairer"] = {},
	["npc_nox_police"] = {},
	["npc_nox_zombie"] = {},
	["nox_charger_hive"] = {
		["HiveHealth"] = {Disp = "Hive Health", Func = function(tab, entity, value) entity.HiveHealth = value end},
		["SpawnRadius"] = {Disp = "Spawn Radius", Func = function(tab, entity, value) entity.m_SpawnRadius = value end},
		["MoveRadius"] = {Disp = "Child Move Radius", Func = function(tab, entity, value) entity.m_MoveRadius = value end},
		["SpawnTime"] = {Disp = "Spawn Time", Func = function(tab, entity, value) entity.m_SpawnTime = value end}
	},
	["point_policenode"] = {
		["SelfID"] = {Disp = "SelfID", Func = function(tab, entity, value) entity:SetSelfID(tonumber(value)) end},
		["TargetID"] = {Disp = "TargetID", Func = function(tab, entity, value) entity:SetTargetID(tonumber(value)) end}
	},
	["point_nox_spawn"] = {},
	["point_nox_spawn_karma"] = {}
}

DEV_EDIT = {
	["npc_merchant"] = {
		["Title"] = {Func = function(tab, entity, value) entity:SetMerchantTitle(value) end}
	}
}

