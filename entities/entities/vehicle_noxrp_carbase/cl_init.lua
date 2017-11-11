include("shared.lua")

function ENT:Initialize()
	self:SetSequence("idle")
end

function ENT:ToInventory()
	net.Start("vehToInventory")
	net.SendToServer()
end

function ENT:AddWorldInteractionOptions(dmenu)
	LocalPlayer().WorldInteractionList = {
		{Title = "To Inventory", Function = function() self:ToInventory() end}
	}
end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:Draw()
	local ang = Angle(180, EyeAngles().y + 90, EyeAngles().r - 90)
	--print("DRAWWW")
	cam.Start3D2D(LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 30, ang, 1)
		local CamData = {}
			CamData.angles = Angle(0, 0, 0)
			CamData.origin = LocalPlayer():GetPos()+Vector(0,0,500)
			CamData.x = -50
			CamData.y = -50
			CamData.w = 100
			CamData.h = 100
		render.RenderView( CamData )
	cam.End3D2D()
end

function ENT:DrawOnHUD()
end

function ENT:GetViewTable(ply, pos, ang, fov)
end