include("shared.lua")

function ENT:DrawHud()
end

function ENT:OnInitialize()
	AddLocalStatus(self)
	
	self.Created = CurTime()
	
	--to get past people just pressing escape since it doesn't call draw hooks
	local overlay = vgui.Create("DPanel")
		overlay:SetPos(0, 0)
		overlay:SetSize(ScrW(), ScrH())
		overlay:SetZPos(-1000)
		overlay.Paint = function(pnl, pw, ph)
			if (self:GetDTFloat(0) - 0.5) < CurTime() then
				local fadeout = (CurTime() - (self:GetDTFloat(0) - 0.5)) / 0.5
				
				surface.SetDrawColor(255, 255, 255, 255 - 255 * fadeout)
				surface.DrawRect(0, 0, pw, ph)
			else
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawRect(0, 0, pw, ph)
			end
		end
		
		overlay.Think = function(pnl)
			if self:GetDTFloat(0) < CurTime() then
				pnl:Remove()
			end
		end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner[self:GetClass()] == self then
		owner[self:GetClass()] = nil
	end
	
	RemoveLocalStatus(self)
end

