include("shared.lua")

local icon = Material("noxrp/statusicons/status_bleed.png", "smooth")
ENT.DisplayOnHud = true


function ENT:PanelDraw(x,y)
	local col = Color(255,20,20)
		
	local dietime = self:GetDTFloat(0)
	local timet = math.Round(dietime - CurTime())

		
	draw.SimpleText(timet, "hidden18", x + 16, y + 42, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(x, y, 32, 32)
end

function ENT:OnInitialize()
	if self:GetOwner() == LocalPlayer() then
		AddLocalStatus(self)
	end
	
	self.Created = CurTime()
	self.NextBleed = CurTime() + 2
end

function ENT:Draw()
	local owner = self:GetOwner()
	
	if self.NextBleed < CurTime() then
		self.NextBleed = CurTime() + 2
		local pos = owner:GetPos() + owner:OBBCenter()
		local emitter = ParticleEmitter(pos)
		
		for i = 1, 10 do
			local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
				particle:SetVelocity(VectorRand() * 20)
				particle:SetDieTime(4)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(4)
				particle:SetEndSize(8)
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(255,20,20)
				particle:SetGravity(Vector(0,0,-400))
				particle:SetCollide(true)
		end
		
		emitter:Finish()
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner[self:GetClass()] == self then
		owner[self:GetClass()] = nil
	end
	
	if self:GetOwner() == LocalPlayer() then
		RemoveLocalStatus(self)
	end
end
