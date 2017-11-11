function EFFECT:Init( data )
	local vPos = data:GetOrigin()
	
	local emitter = ParticleEmitter(vPos)
	
	util.Decal("Scorch", vPos + Vector(0, 0, 1), vPos + Vector(0, 0, -1))

	sound.Play("weapons/explode3.wav", vPos, 80)
	
	for i=1, 8 do
		local heading = VectorRand()
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), vPos)
		particle:SetVelocity(heading * math.Rand(500, 1200))
		particle:SetDieTime(math.Rand(4, 6))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(6)
		particle:SetEndSize(8)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(20, 50))
		particle:SetGravity(Vector(0, 0, -500))
	end
	
	for i=1, 8 do
		local heading = VectorRand()
			heading.z = math.abs(heading.z)
		heading:Normalize()

		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), vPos + heading * 6)
		particle:SetVelocity(Vector(heading.x * math.Rand(200, 400), heading.y * math.Rand(200, 400), heading.z * math.Rand(1200, 1550)))
		particle:SetDieTime(math.Rand(1, 1.5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(20)
		particle:SetEndSize(30)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetColor(255, 255, 255)
		particle:SetAirResistance(math.Rand(400, 600))
	end
	
	for i = 1, 4 do
		local particle = emitter:Add("particle/smokestack", vPos + VectorRand() * math.Rand(2, 4))
			particle:SetVelocity(VectorRand() * 200)
			particle:SetDieTime(math.Rand(4, 5.3))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(50)
			particle:SetEndSize(80)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand( -1, 1))
			particle:SetAirResistance(100)
			particle:SetCollide(true)
			particle:SetBounce(0.5)
			particle:SetColor(30, 30, 30)
	end
	
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
