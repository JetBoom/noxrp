local meta = FindMetaTable("Player")
if not meta then return end

util.AddNetworkString("sendSkills")
util.AddNetworkString("sendStats")
util.AddNetworkString("sendBreath")
util.AddNetworkString("sendStamina")
util.AddNetworkString("sendMaxStamina")
util.AddNetworkString("sendItemVars")
util.AddNetworkString("addNotification")
util.AddNetworkString("sendEquipedEquipment")
util.AddNetworkString("sendOverheadText")
util.AddNetworkString("sendGlobalText")
util.AddNetworkString("sendKnownRecipes")
util.AddNetworkString("sendDiseases")
util.AddNetworkString("sendParty")
util.AddNetworkString("SendSkillNotification")
util.AddNetworkString("sendCriminalFlag")
util.AddNetworkString("clearCriminalFlag")

util.AddNetworkString("startConversation")
util.AddNetworkString("continueConversation")
util.AddNetworkString("endConversation")

util.AddNetworkString("refillVehAmmo")
util.AddNetworkString("vehToInventory")

function meta:SetTemperature(val) self:SetDTInt(0, val) end
function meta:SetRPTitle(title) self:SetDTString(0, title) self:ChatPrint("Your new title is '"..title.."'") end

function meta:AddLocalOverheadText(tab, ent)
	local data = {}

	if type(tab) == "string" then
		data.Text = tab
		data.Entity = ent:EntIndex()
	elseif type(tab) == "table" then
		data = tab
		data.Entity = ent:EntIndex()
	end

	net.Start("sendOverheadText")
		net.WriteTable(data)
	net.Send(self)
end

function meta:AddGlobalText(data)
	local tab = {}
		tab.Text = data.Text
		tab.LifeTime = CurTime() + (data.Lifetime or 5)
		tab.Color = data.Color or Color(200, 200, 255)
		tab.Alpha = data.Alpha or 200
		tab.Position = data.Position or Vector(0, 0, 0)

	net.Start("sendGlobalText")
		net.WriteTable(tab)
	net.Send(self)
end

function BroadcastLocalOverheadText(tab, ent)
	local data = {}

	if type(tab) == "string" then
		data.Text = tab
		data.Entity = ent:EntIndex()
	elseif type(tab) == "table" then
		data = tab
		data.Entity = ent:EntIndex()
	end

	net.Start("sendOverheadText")
		net.WriteTable(data)
	net.Broadcast()
end

local Gibs = {
	"models/gibs/HGIBS_spine.mdl",
	"models/gibs/HGIBS_rib.mdl",
	"models/gibs/HGIBS_scapula.mdl",
	"models/gibs/antlion_gib_medium_2.mdl",
	"models/gibs/Antlion_gib_Large_1.mdl"
}
function meta:Gib(dmginfo)
	for i = 1, math.random(2) do
		local gib = ents.Create("item_gib")
		if gib:IsValid() then
			local data = Item("gib")
				data:GetData().Owner = self:Nick()
				data:SetModel(Gibs[math.random(#Gibs)])

			gib:SetPos(self:GetPos() + Vector(0, 0, 40))
			gib:Spawn()
			gib:SetData(data)
			gib:SetVelocity(Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(0, 1)) * 300)
		end
	end

	local effect = EffectData()
		effect:SetOrigin(self:GetPos() + Vector(0, 0, 40))
	util.Effect("gib", effect)
end

function meta:GiveDisease(id)
	if not self:CanContractDisease(id) then return false end

	local disease = DISEASES[id]
	if not disease then return end

	if self.c_DiseaseResistances then
		table.Empty(self.c_DiseaseResistances)
	end

	local tab = disease:CreateTable()
	self.c_Diseases = self.c_Diseases or {}
	table.insert(self.c_Diseases, tab)

	disease:OnContract(self)

	self:SendDiseases()
end

function meta:CanContractDisease(name)
	return not self:HasDisease(name) and not (self.c_DiseaseResistances and table.HasValue(self.c_DiseaseResistances, name))
end

function meta:RemoveDisease(id)
	if not self.c_Diseases then return end

	local disease = DISEASES[id]
	if disease then
		for index, dis in pairs(self.c_Diseases) do
			if dis.Name == id then
				disease:OnCured(self)

				table.remove(self.c_Diseases, index)
			end
		end
	end

	self:SendDiseases()
end

function meta:SendDiseases()
	net.Start("sendDiseases")
		net.WriteTable(self:GetDiseases())
	net.Send(self)
end

function meta:JoinParty(pl)
	if not self.c_Party then self.c_Party = {} end

	self.c_InParty = true

	self:SendParty()
end

function meta:InviteToParty(pl)
	if not self.c_Party then self.c_Party = {} self.c_Party.Members = {} end

	if #self.c_Party.Members + ((self.c_Party.Leader and 1) or 0) >= 5 then return false end

	--If we don't have a leader, then make us the leader
	--Usually happens when we're just forming a party right now
	if not self.c_Party.Leader then
		self.c_Party.Leader = self
	end

	--Add the other player as a member
	table.insert(self.c_Party.Members, pl)

	for _, ply in pairs(self.c_Party.Members) do
		if ply ~= self then
			--Set their party reference to ours
			ply.c_Party = self.c_Party
			ply:SendParty()
		end
	end

	if not self.c_InParty then
		self.c_InParty = true
	end

	pl:JoinParty(self)
	self:SendParty()
end

function meta:LeaveParty()
	--If we're a regular party member, then remove ourselves from it
	if self.c_Party.Leader ~= self then
		for index, pl in pairs(self.c_Party.Members) do
			if pl == self then
				--Because its a reference, we can just do this
				table.remove(self.c_Party.Members, index)
			end
		end

		if self.c_Party.Leader then
			self.c_Party.Leader:SendPartyAll()
		end
	else
		--If there are at least two more members, then move the party around
		if #self.c_Party.Members > 1 then
			--If we're the leader, then remove ourselves from the leader position and make the first player member a leader
			local tab = table.Copy(self.c_Party)
				tab.Leader = tab.Members[1]
			table.remove(tab.Members, 1)

			tab.Leader.c_Party = tab

			tab.Leader:SendPartyAll()
		else
			--Otherwise, just empty the entire table
			local otherpl = self.c_Party.Members[1]

			self.c_InParty = false
			otherpl.c_InParty = false

			table.Empty(self.c_Party.Members)
			self.c_Party.Leader = nil

			otherpl:SendParty()
		end
	end

	self.c_InParty = false
	table.Empty(self.c_Party.Members)
	self.c_Party.Leader = nil

	self:SendParty()
end

function meta:SendParty()
	net.Start("sendParty")
		net.WriteTable(self.c_Party)
	net.Send(self)
end

function meta:SendPartyAll()
	net.Start("sendParty")
		net.WriteTable(self.c_Party)
	net.Send(self.c_Party.Members)

	net.Start("sendParty")
		net.WriteTable(self.c_Party)
	net.Send(self.c_Party.Leader)
end

function meta:KnockDown(time)
	if not self.c_KnockdownImmunity then self.c_KnockdownImmunity = 0 end
	if self.c_KnockdownImmunity > CurTime() then return end

	if self:Alive() and not self:InVehicle() then
		self.c_KnockdownImmunity = CurTime() + (time or 3) + 1
		self:GiveStatus("knockdown", time or 3)
	end
end

function meta:AddAttacker(attacker)
	self:GetAttackers()[attacker] = CurTime()
end

function meta:ClearAttackers()
	table.Empty(self.c_Attackers)
end

function meta:SetupStats(stats, newacct)
	if stats then
		self.c_Stats = stats
	else
		self.c_Stats = {}
		for i = 0, 3 do
			self.c_Stats[i].Base = STATS_ALLOCATE_BASE
			self.c_Stats[i].Modifiers = {}
		end
	end

	self:UpdateMaxHealth()
	if newacct then
		self:SetHealth(self:GetMaxHealth())
	end

	self:UpdateBoneSize()
	self:RecalcMaxStamina()
	self:SendStats()
end

function meta:UpdateMaxHealth()
	self:SetMaxHealth(GAME_BASEHEALTH + self:GetStat(STAT_STRENGTH) * GAME_HEALTHPERSTR + self:GetStat(STAT_ENDURANCE) * GAME_HEALTHPEREND)
	self:SetHealth(math.min(self:Health(), self:GetMaxHealth()))
end

function meta:GetTotalStat()
	local cur = 0
	for k, v in pairs(self:GetStats()) do
		cur = cur + v.Base
	end

	return cur
end

function meta:SendStats()
	self:UpdateSelf()

	net.Start("sendStats")
		net.WriteTable(self.c_Stats)
	net.Send(self)
end

function meta:UpdateSelf()
end

function meta:SetStat(stat, amt, notify)
	if (self:GetTotalStat() - self.c_Stats[stat].Base + amt) <= STATS_MAXTOTAL then
		self.c_Stats[stat].Base = amt

		self:UpdateBoneSize()
		self:SendStats()
	end
end
--[[
	for bonename, scale in pairs(self.BoneScales) do
		local boneid = pl:LookupBone(bonename)
		if boneid then
			pl:ManipulateBoneScale(boneid, scale)
		end
	end
]]

function meta:SetStatTemporary(stat, amt, timet)
	if not self.c_Stats[stat].Modifiers then
		self.c_Stats[stat].Modifiers = {}
	end

	table.insert(self.c_Stats[stat].Modifiers, {Mod = amt, Time = timet})
	self:SendStats()
end

function meta:AddStat(stat, amt)
	if (self:GetTotalStat() + amt) <= STATS_MAXTOTAL then
		self.c_Stats[stat].Base = self.c_Stats[stat].Base + amt

		self:SendNotification("Your "..STATS[stat].Name.." has increased by "..amt.."!")

		self:UpdateBoneSize()
		self:SendStats()
	end
end

--[[local StrengthBones = {
	"ValveBiped.Bip01_R_Upperarm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_L_Upperarm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_L_Clavicle"
}]]
function meta:UpdateBoneSize()
--Apparently the bone size manipulation lags, so this is disabled for now
--[[local scale = 1
	local strength = self:GetStat(STAT_STRENGTH)
	if strength > 8 then
		scale = 1 + math.min((strength - 8) * 0.03, 0.3)
	elseif strength < 8 then
		scale = math.max(1 - (8 - strength) * 0.1, 0.7)
	end

	for _, bonename in pairs(StrengthBones) do
		local boneid = self:LookupBone(bonename)
		if boneid and boneid > 0 then
			self:ManipulateBoneScale(boneid, Vector(1, scale, scale))
		end
	end
]]
end

hook.Add("Think", "Player.StatThink", function()
	for pi, pl in pairs(player.GetAll()) do
		if pl:Team() ~= TEAM_UNASSIGNED then
			local stats = pl:GetStats()
			for si, stat in pairs(stats) do
				if stat.Modifiers then
					for mi, modif in pairs(stat.Modifiers) do
						if modif.Time < CurTime() then
							table.remove(stat.Modifiers, mi)
							mi = mi - 1
						end
					end
				end
			end
		end
	end
end)

function meta:SendSkills()
	net.Start("sendSkills")
		net.WriteTable(self.c_Skills)
	net.Send(self)
end

function meta:SetSkill(skill, amt, notify)
	self.c_Skills[skill] = amt
	self:SendSkills()
end

function meta:GetSkillChance(skill)
	--Basically, the higher the total skill gets for a single player, the slower all skills will raise
	--This doesn't really happen until the player gets a skill or two to max before it gets noticiably slow

	local chance = 1
	local globalscale = self:GetTotalSkill() * 0.01
	--local skillscale = self:GetSkill(skill) * 0.04
	local skillscale = math.exp(skill / 200) + (skill) ^ 0.5

	chance = chance + globalscale + skillscale

	return chance
end

function meta:AddSkill(skill, amt, nonotify)
	if self.c_Skills[skill] + amt <= SKILL_MAX_SINGLE then
		local chance = self:GetSkillChance(skill)

		if math.random(chance) then
			self.c_Skills[skill] = math.Clamp(self.c_Skills[skill] + amt, 0, SKILL_MAX_SINGLE)
			if not nonotify then
				if amt > 0 then
					--self:SendNotification("Your skill '"..SKILLS[skill].Name.."' has increased by "..amt.."!")
					self:SendSkillNotification(skill, 5, amt)
				--[[else
					self:SendNotification("Your skill '"..SKILLS[skill].Name.."' has decreased by "..amt.."!")]]
				end
			end

			self:SendSkills()
		end
	end
end

function meta:SetDefaultRecipes()
	if not self.c_RecipeList then
		self.c_RecipeList = {}
	end

	for index, recipe in pairs(RECIPEES) do
		if recipe.IsDefault then
			table.insert(self.c_RecipeList, recipe.Name)
		end
	end

	self:SendRecipes()
end

--Only used for spawning: sets the recipes from the loading file, also checks for new recipes not learnt yet
function meta:SetRecipes(tab)
	self.c_RecipeList = tab

	for _, rec in pairs(RECIPEES) do
		if rec.IsDefault then
			local alreadylearned = false

			for _, plrec in pairs(self.c_RecipeList) do
				if plrec == rec.Name then
					alreadylearned = true
					break
				end
			end

			if not alreadylearned then
				table.insert(self.c_RecipeList, rec.Name)
			end
		end
	end

	self:SendRecipes()
end

function meta:LearnRecipe(recipe)
	if not self.c_RecipeList then
		self.c_RecipeList = {}
	end

	local rec = RECIPEES[recipe]
	if rec then
		local alreadylearned = false
		for _, plrec in pairs(self.c_RecipeList) do
			if plrec == recipe then
				alreadylearned = true
				break
			end
		end

		if not alreadylearned then
			table.insert(self.c_RecipeList, recipe)

			self:SendNotification("You learned a new recipe '"..rec.Display.."' !")
		else
			self:SendNotification("You already know this recipe!")
		end
	end

	self:SendRecipes()
end

function meta:SendRecipes()
	net.Start("sendKnownRecipes")
		net.WriteTable(self.c_RecipeList)
	net.Send(self)
end

function meta:SetDefaultSkills(data)
	self.c_Skills = {}
	for k,v in pairs(SKILLS) do
		if data then
			if table.HasValue(data.StartingSkills,k) then
				self.c_Skills[k] = SKILL_SELECTIONBONUS
			else
				self.c_Skills[k] = v.Default
			end
		else
			self.c_Skills[k] = v.Default
		end
	end
	self:SendSkills()
end

function meta:SetSkills(tbl)
	if not self.c_Skills then
		self.c_Skills = {}
	end
	self.c_Skills = tbl
	self:SendSkills()
end

function meta:SendEquipment(simpleupdate)
	simpleupdate = simpleupdate or false
	net.Start("sendEquipedEquipment")
		net.WriteTable(self.c_Equipment or {})
		net.WriteBool(simpleupdate)
	net.Send(self)
end

function meta:SetEquipment(slot, item)
	local fitem = GetGlobalItem(item:GetDataName())

	if not self.c_Equipment then
		self.c_Equipment = {}
	end

	if self.c_Equipment[slot] == item:GetIDRef() then
		self.c_Equipment[slot] = nil
		if fitem.OnUnEquip then
			fitem:OnUnEquip(self)
		end
	else
		self.c_Equipment[slot] = item:GetIDRef()

		if fitem.OnEquip then
			fitem:OnEquip(self)
		end
	end

	if self:GetHands():IsValid() then
		GAMEMODE:PlayerSetHandsModel( self, self:GetHands() )
	end

	self:SetCachedStamRegen(self:GetStaminaRegeneration())

	self:SendEquipment()
	self:RecalcMoveSpeed()
end

function meta:RemoveEquipment(slot)
	if self.c_Equipment[slot] then
		local item = ITEMS[self:GetItemByID(self.c_Equipment[slot]):GetDataName()]

		if item then
			if item.OnUnEquip then
				item:OnUnEquip(self)
			end
		end

		self.c_Equipment[slot] = nil
	end

	self:SendEquipment()
	self:RecalcMoveSpeed()
end

function meta:RemoveAllEquipment()
	if not self.c_Equipment then
		self.c_Equipment = {}
	end

	if self.c_Equipment[EQUIP_ARMOR_BODY] then
		local item = ITEMS[self:GetItemByID(self.c_Equipment[EQUIP_ARMOR_BODY]):GetDataName()]

		self.c_Equipment[EQUIP_ARMOR_BODY] = nil
		if item then
			if item.OnUnEquip then
				item:OnUnEquip(self)
			end
		end
	end

	if self.c_Equipment[EQUIP_ARMOR_HEAD] then
		local item = ITEMS[self:GetItemByID(self.c_Equipment[EQUIP_ARMOR_HEAD]):GetDataName()]

		self.c_Equipment[EQUIP_ARMOR_HEAD] = nil

		if item then
			if item.OnUnEquip then
				item:OnUnEquip(self)
			end
		end
	end

	if self.c_Equipment[EQUIP_ARMOR_ACCESSORY1] then
		local item = ITEMS[self:GetItemByID(self.c_Equipment[EQUIP_ARMOR_ACCESSORY1]):GetDataName()]

		self.c_Equipment[EQUIP_ARMOR_ACCESSORY1] = nil
		if item then
			if item.OnUnEquip then
				item:OnUnEquip(self)
			end
		end
	end

	self:SetCachedStamRegen(self:GetStaminaRegeneration())

	self:RecalcMoveSpeed()
	self:SendEquipment()
end

function meta:RecalcMoveSpeed()
	local totalsp = 1

	local equip = self.c_Equipment
	if equip then
		for _,equipment in pairs(equip) do
			local item = self:GetItemByID(equipment)
			local fitem = GetGlobalItem(item:GetDataName())
			for stat, val in pairs(fitem.ArmorBonus) do
				if stat == REDUCTION_SPEED then
					totalsp = math.max(totalsp - val, 0.2)
				end
			end
		end
	end

	local wep = self:GetActiveWeapon()
	if wep:IsValid() then
		if wep.ModifyMoveSpeed then
			totalsp = math.max(totalsp - wep.ModifyMoveSpeed, 0.4)
		end
	end

	if self:GetStat(STAT_AGILITY) > 10 then
		totalsp = math.min(totalsp + 0.01 * (self:GetStat(STAT_AGILITY) - 10), 1.6)

		self:SetJumpPower(GAME_DEFAULT_JUMPPOWER + 4 * (self:GetStat(STAT_AGILITY) - 10))
	elseif self:GetStat(STAT_AGILITY) < 10 then
		totalsp = math.max(totalsp - 0.01 * ((self:GetStat(STAT_AGILITY) - 10) * -1), 0.4)
		self:SetJumpPower(GAME_DEFAULT_JUMPPOWER - 4 * ((self:GetStat(STAT_AGILITY) - 10) * -1))
	end


	self.c_WalkSpeed = math.Round(DEFAULT_WALKSPEED * totalsp, 1)
	self.c_RunSpeed = math.Round(DEFAULT_RUNSPEED * totalsp, 1)

	self:SetWalkSpeed(self.c_WalkSpeed)
	self:SetRunSpeed(self.c_RunSpeed)
	self:SetMaxSpeed(self.c_RunSpeed)
end

function meta:SetBreathLevel(amt)
	self.c_BreathLevel = math.Clamp(amt, 0, 100)
	self:SendBreathLevel()
end

function meta:AddBreathLevel(amt)
	self.c_BreathLevel = math.Clamp(self.c_BreathLevel + amt, 0, 100)
	self:SendBreathLevel()
end

function meta:SendBreathLevel()
	net.Start("sendBreath")
		net.WriteInt(self.c_BreathLevel, 8)
	net.Send(self)
end

function meta:SendNotification(text, dietime, color, soundtoplay, hint, font, newline)
	local tblcol = {}
	if color then
		tblcol.r = color.r
		tblcol.g = color.g
		tblcol.b = color.b
	else
		tblcol.r = 255
		tblcol.g = 255
		tblcol.b = 255
	end

	soundtoplay = soundtoplay or ""
	hint = hint or 0

	net.Start("addNotification")
		net.WriteString(text)
		net.WriteInt(dietime or 3, 8)
		net.WriteTable(tblcol)
		net.WriteString(soundtoplay)
		net.WriteInt(hint, 4)
		net.WriteString(font or "")
		net.WriteBit(newline or true)
	net.Send(self)
end

function meta:SendSkillNotification(skill, dietime, points)
	if not skill then return end
	dietime = dietime or 5
	points = points or 1
	net.Start("SendSkillNotification")
		net.WriteInt(skill, 10)
		net.WriteFloat(dietime, 10)
		net.WriteInt(points, 10)
	net.Send(self)
end

function meta:SetStamina(amt)
	self.c_Stamina = amt
--	self:SendStamina()
end

function meta:AddStamina(amt)
	self.c_Stamina = math.Clamp(self.c_Stamina + amt, 0, self:GetMaxStamina())
--	self:SendStamina()
end

function meta:SetSprinting(bool)
	self:SetDTBool(0, bool)
end

function meta:RecalcMaxStamina()
	local stam = 100
	if self:GetStat(STAT_ENDURANCE) > 10 then
		stam = stam + 3 * (self:GetStat(STAT_ENDURANCE) - 10)
	elseif self:GetStat(STAT_ENDURANCE) < 10 then
		stam = stam - 3 * ((self:GetStat(STAT_ENDURANCE) - 10) * -1)
	end

	self:SetMaxStamina(stam)
	self:SendMaxStamina()
end

function meta:SetMaxStamina(val)
	self.c_MaxStamina = val
end

function meta:SendStamina()
	net.Start("sendStamina")
		net.WriteInt(self.c_Stamina, 8)
	net.Send(self)
end

function meta:SendMaxStamina()
	net.Start("sendMaxStamina")
		net.WriteInt(self.c_MaxStamina, 8)
	net.Send(self)
end

function meta:SendItemVariables()
	net.Start("sendItemVars")
		net.WriteTable(self.c_ItemVars)
	net.Send(self)
end

--TODO: Sync this to clients
function meta:SetCriminalFlag(time, duration)
	--Clamp the duration to a max of 3 minutes
	duration = math.min(duration, 60 * 3)
	self.c_CriminalFlag = {Start = time, Duration = duration}

	local tab = {Entity = self:EntIndex(), Start = time, Duration = duration}

	net.Start("sendCriminalFlag")
		net.WriteTable(tab)
	net.Send(player.GetAll())
end

function meta:RemoveCriminalFlag()
	self.c_CriminalFlag = nil

	net.Start("clearCriminalFlag")
		net.WriteTable({self:EntIndex()})
	net.Send(player.GetAll())
end

function meta:SetKarma(set)
	self:SetDTInt(1, set)
end

function meta:AddKarma(amt, notify, limit)
	notify = notify or true

	if limit == nil then
		self:SetDTInt(1, math.Clamp(self:Karma() + amt, -15000, 15000))
	elseif limit > 0 then
		if self:Karma() >= limit then
			self:SendNotification("No one cares enough for you to get recognition.")
			return
		else
			self:SetDTInt(1, math.Clamp(self:Karma() + amt, -15000, limit))
		end
	elseif limit < 0 then
		if self:Karma() <= limit then
			self:SendNotification("No one cares enough for you to be associated.")
			return
		else
			self:SetDTInt(1, math.Clamp(self:Karma() + amt, limit, 15000))
		end
	end

	if notify then
		if amt > 500 then
			self:SendNotification("You have gained a ton of karma.")
		elseif amt > 250 then
			self:SendNotification("You have gained karma.")
		elseif amt > 0 then
			self:SendNotification("You have gained some karma.")
		elseif amt > -250 then
			self:SendNotification("You have lost some karma.")
		elseif amt > -500 then
			self:SendNotification("You have lost karma.")
		else
			self:SendNotification("You have lost a ton of karma.")
		end
	end
end

function meta:KilledBy(killer)
	local mykarma = self:Karma()
	--if killer == self and mykarma - 300 > KARMA_EVIL then
	--	self:AwardKarma(-300, true)
	--end

	self:AddAttacker(killer)

	local karma = -(mykarma + 2000) / 50
	local curtime = CurTime()

	for attacker, lastattack in pairs(self:GetAttackers()) do
		if lastattack + 30 > curtime and attacker:IsValid() and attacker ~= self and (attacker.SendLua or attacker:IsNPC()) then
			attacker:AddKarma(karma, true)
		end
	end

	if KARMA_CRIMINAL < mykarma then
		CallCops(self)
	end

	self.Attackers = {}
end

function meta:UpdateArmorDurability(hitgroup, dmginfo)
	if hitgroup == HITGROUP_HEAD then
		if self:GetEquipmentSlot(EQUIP_ARMOR_HEAD) then
			local id = self:GetEquipmentSlot(EQUIP_ARMOR_HEAD)
			local item = self:GetItemByID(id)

			--SendNotification(text, dietime, color, soundtoplay, hint, font, newline)
			item:GetData().Durability = math.max(math.Round(item:GetDurability().Durability - dmginfo:GetBaseDamage() * 0.05, 2), 0)
			if item:GetData().Durability == 0 then
				self:SendNotification("Your helmet has broke!", 5, Color(255, 100, 100), nil, 1)
			end

			self:SendInventory()
		end
	else
		if self:GetEquipmentSlot(EQUIP_ARMOR_BODY) then
			local id = self:GetEquipmentSlot(EQUIP_ARMOR_BODY)
			local item = self:GetItemByID(id)

			item:GetData().Durability = math.max(math.Round(item:GetData().Durability - dmginfo:GetBaseDamage() * 0.02, 2), 0)
			if item:GetData().Durability == 0 then
				self:SendNotification("Your armor has broke!", 5, Color(255, 100, 100), nil, 1)
			end

			self:SendInventory()
		end
	end
end

function meta:StartBleeding(start)
	if not self["status_bleeding"] then
		local ent = ents.Create("status_bleeding")
		if ent:IsValid() then
			ent:Spawn()
			ent:SetPlayer(self)
			ent.Owner = self
		end
	end
end

function meta:CanBlock(ent, damagetype, dmginfo, damage)
	local wep = self:GetActiveWeapon()
	if wep:IsValid() then
		if wep.CanBlock then
			return wep:CanBlockHit(ent, damagetype, dmginfo, damage)
		else
			return false
		end
	end
	return false
end

function GetBuildText(convo, pl)
	return convo.BuildText(pl)
end

function GetBuildChoices(convo, pl)
	return convo.BuildChoices(pl)
end

function meta:StartConversation(entity)
	if self.Conversation then return end
	local text = GetBuildText(entity.Conversation[0], self)

	entity:AddTalker(self)

	local choices
	if entity.Conversation[0].BuildChoices then
		choices = GetBuildChoices(entity.Conversation[0], self)
	else
		choices = entity.Conversation[0].Choices
	end

	local convo = {Entity = entity, Text = text, Choices = choices}

	self.Conversation = convo

	net.Start("startConversation")
		net.WriteEntity(entity)
		net.WriteString(Serialize(convo))
	net.Send(self)
end

function meta:EndConversation()
	self.Conversation.Entity:RemoveTalker(self)
	self.Conversation = nil

	net.Start("endConversation")
	net.Send(self)
end

function EndConversation_CL(len, pl)
	pl:EndConversation()
end
net.Receive("endConversation", EndConversation_CL)

function ContinueConversation(len, pl)
	if not pl.Conversation then return end

	if pl.Conversation.Entity then
		local option = net.ReadInt(4)

		local point = pl.Conversation
		if point.Choices[option] then
			local arg = point.Choices[option][2]

			if arg == -1 then
				pl:EndConversation()
			else
				local entity = pl.Conversation.Entity

				local text = GetBuildText(entity.Conversation[arg], pl)

				local choices
				if entity.Conversation[arg].BuildChoices then
					choices = GetBuildChoices(entity.Conversation[arg], pl)
				else
					choices = entity.Conversation[arg].Choices
				end

				local tab = {Entity = pl.Conversation.Entity, Text = text, Choices = choices}

				pl.Conversation = tab

				net.Start("continueConversation")
					net.WriteString(Serialize(tab))
				net.Send(pl)
			end
		end
	end
end
net.Receive("continueConversation", ContinueConversation)

function RefillVehicleAmmo(len, pl)
	if pl:InVehicle() then return end
	local slot = net.ReadInt(4)

	local data = {}
		data.start = pl:GetShootPos()
		data.endpos = data.start + pl:GetAimVector() * 100
		data.filter = pl

	local tr = util.TraceLine(data)
	if tr.Entity:IsValid() then
		if tr.Entity.PlayerGiveAmmo then
			tr.Entity:PlayerGiveAmmo(pl, slot)
		end
	end
end
net.Receive("refillVehAmmo", RefillVehicleAmmo)

function VehicleToInventory(len, pl)
	if pl:InVehicle() then return end

	local data = {}
		data.start = pl:GetShootPos()
		data.endpos = data.start + pl:GetAimVector() * 200
		data.filter = pl

	local tr = util.TraceLine(data)
	if tr.Entity:IsValid() then
		if tr.Entity.IsCraftedVehicle then
			local figurine = Item("vehfigurine")
			figurine:SetData(tr.Entity:GetVarsToSave())
			figurine:GetData().VehicleClass = tr.Entity:GetClass()
			figurine:SetItemName("'"..tr.Entity.VehicleName.."' Figurine")

			pl:InventoryAdd(figurine)

			tr.Entity:Remove()
		elseif tr.Entity:GetClass() == "prop_vehicle_jeep" then
			local figurine = Item("vehfigurine")
			figurine:GetData().VehicleClass = tr.Entity:GetClass()
			figurine:GetData().VehicleModel = tr.Entity:GetModel()
			figurine:GetData().VehicleSkin = tr.Entity:GetSkin()
			figurine:GetData().VehicleColor = tr.Entity:GetColor()
			figurine:GetData().RegularVehicle = true

			pl:InventoryAdd(figurine)

			tr.Entity:Remove()
		end
	end
end
net.Receive("vehToInventory", VehicleToInventory)

function meta:AddFollower(ent)
	if not self.t_Followers then
		self.t_Followers = {}
	end

	table.insert(self.t_Followers, ent)
end

function meta:GetFollowers()
	if not self.t_Followers then
		self.t_Followers = {}
	end

	return self.t_Followers
end

function meta:RemoveFollower(ent)
	if not self.t_Followers then
		self.t_Followers = {}
	end

	for i, tab in pairs(self.t_Followers) do
		if tab == ent then
			table.remove(self.t_Followers, i)
		end
	end
end
