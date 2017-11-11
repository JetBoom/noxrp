AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.ShouldPersist = true

local EMOTES_MALE = {
	{"vo/npc/male01/hi01.wav", "Hi."},
	{"vo/npc/male01/hi02.wav", "Hi."}
}

local EMOTES_FEMALE = {
	{"vo/npc/female01/hi01.wav", "Hi."},
	{"vo/npc/female01/hi02.wav", "Hi."}
}

function ENT:Initialize()
	self.Gender = math.random(1, 2)
	if self.Gender == 1 then
		self:SetModel("models/player/group01/male_0"..math.random(1, 9)..".mdl" )
	else
		local num = math.random(1, 6)
		if num == 5 then num = 4 end
		self:SetModel("models/player/group01/Female_0"..num..".mdl" )
	end

	local data = {}
		data.start = self:GetPos()
		data.endpos = data.start - Vector(0,0,9999)
		data.mask = MASK_SOLID_BRUSHONLY

	local tr = util.TraceLine(data)
	self:SetPos(tr.HitPos)
	self:SetUseType(SIMPLE_USE)

	self:SetMerchantTitle("Merchant")

	self:SetSequence(self:LookupSequence("idle_all_01"))

	if not self.Inventory then
		self.Inventory = Item("container__base")
	end

	self.Openers = {}

	self.NextEmote = 0
end

function ENT:SetMerchantTitle(txt)
	self:SetDTString(0, txt)
end

function ENT:AddLocalItem(item)
	if not item.Price then
		item.Price = item.BasePrice or 20
	end

	self.Inventory:AddItem(item)
end

function ENT:UpdatePrices()
	-- Make sure all items have a price?
	for _, item in pairs(self.Inventory:GetContainer()) do
		item.Price = item.Price or 20
	end
end

function ENT:HasItem(item)
	amt = amt or 1

	for k, v in pairs(self.Inventory:GetContainer()) do
		if v:GetDataName() == item then
			return v
		end
	end
	return false
end

function ENT:BehaveUpdate( fInterval )
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then
		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );
	end
end

function ENT:RunBehaviour()
    while ( true ) do
        coroutine.yield()
    end
end

function ENT:OnInjured(cdmg)
	cdmg:SetDamage(0)
end

function ENT:OnKilled(cdmg)
	cdmg:SetDamage(0)
end

function ENT:AddOpener(pl)
	table.insert(self.Openers, pl)
end

function ENT:IsOpener(pl)
	for index, play in pairs(self.Openers) do
		if play == pl then
			return true
		end
	end

	return false
end

function ENT:RemoveOpener(pl)
	for index, play in pairs(self.Openers) do
		if play == pl then
			table.remove(self.Openers, index)
		end
	end
end

function ENT:Use(pl)
	if pl:IsPlayer() then
		if not self:IsOpener(pl) then
			pl:OpenMerchantMenu(self)
			self:AddOpener(pl)

			local ang = (pl:GetPos() - self:GetPos()):GetNormalized():Angle()
			ang.p = 0
			ang.r = 0

			self:SetAngles(ang)
			self:SetEyeTarget(pl:EyePos())


			if self.NextEmote < CurTime() then
				self.NextEmote = CurTime() + 4
				if self.Gender == 1 then
					local emote = EMOTES_MALE[math.random(#EMOTES_MALE)]

					self:EmitSound(emote[1])
					BroadcastLocalOverheadText(emote[2], self)
				else
					local emote = EMOTES_FEMALE[math.random(#EMOTES_FEMALE)]

					self:EmitSound(emote[1])
					BroadcastLocalOverheadText(emote[2], self)
				end
			end
		end
	end
end

function ENT:GetVarsToSave()
	local tab = {
		["Inventory"] = self.Inventory,
		["Model"] = self:GetModel(),
		["Gender"] = self.Gender,
		["Title"] = self:GetDTString(0)
	}

	return tab
end

function ENT:SetVarsToLoad(tab)
	if tab.Inventory then
		local str = tab.Inventory
		local otherinv = RecreateInventory(str)

		for _, item in pairs(otherinv:GetContainer()) do
			item:SetAmount(1)
		end
		self.Inventory = otherinv

		self:UpdatePrices()
	end

	if tab.Model then
		self:SetModel(tab.Model)

		self:SetSequence(self:LookupSequence("idle_all_01"))
	end

	if tab.Gender then
		self.Gender = tab.Gender
	end

	if tab.Title then
		self:SetMerchantTitle(tab.Title)
	end
end