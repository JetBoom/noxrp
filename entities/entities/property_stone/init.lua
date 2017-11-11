AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/gravestone001a.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	self.NextUse = 0
end

function ENT:SetInfo(tab)
	self.Property = tab
	
	self:SetPropertyOwner(tab.Owner)
	self:SetPropertyName(tab.Name)
	self:SetPrice(tab.Price)
	self:SetDecayTime(tab.DecayTime)
end

function ENT:Use(pl)
	self:UseProperty(pl)
end

function ENT:UseProperty(pl, dontopen)
	if CurTime() < self.NextUse then return end

	if self:GetPropertyOwner() == "Nobody" then
			local numproperties = 0
			for _, property in pairs(PROPERTIES) do
				if property.Owner == pl:UniqueID() then numproperties = numproperties + 1 end
			end
			
			if pl:HasItem("money", self:GetPrice()) then
				if numproperties < 1 then
					pl:PrintMessage(3, "You have bought the property. You can now lock all doors within the property by holding right click and using them.")
					pl:PrintMessage(3, "You can lock items down by saying 'i wish to lock this down' and release them with 'i wish to release this'")
					pl:PrintMessage(3, "Make sure you refresh your property by using a door or the sign atleast once a week or it will be disowned!")
					self:SetPropertyOwner(pl:SteamID64())
					self.Property.Owner = pl:SteamID64()
					
					pl:DestroyItemByName("money", self:GetPrice())
					
					noxrp.SaveMapFile()
				else
					pl:PrintMessage(4, "You own too many properties to buy this.")
				end
			else
				pl:SendNotification("You need more money to buy this.", 4, Color(255, 150, 150))
				
				pl:SendNotification("This is a property. If you buy one, you can lock items down in it.", 10, Color(100, 150, 255), "buttons/button14.wav", 1)
				pl:SendNotification("Properties can act as a house or a store, whichever you set it up as.", 10, Color(100, 150, 255), nil, 1)
			end
	elseif pl:IsOwner(self.Property) then
		if self:GetDecayTime() > 0 then
			local tax = math.floor((self:GetDecayTime() / PROPERTY_DECAYTIME) * (self:GetDecayTime() * 0.1))
			
			if tax > 1 then
				if pl:HasItem("money", tax) then
					pl:DestroyItemByName("money", tax)
					self:RefreshProp(pl)
				else
					pl:SendNotification("You need more money to pay the refresh tax.", 10, Color(255, 150, 150), "buttons/button14.wav", 1)
					return
				end
			else
				self:RefreshProp(pl)
			end
		end
	else
		self.NextUse = CurTime() + 0.5
		pl:SendNotification("This property doesn't belong to you.")
	end
end

function ENT:RefreshProp(pl)
	self.NextUse = CurTime() + 1.25
	self.Property.DecayTime = 0
	self:SetDecayTime(0)

	pl:SendNotification("Welcome back.")
	pl:SendNotification("Your property and it's contents have been refreshed.")
end

function ENT:Think()
end

function ENT:Touch(ent)
end

function ENT:PhysicsCollide(data, physobj)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
