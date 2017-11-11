--[[
TODO:
-Organize this
]]

GAME_MAXWEIGHT = 70

EQUIP_ARMOR_BODY = 0
EQUIP_ARMOR_HEAD = 1
EQUIP_ARMOR_ACCESSORY1 = 2

WEAPON_TYPE_MELEE = 0
WEAPON_TYPE_GUN = 1
WEAPON_TYPE_THROW = 2

WEAPON_MATERIAL_METAL = 0
WEAPON_MATERIAL_PLASTIC = 1
WEAPON_MATERIAL_WOOD = 2

DEFAULT_WALKSPEED = 180
DEFAULT_RUNSPEED = 300

KARMA_OUTSTANDING = 10000
KARMA_GOOD = 5000
KARMA_CRIMINAL = -2000
KARMA_EVIL = -5000
KARMA_DREADED = -10000

SKILL_MAX_TOTAL = 3000
SKILL_MAX_SINGLE = 1000
SKILL_DEFAULT = 0
SKILL_SELECTIONBONUS = 35
SKILL_STARTING_PICKS = 1

REDUCTION_SPEED = -1
REDUCTION_STAMINA = -2

CONVERSATION_POINT = 0

NPC_REPAIRRATE = 5

DMG_NONLETHAL = 3

WEATHERTYPE_CLEAR = 0
WEATHERTYPE_RAIN = 1

DAMAGETYPE_TRANSLATE = {
	[DMG_BULLET] = "Bullet Damage",
	[DMG_DIRECT] = "Piercing Damage",
	[DMG_CLUB] = "Bludgeon Damage",
	[DMG_SLASH] = "Slashing Damage",
	[DMG_BURN] = "Fire Damage",
	[DMG_SHOCK] = "Electric Damage",
	[REDUCTION_SPEED] = "Move Speed",
	[REDUCTION_STAMINA] = "Stamina Regeneration"
}

CLEANNAMES = {
	["npc_nox_charger"] = "Charger",
	["npc_repairer"] = "Repairer",
	["npc_nox_zombie"] = "Zombie"
}

SKILL_GUNNERY = 0
SKILL_BLADEWEAPONS = 1
SKILL_GUNSMITHING = 2
SKILL_ENGINEERING = 3
SKILL_ELECTRONICS = 4
SKILL_UNARMED = 5
SKILL_BLUNTWEAPONS = 6

CRAFTING_GUNSMITHING = 0
CRAFTING_ENGINEERING = 1
CRAFTING_ELECTRONICS = 2
CRAFTING_REFINEMENT = 3

CRAFTING_STRING = {
	[CRAFTING_GUNSMITHING] = "Gunsmithing",
	[CRAFTING_ENGINEERING] = "Engineering",
	[CRAFTING_ELECTRONICS] = "Electronics",
	[CRAFTING_REFINEMENT] = "Refinement"
}

SKILLS = {}
SKILLS[SKILL_GUNNERY] = {Name = "Gunnery", Descrip = "Proficiency in the use of guns.", Default = SKILL_DEFAULT}
SKILLS[SKILL_BLADEWEAPONS] = {Name = "Blade Weapons", Descrip = "Proficiency in the use of bladed melee weapons.", Default = SKILL_DEFAULT}
SKILLS[SKILL_BLUNTWEAPONS] = {Name = "Blunt Weapons", Descrip = "Proficiency in the use of blunt melee weapons.", Default = SKILL_DEFAULT}
SKILLS[SKILL_UNARMED] = {Name = "Unarmed", Descrip = "Proficiency in using your fists.", Default = SKILL_DEFAULT}

SKILLS[SKILL_GUNSMITHING] = {Name = "Gunsmithing", Descrip = "Proficiency in the manufacturing of weapons.", Default = SKILL_DEFAULT}
SKILLS[SKILL_ENGINEERING] = {Name = "Engineering", Descrip = "Proficiency in the manufacturing of mechanical devices and items.", Default = SKILL_DEFAULT}
SKILLS[SKILL_ELECTRONICS] = {Name = "Electronics", Descrip = "Proficiency in the creation and use of electrical devices.", Default = SKILL_DEFAULT}


PROPERTY_DECAYTIME = 604800

PROPERTY_DECAYNAMES = {
"This property is like new.",
"This property is hardly worn.",
"This property is a bit worn.",
"This property is fairly worn.",
"This property is very worn.",
"This property is greatly worn.",
"This property is extremely worn.",
"This property is in danger of collapsing!",
}

PROPERTY_DECAYTIMES = {
0,
7200,
86400,
86400 * 2,
129600 * 2,
172800 * 2,
216000 * 2,
297000 * 2,
}

PROPERTY_MINLOCKDOWNS = 8
PROPERTY_MAXLOCKDOWNS = 50
PROPERTY_LOCKDOWNSPERSQUAREUNITS = 0.0002
PROPERTY_MAXPERACCOUNT = 1

ENHANCEMENT_ADD = 0
ENHANCEMENT_SUBTRACT = 1
ENHANCEMENT_MULTIPLY = 2
ENHANCEMENT_DIVIDE = 3
ENHANCEMENT_SET = 4

ENHANCEMENT_TYPE_BULLETS = 0
ENHANCEMENT_TYPE_ACCURACY = 1
ENHANCEMENT_TYPE_DAMAGE = 2
ENHANCEMENT_TYPE_CLIPSIZE = 3
ENHANCEMENT_TYPE_FIRERATE = 4

STAT_STRENGTH = 0
STAT_AGILITY = 1
STAT_INTELLIGENCE = 2
STAT_ENDURANCE = 3

STATS = {
	[STAT_STRENGTH] = {Name = "Strength", Description = "Determines max inventory weight and for wielding heavier weapons."},
	[STAT_AGILITY] = {Name = "Agility", Description = "Determines movement speed, stamina, and acrobatics."},
	[STAT_INTELLIGENCE] = {Name = "Intelligence", Description = "Determines recipe learning and crafting."},
	[STAT_ENDURANCE] = {Name = "Endurance", Description = "Determines maximum health and natual resistances."}
}

STATS_ALLOCATE_BASE = 8
STATS_FREEPOINTS = 3
STATS_MAXPERSTAT = 20
STATS_MAXTOTAL = 50

BASE_STAMINA_REGENERATION = 0.15

GAME_BASEWEIGHT = 60
GAME_WEIGHTPERSTRENGTH = 1
GAME_DEFAULT_JUMPPOWER = 160

GAME_BASEHEALTH = 70
GAME_HEALTHPERSTR = 1
GAME_HEALTHPEREND = 2

TEMPERATURE_BASE_ENTITY = 70
TEMPERATURE_BASE_PLAYER = 98

//Needs to be moved to a file system
//Actually, remove this for the live version
BLUEPRINTS = {}
BLUEPRINTS["combine_helicopter"] = {
	Name = "Combine Helicopter",
	FinishedEnt = {
		Name = "vehicle_combine_heli",
		Pos = Vector(0, 0, 100),
		Ang = Angle(0, 0, 0)
	},
	
	Parts = {
		{
			Pos = Vector(0, 0, 100),
			Ang = Angle(0, 0, 0),
			Name = "Main Body",
			ModelName = "models/Combine_Helicopter.mdl",
			Requirements = {
				["metal_iron"] = 50,
				["battery"] = 10,
				["engine"] = 1
			}
		}
	}
}

ITEM_CAT_AMMO = "Ammo"
ITEM_CAT_WEAPONS = "Weapons"
ITEM_CAT_ARMOR = "Armor"
ITEM_CAT_ECHIP = "E-Chip"
ITEM_CAT_FOOD = "Food"
ITEM_CAT_MATS = "Materials"
ITEM_CAT_DEPLOY = "Deployables"
ITEM_CAT_MEDICAL = "Medical"
ITEM_CAT_OTHER = "Other"

ITEM_CATEGORIES = {ITEM_CAT_AMMO, ITEM_CAT_ARMOR, ITEM_CAT_DEPLOY, ITEM_CAT_ECHIP, ITEM_CAT_FOOD, ITEM_CAT_MATS, ITEM_CAT_MEDICAL, ITEM_CAT_OTHER, ITEM_CAT_WEAPONS}


MINIGAME_SMELTING = 0
MINIGAME_DDR = 1