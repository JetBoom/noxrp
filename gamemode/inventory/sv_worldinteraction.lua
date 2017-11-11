local meta = FindMetaTable("Player")
if not meta then return end

function PlayerCombineItemsWorld(pl, cmd, args)
	local ent1, ent2

	if args[1] then
		ent1 = Entity(tonumber(args[1]))
	end

	if args[2] then
		ent2 = Entity(tonumber(args[2]))
	end

	local data = {}
		data.start = ent1:GetPos()
		data.endpos = ent2:GetPos() + ent2:OBBCenter()
		data.filter = ent1

	local tr = util.TraceLine(data)
	if tr.Entity ~= ent2 then
		pl:SendNotification("There is something between the two items.")
		return
	end

	if pl:GetPos():Distance(ent1:GetPos()) > 1000 or pl:GetPos():Distance(ent2:GetPos()) > 1000 or ent1:GetPos():Distance(ent2:GetPos()) > 1000 then
		pl:SendNotification("Your too far to combine those two items.")
		return
	end

	if ent1 and ent2 then
		--print("we have two ents.", ent1.OnInteractWith)
		if ent1.OnInteractWith then
			ent1:OnInteractWith(pl, ent2)
		end

		if ent2.OnInteractedWith then
			ent2:OnInteractedWith(pl, ent1)
		end
	end
end
concommand.Add("noxrp_useworld", PlayerCombineItemsWorld)
