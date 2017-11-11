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

	self:SetUseType(SIMPLE_USE)

	self:SetSequence(self:LookupSequence("idle_all_01"))

	self.Openers = {}
	self.Containers = {}

	self.NextEmote = 0
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

function ENT:Use(pl)
	if pl:IsPlayer() then
		if not self:IsPlayerAnOpener(pl) then
			if not self.Containers[pl:GetAccountID()] then
				self.Containers[pl:GetAccountID()] = Item("container__base")
			end

			self:AddOpener(pl)
			pl:OpenOtherInventory(self, self.Containers[pl:GetAccountID()]:GetContainer())

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

function ENT:CloseAllOpeners()
	for _, pl in pairs(self:GetOpenedBy()) do
		CloseInventory(pl)
	end
end

function ENT:AddOpener(pl)
	table.insert(self.Openers, pl)
end

function ENT:RemoveOpener(pl)
	for index, play in pairs(self.Openers) do
		if play == pl then
			pl:SendLua("if LocalPlayer().v_InventoryPanelOther then LocalPlayer().v_InventoryPanelOther:FlushRemove() end")
			table.remove(self.Openers, index)
		end
	end
end

function ENT:IsIDAnOpener(id)
	for _, opener in pairs(self.Openers) do
		if opener:IsValid() then
			if opener:GetAccountID() == id then return true end
		end
	end

	return false
end

function ENT:IsPlayerAnOpener(pl)
	for _, opener in pairs(self.Openers) do
		if opener:IsValid() then
			if opener == pl then return true end
		end
	end

	return false
end

function ENT:OnTakeItem(pl, itemid)
	local sync = false

	if not self.Containers[pl:GetAccountID()] then
		self.Containers[pl:GetAccountID()] = Item("container__base")
		return
	end

	for k, v in pairs(self.Containers[pl:GetAccountID()]:GetContainer()) do
		if v:GetIDRef() == itemid then
			if pl:CanTakeItem(v, v:GetAmount()) then

				if v:GetData().SmeltTime then
					v:GetData().SmeltTime = nil
				end

				pl:InventoryAdd(v)

				sync = true

				table.remove(self.Containers[pl:GetAccountID()]:GetContainer(), k)
			end
		end
	end

	for k, ref in pairs(self.Containers[pl:GetAccountID()]:GetContainer()) do
		ref:SetIDRef(k)
	end

	if sync then
		self:SyncToOpener(pl)
	end

	//self:CheckWeight()
end

function ENT:SyncToOpener(pl)
	net.Start("sendOtherInventory")
		net.WriteTable(self.Containers[pl:GetAccountID()]:GetContainer())
	net.Send(pl)
end

function ENT:SyncToIDOpener(id)
	local pl
	for _, v in pairs(self.Openers) do
		if v:GetAccountID() == id then pl = v break end
	end

	if pl then
		net.Start("sendOtherInventory")
			net.WriteTable(self.Containers[id]:GetContainer())
		net.Send(pl)
	end
end

function ENT:GetOpenedBy()
	return self.Openers
end

function ENT:AddItem(pl, item)
	local amount = 0
	for _, item in pairs(self.Containers[pl:GetAccountID()]:GetContainer()) do
		amount = amount + item:GetAmount()
	end

	if amount + item:GetAmount() <= 10 then
		self.Containers[pl:GetAccountID()]:AddItem(item)

		if self:IsPlayerAnOpener(pl) then
			self:SyncToOpener(pl)
		end

		return true
	end

	return false
end

function ENT:Think()
end

function ENT:OnInjured(cdmg)
	cdmg:SetDamage(0)
end

function ENT:GetVarsToSave()
	local tab = {
		["Container"] = self.Containers
	}

	return tab
end

function ENT:SetVarsToLoad(tab)
	if tab.Container then
		for id, container in pairs(tab.Container) do
			self.Containers[id] = RecreateInventory(container, "container__base")
		end
	end
end