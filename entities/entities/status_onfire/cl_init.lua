include("shared.lua")

local base = Material("noxrp/statusicons/status_onfire.png")
ENT.DisplayOnHud = true

function ENT:PanelDraw(x,y)
	if LocalPlayer() == self:GetOwner() then
		local col = Color(255, 20, 20)
			
		local dietime = self:GetDTFloat(0)
		local timet = math.Round(dietime - CurTime())
			
		draw.SimpleText(timet, "hidden18", x + 16, y + 42, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(base)
		surface.DrawTexturedRect(x, y, 32, 32)
	end
end

function ENT:DrawHud()
	if LocalPlayer() == self:GetOwner() then
		local per = self:GetDTFloat(0) - CurTime()
		local totaltime = self:GetDTFloat(0) - self.Created
		
		local percent = math.max(per / totaltime, 0)	
			
		surface.SetDrawColor(255, 150, 0, 100 * percent)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end

function ENT:OnInitialize()
	self.Created = CurTime()
	self.NextBurn = CurTime()
	
	AddLocalStatus(self)
end

function ENT:Draw()
	local owner = self:GetOwner()
	if not self.NextBurn then self.NextBurn = 0 end
	
	if self.NextBurn < CurTime() then
		local emitter = ParticleEmitter(self:GetPos())
		
		self.NextBurn = CurTime() + 0.05
		
		if owner:GetBoneCount() then
			for i = 0, owner:GetBoneCount(), 2 do
				local vPos = owner:GetBonePosition(i)
				local vel = owner:GetVelocity():GetNormalized()
				
				if vPos then
					local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), vPos + vel * 5)
						particle:SetDieTime(0.3)
						particle:SetStartAlpha(180)
						particle:SetEndAlpha(0)
						particle:SetStartSize(math.random(4, 6))
						particle:SetEndSize(math.random(6, 8))
						particle:SetRoll(math.Rand(260, 360))
						particle:SetColor(255,255,255)
						particle:SetGravity(Vector(0, 0, 100))
						particle:SetCollide(true)
				end
			end
		end
		
		local particle = emitter:Add("particle/smokestack", owner:GetPos() + owner:OBBCenter())
			particle:SetDieTime(math.Rand(1, 2))
			particle:SetStartAlpha(250)
			particle:SetEndAlpha(0)
			particle:SetStartSize(0)
			particle:SetEndSize(20)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand( -1, 1))
			particle:SetColor(20, 20, 20)
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, 100))
			
			
		emitter:Finish()
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner[self:GetClass()] == self then
		owner[self:GetClass()] = nil
	end
	
	RemoveLocalStatus(self)
end
