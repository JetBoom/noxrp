local meta = FindMetaTable("Player")
if not meta then return end

//This is for the client prediction of stamina
function meta:AddStamina(amt)
	self.c_Stamina = math.Clamp(self.c_Stamina + amt, 0, self:GetMaxStamina())
end


function meta:CLUseItemWith()
	local ply = LocalPlayer()
	
	if LocalPlayer().ent_Use then
		if LocalPlayer().ent_Use ~= self then
			RunConsoleCommand("noxrp_useworld", LocalPlayer().ent_Use:EntIndex(), self:EntIndex())
			LocalPlayer().ent_Use = nil
		else
			LocalPlayer().ent_Use = nil
			GAMEMODE:AddLocalNotification("You can't use this with itself!", 4)
		end
	else
		LocalPlayer().ent_Use = self
	end
end

function meta:AddWorldInteractionOptions(aimdir)
	AddWorldInteractionOption("Request a Trade", function() RunConsoleCommand("RequestTrade") end)
	
	if #LocalPlayer():GetParty().Members <= 3 then
		AddWorldInteractionOption("Invite to Party", function() RunConsoleCommand("noxrp_invitetoparty", aimdir.x, aimdir.y, aimdir.z) end)
	end
	
	AddWorldInteractionOption("Use Item With", function() self:CLUseItemWith() end)
end