--[[
	This is the base for all nextbot npcs in the game.
]]

AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.NextBot			= true

ENT.CleanName = "NPC_NOX_BASE"
ENT.CanBleed = true
ENT.CanRaiseSkill = true

--This is for the sv_saveload to ask if we should save this across maps.
--Reason this exists is because normally the npcs are going to spawn either by an event (unfinished), or by a spawner which will just spawn them again anyway.
ENT.ShouldPersist = false

if SERVER then
	--Initialize
	--Initialize2 that is called is in the specif entity file, which is for entity specific initialization instructions
	function ENT:Initialize()
		self:CreateRelationshipVars()
		self:SetAwarenessRadius(2000)
		self:SetTargetRadius(600)

		--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		--NPC Local Initialize
		self:Initialize2()

		self:PhysicsInitShadow(true, false)
		self:SetCustomCollisionCheck(true)
		self.Attackers = {}
	end

	--Returns a clean name for the entity (ie "Zombie" instead of npc_nox_zombie
	function ENT:GetCleanName()
		return self.CleanName
	end

	function ENT:GetTeamID()
		return 0
	end

	--The radius in units where the nextbot should be able to be aware of entities.
	--The difference between this and target radius is this is how far away this bot should care about another entity.
	--Target radius determines whether or not we should attack them.
	function ENT:SetAwarenessRadius(size)
		self.ai_AwarenessRadius = size
	end

	function ENT:GetAwarenessRadius()
		return self.ai_AwarenessRadius
	end

	function ENT:SetTargetRadius(size)
		self.ai_TargetRadius = size
	end

	function ENT:GetTargetRadius()
		return self.ai_TargetRadius
	end

	--Just creates the tables for relationships
	function ENT:CreateRelationshipVars()
		self.ai_Relationships = {}
		self.ai_ClassRelationships = {}
		self.ai_RelationToPlayers = {}
	end

	--Sets the relationship to a specific entity
	--This takes precident over any other general relations
	function ENT:SetRelationship(target, relation, intensity)
		local tab = {}
			tab.Relationship = relation
			tab.Intensity = intensity

		self.ai_Relationships[target] = tab
	end

	--Sets the relationship to an entity's class
	function ENT:SetRelationshipToClass(class, relation, intensity)
		local tab = {}
			tab.Relationship = relation
			tab.Intensity = intensity

		self.ai_ClassRelationships[class] = tab
	end

	--Sets the relationship to all players
	function ENT:SetRelationshipToPlayers(relation, intensity)
		local tab = {}
			tab.Relationship = relation
			tab.Intensity = intensity

		self.ai_RelationToPlayers = tab
	end

	function ENT:GetRelationshipToPlayers()
		return self.ai_RelationToPlayers
	end


	--For checking the relationship is valid
	function ENT:IsValidTargetRelation(target, relation)
		if target:IsValid() then
			--if we have a specific relation to this entity, then check it
			if self.ai_Relationships[target] then
				if self:GetRelationship(target).Relationship == relation then
					return true
				else
					return false
				end
			else
				--otherwise, if they're a player...
				if target:IsPlayer() then
					--ignore them if they haven't even spawned yet
					if target:Team() == TEAM_UNASSIGNED then return false end
					--get the relation to the general player relation
					if self:GetRelationship(target).Relationship == relation then
						return true
					else
						return false
					end
				else
					--if they're a regular entity(nextbot), then get the relation to that class
					if self:GetRelationship(target).Relationship == relation then
						return true
					else
						return false
					end
				end
			end
		end
	end

	--Returns the default relationship for anything
	function ENT:GetDefaultRelationship()
		return {Relationship = G_RELATIONSHIP_NEUTRAL, Intensity = 1}
	end

	--Gets the relationship to a specific entity
	--If not a specific relationship, then get the relationship for its class
	function ENT:GetRelationship(target)
		--Check our relationship for this specific entity
		if self.ai_Relationships[target] then
			return self.ai_Relationships[target]
		else
			--If we don't have one, then check the player relation and the general entity relation, followed by default relation
			local ref

			if target:IsPlayer() then
				ref = self:GetRelationshipToPlayers()
			else
				if self.ai_ClassRelationships[target:GetClass()] then
					ref = self.ai_ClassRelationships[target:GetClass()]
				else
					ref = self:GetDefaultRelationship()
				end
			end

			if ref then
				return ref
			else
				return nil
			end
		end
	end

	--gets an entity for the ones around it, based on the awareness radius
	function ENT:FindTargetsAndSet(sortmethod)
		sortmethod = sortmethod or G_RELATION_SORT_CLOSEST
		if sortmethod == G_RELATION_SORT_CLOSEST then
			local dist = 9999
			local ent

			for _, target in pairs(ents.FindInSphere(self:GetPos(), self:GetTargetRadius())) do
				if target ~= self then
					if (string.find(target:GetClass(), "npc_") and (target:IsNPC() or target:IsNextBot())) or target:IsPlayer() then
						if self:IsValidTargetRelation(target, G_RELATIONSHIP_HATE) and self:CheckTargetValidity(target) then
							local dist2 = self:GetPos():Distance(target:GetPos())
							if dist2 < dist then
								ent = target
								dist = dist2
							end
						end
					end
				end
			end

			if ent then
				self:SetTarget(ent)
			end
		elseif sortmethod == G_RELATION_SORT_FURTHEST then
			local dist = 0
			local ent

			for _, target in pairs(ents.FindInSphere(self:GetPos(), self:GetTargetRadius())) do
				if self:IsValidTargetRelation(target, G_RELATIONSHIP_HATE) then
					local dist2 = self:GetPos():Distance(target:GetPos())
					if dist2 > dist then
						ent = target
						dist = dist2
					end
				end
			end

			if ent then
				self:SetTarget(ent)
			end
		end
	end

	--Sets the target for the entity
	--Calls OnTargetSet which is a function in the specific entity, so it can decide what to do when theres a new target
	function ENT:SetTarget(target)
		self.Target = target

		self:OnTargetSet(target)
	end

	--Gets the target
	function ENT:GetTarget()
		if not self.Target then
			return NULL
		else
			return self.Target
		end
	end

	--Simply makes sure the target is valid
	function ENT:CheckTargetValidity(target)
		if target == NULL or target == nil then return false end

		if target:IsValid() then
			if target:GetPos():Distance(self:GetPos()) > self:GetAwarenessRadius() then return false end

			return target:Health() > 0
		end

		return false
	end

	--Function for a global drop
	--Table is based in sv_globals, and the drops are either like holiday items or just something that anything should drop
	function ENT:DoGlobalDrop()
		local globaldrop = 0
		for _, item in pairs(NPC_GLOBALDROPTABLE) do
			if math.random(item.Chance) == 1 then
				globaldrop = globaldrop + 1

				local prop = ents.Create("item_"..item.Item)
				if prop:IsValid() then
					prop:SetPos(self:WorldSpaceCenter())
					prop:SetVelocity(Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(0, 1)) * 50)
					prop:SetItemCount(math.random(1, item.Amount))
					prop:Spawn()
				end

				local tab = {}
				if item.EditData then
					item.EditData(tab)
				end
				prop:SetData(tab)
			end

			if globaldrop >= NPC_GLOBALDROPTABLE_TOTALDROP then
				break
			end
		end
	end

	--Calls OnInjured2 which is in the specific entity file
	function ENT:OnInjured(cdmg)
		local pl = cdmg:GetAttacker()
		--Going to test this to see how it goes. Basically if the player is too far away, then just ignore the damage
		--This way people can't just snipe things outside of their range. See how it goes
		if pl:GetPos():Distance(self:GetPos()) > self:GetAwarenessRadius() then
			cdmg:SetDamage(0)
			return
		end

		if not self.Attackers[pl] then
			self.Attackers[pl] = cdmg:GetDamage()
		else
			self.Attackers[pl] = self.Attackers[pl] + cdmg:GetDamage()
		end

		self:OnInjured2(cdmg)
	end

	--Empty function for OnInjured2, should be created in the specific entity file
	function ENT:OnInjured2(cdmg)
	end

	function ENT:GetLargestDamager()
		local highestdamage = 0
		local pl = NULL
		for attacker, damage in pairs(self.Attackers) do
			if damage > highestdamage then
				highestdamage = damage
				pl = attacker
			end
		end

		return pl
	end

	--The table itself is created in Initialize2 which is in the specific entity file.
	function ENT:DoDropTable(tab)
		self.Drops = self.Drops or 1

		local droptab = tab or self.DropTable
		local drops = 0
		local items = {}
		for _, item in pairs(droptab) do
			if math.random(item.Chance) == 1 then
				drops = drops + 1

				local prop = ents.Create("item_"..item.Item)
					prop:SetPos(self:GetPos() + self:OBBCenter())
					prop:SetVelocity(Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(0, 1)) * 50)
					prop:Spawn()

				local itemtab = Item(item.Item)
				if item.EditData then
					item.EditData(itemtab)
				end

				itemtab:SetAmount(math.random(1, item.Amount))
				prop:SetData(itemtab)

				table.insert(items, itemtab)

				prop:SetTemporaryOwner(self:GetLargestDamager(), 10)
			end
		end

	--[[	if #items > 0 then
			local cont = ents.Create("prop_container")
				cont:SetPos(self:GetPos())
				cont:Spawn()


			for _, item in pairs(items) do
				cont:AddLocalItem(item)
			end
		end]]
	end

	--This distributes the karma to all the attackers
	function ENT:DoKarma()
		if self.Karma then
			local karmatogive = -(self.Karma + 2000) / 50
			for v, damage in pairs(self.Attackers) do
				if v:IsPlayer() then
					--print("Giving "..tostring(v).." "..karmatogive.." karma.")
					v:AddKarma(karmatogive, true, self.KarmaLimit)
				end
			end
		end
	end

	--This is the default function GetVarsToSave.
	--This makes sure that all npc's based off of this base will be saved by the global save system.'
	--Other npcs can obviously overwrite this, it is just to give a basic table of what needs to be saved
	function ENT:GetVarsToSave()
		local tab = {}
			tab.Health = self:Health()
	end

	--The other end of GetVarsToSave
	--Called when the server loads everything, this is the same table from GetVarsToSave
	--Loads all the values to the entity
	function ENT:SetVarsToLoad(tab)
		if tab.Health then
			self:SetHealth(tab.Health)
		end
	end
end

if CLIENT then
	function ENT:Initialize()
	end

	local function DrawText(tab, i, top)
		surface.SetFont("Xolonium48")
		local tw, th = surface.GetTextSize(tab.Text)

		draw.RoundedBox(8, tw * -0.5 - 10, -50 - 110 * (top - i), tw + 20, 100, Color(0, 0, 0, tab.Alpha))

		local col = Color(255, 255, 255)
		if tab.Color then
			col = tab.Color
		end
		col.a = tab.Alpha
		draw.SimpleText(tab.Text, "Xolonium48", 0,  -110 * (top - i), col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function ENT:Draw()
		self:DrawModel()
		self:HandleOverheadText()
	end

	function ENT:HandleOverheadText()
		local ang = EyeAngles()

		local alltext = self:GetOverheadText()
		if #alltext > 0 then
			local height = Vector(0, 0, self:OBBMaxs().z + 10)
			cam.Start3D2D(self:GetPos() + height, Angle(180, ang.y + 90, -90), 0.05)
				for i, tab in pairs(alltext) do
					local top = #alltext
					if top > 5 then
						top = 5
						if i > (top - 5 ) then
							DrawText(tab, i, top)
						end
					else
						DrawText(tab, i, top)
					end
				end
			cam.End3D2D()
		end
	end

	function ENT:Think()
		for i, tab in pairs(self:GetOverheadText()) do
			if tab.LifeTime < CurTime() then
				table.remove(self:GetOverheadText(), i)
				i = i - 1
			elseif tab.LifeTime <= CurTime() + 0.3 then
				tab.Alpha = math.max(tab.Alpha - 10, 0)
			end
		end
	end
end
