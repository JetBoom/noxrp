AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.DurabilityUpdate = 0

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.25)
	
	self.BaseStats = {}
end

function SWEP:CallSkillCheck(pl, tr, dmginfo)
	if tr.Entity:IsValid() then
		if tr.Entity:IsPlayer() or tr.Entity.IsNextBot then
			local chance = math.random(pl:GetSkillChance(self.Skill))
			if chance == 1 then
				pl:AddSkill(self.Skill, 1)
			end
		end
	end
end

function SWEP:CheckOnCreatedBullet(bullet)
	for _, mods in pairs(self.Modifications) do
		local gitem = ITEMS[mods.Name]
		local item = self:GetOwner():GetItemByID(self:GetItemID())
		
		if gitem then
			if gitem.OnCreatedBullet then
				gitem:OnCreatedBullet(bullet)
			end
		end
	end
end