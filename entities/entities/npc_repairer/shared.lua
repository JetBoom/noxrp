ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.AutomaticFrameAdvance = true

ENT.Conversation = {
	[0] = {
		BuildText = function(pl) return "\"Do you need any items repaired?\"" end,
		
		BuildChoices = function(pl)
			if pl:GetStat(STAT_INTELLIGENCE) <= 5 then
				return {
				{CONVERSATION_POINT, 1, "Repair gun."},
				{CONVERSATION_POINT, 3, "Repair armor."},
				{CONVERSATION_POINT, -1, "No."}}
			else
				return {
				{CONVERSATION_POINT, 1, "Yes, repair my weapon please."},
				{CONVERSATION_POINT, 3, "Yes, repair my equipment please."},
				{CONVERSATION_POINT, -1, "No thanks."}}
			end
		end
	},
	[1] = {
		BuildText = function(pl)
			local wep = pl:GetActiveWeapon()
			if not wep:IsValid() or not pl:GetActiveWeapon().GetDurability then
				pl.ConversationVar = 1
				return "\"You don't even have a weapon!\""
			else
				local amt = math.Round((pl:GetActiveWeapon():GetMaxDurability() - pl:GetActiveWeapon():GetDurability()) * NPC_REPAIRRATE)
				if amt == 0 then
					pl.ConversationVar = 2
					return "\"Your weapon is already fully repaired!\""
				else
					pl.ConversationVar = 3
					return "\"It will cost you "..tostring(amt)..".\""
				end
			end
		end,
		BuildChoices = function(pl)
			if pl:GetStat(STAT_INTELLIGENCE) <= 5 then
				if pl.ConversationVar == 1 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, pl:Nick().." forgot."}}
				elseif pl.ConversationVar == 2 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, "I come back."}}
				elseif pl.ConversationVar == 3 then
					pl.ConversationVar = nil
					return {{CONVERSATION_POINT, 2, "Make shiny."}, 
						{CONVERSATION_POINT, -1, "Me need more money."}}
				end
			else
				if pl.ConversationVar == 1 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, "Uh, right."}}
				elseif pl.ConversationVar == 2 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, "Let me get another weapon."}}
				elseif pl.ConversationVar == 3 then
					pl.ConversationVar = nil
					return {{CONVERSATION_POINT, 2, "Repair it."}, 
						{CONVERSATION_POINT, -1, "It's too steep."}}
				end
			end
		end
	},
	[2] = {
		BuildText = function(pl)
			if pl:GetStat(STAT_INTELLIGENCE) <= 5 then
					pl:GetActiveWeapon():SetNewDurability(pl:GetActiveWeapon():GetMaxDurability() - 1)
					pl:GetActiveWeapon():SetMaxDurability(pl:GetActiveWeapon():GetMaxDurability() - 1)
					--pl:DestroyItemByName("money", price)
					
					pl:EmitSound("physics/metal/metal_canister_impact_hard3.wav")
					
					return "\"Uh, I made your weapon shiny.\""
			else
				--local price = math.Round((100 - pl:GetActiveWeapon():GetDurability()) * NPC_REPAIRRATE)
				--if pl:HasItem("money", price) then
					pl:GetActiveWeapon():SetNewDurability(pl:GetActiveWeapon():GetMaxDurability() - 1)
					pl:GetActiveWeapon():SetMaxDurability(pl:GetActiveWeapon():GetMaxDurability() - 1)
					--pl:DestroyItemByName("money", price)
					
					pl:EmitSound("physics/metal/metal_canister_impact_hard3.wav")
					
					return "\"Your weapon is as good as new.\""
			--	else
				--	return "\"You don't have enough to repair this!\""
			--	end
			end
		end,
		Choices = {
			{CONVERSATION_POINT, -1, "Thanks."}
		}
	},
	[3] = {
		BuildText = function(pl)
			local itemid = pl:GetEquipmentSlot(EQUIP_ARMOR_BODY)
			if itemid then
				local armor = pl:GetItemByID(itemid)
				
				local amt = math.Round((armor:GetData().MaxDurability - armor:GetData().Durability) * NPC_REPAIRRATE)
				if amt == 0 then
					pl.ConversationVar = 2
					return "\"Your armor is already fully repaired!\""
				else
					pl.ConversationVar = 3
					return "\"It will cost you "..tostring(amt)..".\""
				end
			else
				pl.ConversationVar = 1
				return "\"You don't even have armor!\""
			end
		end,
		BuildChoices = function(pl)
			if pl:GetStat(STAT_INTELLIGENCE) <= 5 then
				if pl.ConversationVar == 1 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, pl:Nick().." forgot."}}
				elseif pl.ConversationVar == 2 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, "I come back."}}
				elseif pl.ConversationVar == 3 then
					pl.ConversationVar = nil
					return {{CONVERSATION_POINT, 4, "Make shiny."}, 
						{CONVERSATION_POINT, -1, "Me need more money."}}
				end
			else
				if pl.ConversationVar == 1 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, "Uh, right."}}
				elseif pl.ConversationVar == 2 then
					pl.ConversationVar = nil
					
					return {{CONVERSATION_POINT, -1, "I'll come back."}}
				elseif pl.ConversationVar == 3 then
					pl.ConversationVar = nil
					return {{CONVERSATION_POINT, 4, "Repair it."}, 
						{CONVERSATION_POINT, -1, "It's too steep."}}
				end
			end
		end
	},
	[4] = {
		BuildText = function(pl)
			local itemid = pl:GetEquipmentSlot(EQUIP_ARMOR_BODY)
			if itemid then
				local armor = pl:GetItemByID(itemid)
				if pl:GetStat(STAT_INTELLIGENCE) <= 5 then
						armor:GetData().Durability = armor:GetData().MaxDurability - 1
						armor:GetData().MaxDurability = armor:GetData().MaxDurability - 1
						pl:UpdateInventoryItem(armor)
						--pl:DestroyItemByName("money", price)
						
						pl:EmitSound("physics/metal/metal_canister_impact_hard3.wav")
						
						return "\"Uh, I made your armor shiny.\""
				else
					--local price = math.Round((100 - pl:GetActiveWeapon():GetDurability()) * NPC_REPAIRRATE)
					--if pl:HasItem("money", price) then
						armor:GetData().Durability = armor:GetData().MaxDurability - 1
						armor:GetData().MaxDurability = armor:GetData().MaxDurability - 1
						pl:UpdateInventoryItem(armor)
						--pl:DestroyItemByName("money", price)
						
						pl:EmitSound("physics/metal/metal_canister_impact_hard3.wav")
						
						return "\"Your armor is as good as new.\""
				--	else
					--	return "\"You don't have enough to repair this!\""
				--	end
				end
			end
		end,
		Choices = {
			{CONVERSATION_POINT, -1, "Thanks."}
		}
	},
}