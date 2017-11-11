AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.BulletBounceTimes = 0
ENT.MaximumBounces = 0
ENT.BulletHitEffect = "electroshot_hit"
ENT.BulletHitEffectBlocked = "hit_bullet_blocked"
ENT.BulletDamageType = DMG_SHOCK