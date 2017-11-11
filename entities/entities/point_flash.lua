ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("")
		self:PhysicsInit(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Wake()
		end
	end
end

if CLIENT then
	local glow = Material("sprites/dot", "smooth")
	function ENT:Draw()
		local toscreen = self:GetPos():ToScreen()
		
		local cx, cy = ScrW() * 0.5, ScrH() * 0.5
		
		local dist = math.sqrt((toscreen.x - cx) ^ 2 + (toscreen.y - cy) ^ 2)
		local size = 1000 - 1000 * (dist / ScrW())
		
		render.SetMaterial(glow)
		render.DrawSprite(self:GetPos(), size, size, Color(255, 255, 255, 255))
	end
end