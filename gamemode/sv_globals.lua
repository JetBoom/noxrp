GLOBAL_SAVEINTERVAL = 15

NPC_DROPS = {
	["npc_nox_charger"] = {
		{"rawmeat", 1, 2}
	},
	["npc_nox_charger_a"] = {
		{"rawmeat", 1, 2}
	},
	["npc_zombie_poison"] = {
		{"redgoop", 1, 5}
	}
}

--Order:
--itemname, drop amount, drop chance (1 out of x), itemcallfunction
NPC_GLOBALDROPTABLE_TOTALDROP = 1

NPC_GLOBALDROPTABLE = {
	{Item = "recipe_blueprintp", Amount = 1, Chance = 100, EditData = function(data) data.Recipe = "deagle" data.RecipeAmount = 1 end}
}

NPCKarma = {}
NPCKarma["npc_zombie"] = -2000
NPCKarma["npc_zombie_torso"] = NPCKarma["npc_zombie"]
NPCKarma["npc_nox_zombie"] = NPCKarma["npc_zombie"]
NPCKarma["npc_poisonzombie"] = -5000
NPCKarma["npc_antlion"] = -1000
NPCKarma["npc_antlionguard"] = -7000
NPCKarma["npc_fastzombie"] = -2500
NPCKarma["npc_headcrab"] = -2000
NPCKarma["npc_headcrab_fast"] = -2100
NPCKarma["npc_headcrab_black"] = -2500
NPCKarma["npc_manhack"] = -1100
NPCKarma["npc_cscanner"] = 2000
NPCKarma["npc_nox_police"] = 12000
NPCKarma["npc_nox_charger"] = -2000
NPCKarma["npc_nox_terrorist"] = -10000

GAME_MAX_HEALTH = 150

G_RELATIONSHIP_NEUTRAL = 0
G_RELATIONSHIP_HATE = 1
G_RELATIONSHIP_FRIEND = 2
G_RELATIONSHIP_FEAR = 3

G_RELATION_SORT_CLOSEST = 0
G_RELATION_SORT_FURTHEST = 1

STAT_EXP_FUNC = function(level)
	return level * 100
	--return 2
end