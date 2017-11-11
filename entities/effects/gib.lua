function EFFECT:Init( data )
	local vPos = data:GetOrigin()
	local magnitude = math.ceil(data:GetMagnitude()) or 1

	--print(magnitude)

	local emitter = ParticleEmitter(vPos)

	if magnitude == 1 then
		for i = 1, 12 do
			local vec = VectorRand()
			vec:Normalize()
			local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), vPos)
				particle:SetVelocity(vec * 100)
				particle:SetGravity(Vector(0, 0, -200))
				particle:SetDieTime(0.7)
				particle:SetStartAlpha(180)
				particle:SetEndAlpha(0)
				particle:SetStartSize(32)
				particle:SetEndSize(24)
				particle:SetRoll(math.Rand(50, 60))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255, 100, 100)
				particle:SetCollide(true)
				particle:SetAirResistance(50)
		end

		for i = 1, 12 do
			local vec = VectorRand()
			vec:Normalize()
			local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), vPos)
				particle:SetVelocity(vec * 450)
				particle:SetGravity(Vector(0, 0, -600))
				particle:SetDieTime(1.2)
				particle:SetStartAlpha(180)
				particle:SetEndAlpha(0)
				particle:SetStartSize(8)
				particle:SetEndSize(6)
				particle:SetRoll(math.Rand(50, 60))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255, 100, 100)
				particle:SetCollide(true)
				particle:SetAirResistance(200)
		end
	elseif magnitude == 2 then
		for i = 1, 30 do
			local vec = Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(1, 1.5))

			local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), vPos)
				particle:SetVelocity(vec * 800)
				particle:SetGravity(Vector(0, 0, -600))
				particle:SetDieTime(math.Rand(1.5, 2))
				particle:SetStartAlpha(180)
				particle:SetEndAlpha(0)
				particle:SetStartSize(60)
				particle:SetEndSize(80)
				particle:SetRoll(math.Rand(50, 60))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255, 100, 100)
				particle:SetCollide(true)
				particle:SetAirResistance(200)
		end

		for i = 1, 8 do
			local vec = Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(1, 1.5))

			local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), vPos)
				particle:SetVelocity(vec * 200)
				particle:SetGravity(Vector(0, 0, -100))
				particle:SetDieTime(1.2)
				particle:SetStartAlpha(180)
				particle:SetEndAlpha(0)
				particle:SetStartSize(120)
				particle:SetEndSize(160)
				particle:SetRoll(math.Rand(50, 60))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255, 100, 100)
				particle:SetCollide(true)
				particle:SetAirResistance(200)
		end
	end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
