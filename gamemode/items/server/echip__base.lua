local ITEM = {}
ITEM.DataName = "echip__base"

function ITEM:CanApplyToWeapon(weapon)
	return true
end

function ITEM:ApplyEChip(pl, weapon, item, slot)
	if slot then
		if weapons.Get(GetGlobalItem(weapon:GetDataName()).Weapon).WeaponType == WEAPON_TYPE_GUN then
			local gitem = ITEMS[weapon:GetDataName()]
			if gitem.RestrictedChips then
				if table.HasValue(gitem.RestrictedChips, self.DataName) then
					pl:SendNotification("You cannot equip that chip onto that weapon.")
					return false
				end
			end
					
			if not self:CanApplyToWeapon(gitem) then
				pl:SendNotification("You cannot equip that chip onto that weapon.")
				return false
			end
					
			if not weapon:GetData().Slots then
				weapon:GetData().Slots = {}
			end
						
			if weapon:GetData().Slots[slot] then
				local tab = Item(weapon:GetData().Slots[slot].Name)
							
				pl:InventoryAdd(tab)
			end
						
			local tab2 = {}
				tab2.Name = item:GetDataName()
			weapon.Data.Slots[slot] = tab2
						
			pl:DestroyItem(item:GetIDRef())
				
			local activewep = pl:GetWeaponFromID(weapon:GetIDRef())
			if activewep then activewep:UpdateEnhancements() end
					
			pl:EmitSound("npc/sniper/reload1.wav")
		end
	end
end

RegisterItem(ITEM)