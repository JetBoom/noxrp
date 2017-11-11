AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.ToSave = {}

function ENT:Initialize()
	self.Gender = math.random(1, 2)
	if self.Gender == 1 then
		self:SetModel( "models/player/group01/male_0"..math.random(1, 9)..".mdl" )
	else
		local num = math.random(1, 6)
		if num == 5 then num = 4 end
		self:SetModel( "models/player/group01/female_0"..num..".mdl" )
	end

	local data = {}
		data.start = self:GetPos()
		data.endpos = data.start - Vector(0,0,9999)
		data.mask = MASK_SOLID_BRUSHONLY
		
	self.EntitiesTalkingTo = {}
		
	local tr = util.TraceLine(data)
	self:SetPos(tr.HitPos)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionBounds(Vector(-4, -4, 0), Vector(4, 4, 72)) 
	self:PhysicsInitBox(Vector(-4, -4, 0), Vector(4, 4, 72))
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end
end

local EMOTES_MALE = {
	["greet"] = {
		{"vo/npc/male01/hi01.wav", "Hi."},
		{"vo/npc/male01/hi02.wav", "Hi."}
	}
}

local EMOTES_FEMALE = {
	["greet"] = {
		{"vo/npc/female01/hi01.wav", "Hi."},
		{"vo/npc/female01/hi02.wav", "Hi."}
	}
}

function ENT:Use(pl)
	if pl:IsPlayer() then
		if pl.NPCTalkingTo == self then
			pl:EndConversation()
		else
			pl:StartConversation(self)
				
			local ang = (pl:GetPos() - self:GetPos()):GetNormalized():Angle()
			ang.p = 0
			ang.r = 0
			
			self:SetAngles(ang)
			self:SetEyeTarget(pl:GetShootPos())
		end
    end
end

function ENT:AcceptInput(inp, act, caller, data)
	if inp == "Use" then
		if caller:IsPlayer() then
			if caller.NPCTalkingTo == self then
				caller:EndConversation()
			else
				caller:StartConversation(self)
					
				local ang = (caller:GetPos() - self:GetPos()):GetNormalized():Angle()
				ang.p = 0
				ang.r = 0
				
				self:SetAngles(ang)
				self:SetEyeTarget(caller:GetShootPos())
			end
		end
	end
end

function ENT:AddTalker(ent)
	table.insert(self.EntitiesTalkingTo, ent)
	
	if self.Gender == 1 then
		local emote = EMOTES_MALE["greet"][math.random(#EMOTES_MALE)]
				
		self:EmitSound(emote[1])
		BroadcastLocalOverheadText(emote[2], self)
	else
		local emote = EMOTES_FEMALE["greet"][math.random(#EMOTES_FEMALE)]
				
		self:EmitSound(emote[1], 75, math.random(98, 102))
		BroadcastLocalOverheadText(emote[2], self)
	end
end

function ENT:RemoveTalker(ent)
	for k, v in pairs(self.EntitiesTalkingTo) do
		if v == ent then
			table.remove(self.EntitiesTalkingTo, k)
			break
		end
	end
end

function ENT:GetVarsToSave()
end

function ENT:SetVarsToLoad()
end
