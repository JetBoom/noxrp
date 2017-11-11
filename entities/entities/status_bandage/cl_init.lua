include("shared.lua")

local icon = Material("noxrp/statusicons/status_heal.png", "smooth")
ENT.DisplayOnHud = true

function ENT:PanelDraw(x,y)
	local col = Color(20, 255, 20)
		
	local dietime = self:GetDTFloat(0)
	local timet = math.Round(dietime - CurTime())
		
	draw.SimpleText(timet, "hidden18", x + 16, y + 42, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(x,y,32,32)
end

function ENT:OnInitialize()
	AddLocalStatus(self)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner[self:GetClass()] == self then
		owner[self:GetClass()] = nil
	end
	
	RemoveLocalStatus(self)
end
