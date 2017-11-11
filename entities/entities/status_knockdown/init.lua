AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.KnockedDown = self
	pPlayer:Freeze(true)

	pPlayer:DrawWorldModel(false)
	pPlayer:DrawViewModel(false)
	
	if pPlayer:GetStatus("forcedrink") then
		local stat = pPlayer:GetStatus("forcedrink")
		stat.OnlyRemove = true
		stat:Remove()
	end

	if not bExists then
		pPlayer:CreateRagdoll()
	end
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent:Freeze(false)
		parent.KnockedDown = nil

		if parent:Alive() then
			parent:DrawViewModel(true)
			parent:DrawWorldModel(true)

			local rag = parent:GetRagdollEntity()
			if rag and rag:IsValid() then
				rag:Remove()
			end
		end
	end
end
