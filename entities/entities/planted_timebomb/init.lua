AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_c4_planted.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(CONTINUOUS_USE)

	self.Death = CurTime() + 17.5
	self.CanPickUp = self.CanPickUp or true
	self.LastUse = CurTime()
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end

function ENT:Use(pl)
	if pl:HasItem("wirecutters") then
		self:AddDiffuse(FrameTime() * 2)
		--self:SetNetworkedFloat("dif", self:GetNetworkedFloat("dif", 0) + FrameTime() * 2)
	else
		self:AddDiffuse(FrameTime())
	--	self:SetNetworkedFloat("dif", self:GetNetworkedFloat("dif", 0) + FrameTime())
	end
	
	self.LastUse = CurTime()

--	if self:GetNetworkedFloat("dif", 0) > 10 then
	if self:GetDiffuse() > 10 then
		pl:SendNotification("You diffused the bomb!", 4)
		
		if self.CanPickUp then
			local ent = ents.Create("item_timebomb")
			if ent:IsValid() then
				ent:SetPos(self:GetPos())
				ent:SetAngles(self:GetAngles())
				ent:Spawn()
				ent:SetData()
			end
		end
		
		function self:Think() self:Remove() end
		function self:Use() end
	end
end

function ENT:AddDiffuse(amt)
	self:SetDiffuse(self:GetDiffuse() + amt)
end

function ENT:Think()
	if CurTime() >= self.Death then
		self:Explode()
	end
	
	if (self.LastUse + 1) < CurTime() and self:GetDiffuse() > 0 then
		self:SetDiffuse(math.max(self:GetDiffuse() - FrameTime() * 1.5, 0))
	end
end

function ENT:Explode()
	for _, ply in pairs(player.GetAll()) do
		local Dist = (ply:GetPos() - self:GetPos()):Length()
		if Dist < 8192 then
			ply:EmitSound( "weapons/c4/c4_explode1.wav", ( ( 8192 - Dist ) / 8192 ) * 100 )
		end
	end

	local Position = self:GetPos() + self:GetUp() * 48
	self:EmitSound("weapons/c4/c4_exp_deb2.wav")
	util.ScreenShake(Position, 64, 128, 3, 8192)
	util.BlastDamage(self, self.Player or self, Position, 1200, 600)
	
	
	local effect = EffectData()
		effect:SetOrigin(Position)
		effect:SetStart(Position)
	util.Effect("bomb_explode", effect)
	
	self:ThrowInSphere(self:GetPos(), 1000)
		
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 1200)) do
		local dir = (v:GetPos() - self:GetPos()):GetNormal()
		local dist = v:GetPos():Distance(self:GetPos())
			
		local phys = v:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter(dir * (2400 - 2400 * (dist / 1200)))
		end
	end
	
	self:Remove()
end

function ENT:ThrowInSphere(pos, radius)
	for _, pl in pairs(ents.FindInSphere(pos, radius)) do
		if pl:IsPlayer() then
			pl:SetGroundEntity(NULL)
			pl:SetVelocity(5000 * (pl:LocalToWorld(pl:OBBCenter()) - pos):GetNormalized())

			pl:KnockDown(5)
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
