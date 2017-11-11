AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Think()
	if CurTime() >= self:GetDTFloat(0) then
		self:EquipPlayer()
		self:Remove()
	end

	self:NextThink(CurTime())
	return true
end

function ENT:EquipPlayer()
	local owner = self:GetOwner()
	if self.Type == 1 then
		local item = self.Item
		local wepinfo = weapons.Get(item.Weapon)

		for k, v in pairs(owner:GetWeapons()) do
			if v:GetClass() == "weapon_melee_fists" then
					owner:StripWeapon(v:GetClass())
			else
				if v:GetIDTag() == item:GetIDRef() then
					if v:CanHolster() then
						if v.HeatLevel then
							if v:HeatLevel() > 0 then
								return
							end
						elseif v.Primary.ClipSize then
							item:GetData().Clip1 = v:Clip1()
						end
						owner:StripWeapon(v.ClassName)
					end

					owner:RecalcMoveSpeed()
					self:Remove()
					return
				elseif v.ClassName == item.Weapon or v.Slot == wepinfo.Slot then
					if v.HeatLevel then
						if v:HeatLevel() > 0 then
							self:Remove()
							return
						end
					else
						for _, plitem in pairs(owner:GetInventory()) do
							if v:GetIDTag() == plitem:GetIDRef() then
								plitem:GetData().Clip1 = v:Clip1()
							end
						end
					end
					owner:StripWeapon(v.ClassName)
				end
			end
		end

		SetupEquipPlayer(owner, item)
	elseif self.Type == 2 then
		owner:SetEquipment(self.Category, self.Item)
	end
end

function ENT:OnRemove()
end
