local ITEM = {}
ITEM.DataName = "echip_pulse"

ITEM.Description = "Bullets will do less damage, but deal electric damage."
ITEM.ToolTip = "+Electric bullets\n-40% damage"
	
ITEM.AmmoLetter = "PS"
	
function ITEM:GetLetterColor()
	return Color(0, 205 + 50 * math.cos(CurTime() * 5), 205 + 50 * math.cos(CurTime() * 5))
end
	
function ITEM:DrawViewModelEffects(wep, vm)
	if wep.ParticleEmitter and wep.Ammo3DBone then
		local emitter = wep.ParticleEmitter
		local bone = vm:LookupBone(wep.Ammo3DBone)
		if not bone then return end

		local m = vm:GetBoneMatrix(bone)
		if not m then return end

		local pos, ang = m:GetTranslation(), m:GetAngles()
			
		pos = pos + ang:Up() * -10
			
			--for i=1, 1 do
		local particle = emitter:Add("effects/fire_cloud1", pos)
			particle:SetVelocity(wep:GetVelocity())
			particle:SetDieTime(0.4)
			particle:SetStartAlpha(180)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(1, 2))
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetColor(255, 220, 100)
			particle:SetCollide(true)
			--end
	end
end

RegisterItem(ITEM)