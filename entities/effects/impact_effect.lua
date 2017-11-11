local blood = surface.GetTextureID("decals/blood1")
function EFFECT:Init( data )
	local vPos = data:GetOrigin()
	local matType = math.Round(tonumber(data:GetRadius()))
	local wepType = data:GetScale()
	local dir = data:GetNormal()
	
	local emitter = ParticleEmitter(vPos)
	--local EFFECT_DETAIL = GetConVarNumber("nc_effectdetail")
	local damagetype = tonumber(data:GetDamageType())
	
	--[[if wepType == WEAPON_MATERIAL_WOOD then
		sound.Play("physics/wood/wood_plank_impact_hard"..math.random(5)..".wav", vPos)
	elseif wepType == WEAPON_MATERIAL_METAL then
		sound.Play("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", vPos)
	elseif wepType == WEAPON_MATERIAL_PLASTIC then
		sound.Play("physics/plastic/plastic_box_impact_bullet"..math.random(5)..".wav", vPos)
	end]]
	
	if matType == MAT_WOOD then
		sound.Play("physics/wood/wood_plank_impact_hard"..math.random(5)..".wav", vPos)
		for i=1, 8 do
			local particle = emitter:Add("particle/smokestack", vPos)
			particle:SetLighting(true)
			particle:SetVelocity(VectorRand() * 50)
			particle:SetDieTime(math.Rand(0.5, 0.85))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetColor(80,40,30)
			particle:SetStartSize(math.Rand(1, 2))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetGravity(Vector(0,0,-200))
			particle:SetCollide(true)
		end
	elseif matType == MAT_ALIENFLESH or matType == MAT_ANTLION or matType == MAT_FLESH or matType == MAT_BLOODYFLESH then
		if damagetype == DMG_SLASH then
			sound.Play("rpgsounds/impact_flesh_sharp"..math.random(3)..".wav", vPos)
		else
			sound.Play("physics/flesh/flesh_impact_hard"..math.random(5)..".wav", vPos)
		end
		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), vPos)
			particle:SetLighting(true)
			particle:SetVelocity(VectorRand()*50)
			particle:SetDieTime(4)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(math.Rand(4, 5))
			particle:SetEndSize(3)
			particle:SetRoll(math.Rand(-25, 25))
			particle:SetRollDelta(math.Rand(-25, 25))
			particle:SetAirResistance(5)
			particle:SetGravity(Vector(0, 0, -200))
			particle:SetCollide(true)
			particle:SetColor(255, 0, 0)
			particle:SetCollideCallback(function(particle, hitpos, normal)
				util.Decal("Blood", hitpos + normal, hitpos - normal)
			end)
	elseif matType == MAT_GLASS then
		sound.Play("physics/glass/glass_impact_hard"..math.random(3)..".wav", vPos)
	elseif matType == MAT_CONCRETE or matType == MAT_TILE then
		sound.Play("physics/concrete/concrete_impact_hard"..math.random(3)..".wav", vPos)
	elseif matType == MAT_DIRT or matType == MAT_EGGSHELL then
		sound.Play("physics/plaster/drywall_impact_hard"..math.random(3)..".wav", vPos)
		for i=1, 8 do
			local particle = emitter:Add("particle/smokestack", vPos)
			particle:SetLighting(true)
			particle:SetVelocity(VectorRand()*50)
			particle:SetDieTime(math.Rand(0.5, 0.85))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetColor(80,40,30)
			particle:SetStartSize(math.Rand(1, 2))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetGravity(Vector(0,0,-200))
			particle:SetCollide(true)
		end
	elseif matType == MAT_PLASTIC then
		sound.Play("physics/plastic/plastic_box_impact_bullet"..math.random(5)..".wav", vPos)
	end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
