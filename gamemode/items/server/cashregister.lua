local ITEM = {}
ITEM.DataName = "cashregister"

function ITEM:PostSetData()
	self.Data.Data.Money = self.Data.Data.Money or 0
	self.Data.Data.Access = self.Data.Data.Access or 0
end

function ITEM:OnUseLocked(pl)
	if not pl.EntityChatInput then
		if self.Data.Data.Access == 0 and pl:IsOwner(PROPERTIES[self.PropertyID]) or (self.Data.Data.Access == 1 and (pl:IsOwner(PROPERTIES[self.PropertyID]) or pl:IsCoowner(PROPERTIES[self.PropertyID]))) or (self.Data.Data.Access == 2 and (pl:IsOwner(PROPERTIES[self.PropertyID]) or pl:IsCoowner(PROPERTIES[self.PropertyID]) or pl:IsFriend(PROPERTIES[self.PropertyID]))) then
			pl.EntityChatInput = self

			pl:SendNotification("What would you like to do:")
			pl:SendNotification("deposit <amount>")
			pl:SendNotification("withdraw <amount>")
			pl:SendNotification("check")
			if pl:IsOwner(PROPERTIES[self.PropertyID]) then
				pl:SendNotification("setaccess")
			end
		else
			pl:SendNotification("You do not have access to this cash register.")
		end
	end
end

function ITEM:EntityChatInput(pl, input)
	if string.Left(input, 7) == "deposit" then
		local amt = tonumber(string.sub(input, 9))

		if amt then
			if amt > 0 then
				if pl:HasItem("money", amt) then
					self.Data:GetData().Money = self.Data:GetData().Money + amt

					pl:DestroyItemByName("money", amt)

					pl:SendNotification("You deposited "..amt..".")
					self.InputType = nil
					pl.EntityChatInput = nil
				else
					pl:SendNotification("You don't have that much!")
					self.InputType = nil
					pl.EntityChatInput = nil
				end
			else
				pl:SendNotification("Invalid amount.")
				self.InputType = nil
				pl.EntityChatInput = nil
			end
		else
			pl:SendNotification("You need to put in a number.")
			self.InputType = nil
			pl.EntityChatInput = nil
		end
	elseif string.Left(input, 8) == "withdraw" then
		local amt = tonumber(string.sub(input, 10))

		if amt then
			if self.Data.Data.Money >= amt then
				self.Data.Data.Money = self.Data.Data.Money - amt

				local tab = Item("money")
				tab:SetAmount(amt)

				pl:InventoryAdd(tab)

				pl:SendNotification("You withdrew "..amt..".")
				self.InputType = nil
				pl.EntityChatInput = nil
			else
				local tab = Item("money")
				tab:SetAmount(self.Data.Data.Money)

				pl:InventoryAdd(tab)

				pl:SendNotification("There was only "..self.Data.Data.Money.." to withdraw.")
				self.InputType = nil
				pl.EntityChatInput = nil
			end
		else
			pl:SendNotification("Invalid amount.")

			self.InputType = nil
			pl.EntityChatInput = nil
		end
	elseif input == "check" then
		pl:SendNotification("There is currently "..self.Data.Data.Money.." inside.")
		local access
		if self.Data.Data.Access == 0 then
			access = "owners"
		elseif self.Data.Data.Access == 1 then
			access = "co-owners"
		elseif self.Data.Data.Access == 2 then
			access = "friends"
		end
		pl:SendNotification("Access is currently set to "..access..".")

		self.InputType = nil
		pl.EntityChatInput = nil
	elseif input == "setaccess" then
		if pl:IsOwner(PROPERTIES[self.PropertyID]) then
			self.SettingAccess = true

			pl:SendNotification("What would you like to set access to?")
			pl:SendNotification("owner")
			pl:SendNotification("coowner")
			pl:SendNotification("friend")
		end
	elseif self.SettingAccess then
		if input == "owner" then
			self.Data.Data.Access = 0
			pl:SendNotification("Access is now set to owner.")
		elseif input == "coowner" then
			self.Data.Data.Access = 1

			pl:SendNotification("Access is now set to co-owners.")
		elseif input == "friend" then
			self.Data.Data.Access = 2
			pl:SendNotification("Access is now set to friends.")
		else
			pl:SendNotification("Unknown option.")
		end

		self.SettingAccess = false
		pl.EntityChatInput = nil
	else
		pl:SendNotification("Unknown option.")
		self.InputType = nil
		pl.EntityChatInput = nil
	end
end

RegisterItem(ITEM)