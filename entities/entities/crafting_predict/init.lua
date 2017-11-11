AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:EnableMotion(false)
	end
end

function ENT:OnKeyPress(key)
	if self.CraftingGame == MINIGAME_DDR then
		if key == IN_FORWARD or key == IN_BACK or key == IN_MOVELEFT or key == IN_MOVERIGHT then
			if self.CraftingKeys[1].Posx <= 40 and self.CraftingKeys[1].Posx >= -40 then
				if self.CraftingKeys[1].Key == key then
					table.remove(self.CraftingKeys, 1)

					net.Start("craftKeySuccessDDR")
						net.WriteTable(self.CraftingKeys)
					net.Send(self.Player)
				else
					self:CraftFailure()
				end
			else
				self:CraftFailure()
			end
		end
	end
end

function ENT:SetRecipe(recipe, id)
	self.Recipe = recipe
	self.Skill = recipe.Skill
	self.Difficulty = recipe.Difficulty

	if recipe.CraftingGame then
		self.CraftingGame = recipe.CraftingGame
	else
		self.CraftingGame = MINIGAME_DDR
	end

	if self.CraftingGame == MINIGAME_DDR then
	end
end

function ENT:SetPlayer(pl)
	self.Player = pl
	self:SetOwner(pl)
end

function ENT:CraftingBegin()
	if not self.Difficulty or not self.Player then self:Remove() return end

	if self.CraftingGame == MINIGAME_DDR then
		self:StartCrafting()
	end
end

function ENT:CraftSuccess()
	if self.CraftingGame == MINIGAME_DDR then
		net.Start("craftEndDDR")
			net.WriteBit(1)
		net.Send(self.Player)
	end

	-- Skill: 0, Diff: 50, Points = 2
	-- Skill: 50, Diff: 50, Points = 1

	-- Skill: 0, Diff: 250, Points = 4

	-- Skill: 0, Diff: 1000, Points = 5

	local rate = self.Player:GetSkill(self.Skill) / self.Difficulty
	local points = 0

	if self.Difficulty <= 50 then
		points = math.max(math.ceil(2 * (1 - rate)), 0)
	elseif self.Difficulty <= 100 then
		points = math.max(math.ceil(3 * (1 - rate)), 0)
	elseif self.Difficulty <= 250 then
		points = math.max(math.ceil(4 * (1 - rate)), 0)
	elseif self.Difficulty <= 1000 then
		points = math.max(math.ceil(5 * (1 - rate)), 0)
	end

	RecipeSuccess(self.Player, self, self.Recipe, self.Amount, points)

	self.Player.IsCrafting = nil
	self:Remove()
end

function ENT:CraftFailure()
	--self.Player:EmitSound("vo/k_lab/kl_fiddlesticks.wav")

	if self.CraftingGame == MINIGAME_DDR then
		net.Start("craftEndDDR")
			net.WriteBit(0)
		net.Send(self.Player)
	end

	RecipeFailure(self.Player, self.Recipe, 1)

	self.Player.IsCrafting = nil
	self:Remove()
end

function ENT:Think()
	if self.CraftingGame == MINIGAME_DDR then
		self:ThinkDDR()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:ThinkDDR()
	if self.BeginCraft < CurTime() then
		if #self.CraftingKeys > 0 then
			if self.CraftingKeys[1].Posx <= -40 then
				self:CraftFailure()
			end

			for _, key in pairs(self.CraftingKeys) do
				key.Posx = key.Posx - key.MoveSpeed * FrameTime()
			end

			if self.Player:KeyDown(IN_JUMP) then
				self:CraftFailure()
			end


			net.Start("craftKeyUpdateDDR")
				net.WriteFloat(self.CraftingKeys[1].Posx)
			net.Send(self.Player)
		else
			self:CraftSuccess()
		end
	end
end

function ENT:StartCrafting()
	self.CraftingKeys = {}
	self.NextMove = CurTime()

	self.BeginCraft = CurTime() + 1
	self.NextUpdate = CurTime() + 1.2

	local skill = self.Player:GetSkill(self.Recipe.Skill)

	for i = 0, math.ceil(self.Recipe.Difficulty * 0.1) do
		local key = math.random(1, 4)
		local tab = {}
		tab.MoveSpeed = 120 + math.max(self.Recipe.Difficulty * 0.001 - skill * 0.001, 0) * 100
		tab.MoveDistance = 50
		tab.MoveTime = 0.02

		tab.Posx = 100 + tab.MoveDistance * (i + 1)

		if key == 1 then
			tab.Key = IN_FORWARD
		elseif key == 2 then
			tab.Key = IN_MOVERIGHT
		elseif key == 3 then
			tab.Key = IN_BACK
		else
			tab.Key = IN_MOVELEFT
		end

		table.insert(self.CraftingKeys, tab)
	end

	net.Start("craftBeginDDR")
		net.WriteTable(self.CraftingKeys)
		net.WriteFloat(self.BeginCraft)
	net.Send(self.Player)
end

function ENT:OnRemove()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
