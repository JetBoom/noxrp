local ITEM = {}
ITEM.DataName = "blueprint"

function ITEM:ItemUse(pl, id)
	if id:GetData().Blueprint then
		local data = {}
			data.start = pl:GetShootPos()
			data.endpos = data.start + pl:GetAimVector() * 200
			data.filter = pl

		local tr = util.TraceLine(data)
		if tr.HitWorld then
			local bp = ents.Create("blueprint")
			if bp then
				bp:SetPos(tr.HitPos)
				bp:Spawn()
				bp:SetBlueprint(id:GetData().Blueprint)
				return true
			else
				return false
			end
		else
			return false
		end
	end
end

function ITEM:PostSetData()
	if self.Data.Blueprint then
		local bp = BLUEPRINTS[self.Data.Blueprint]
		self:SetDisplayName("Recipe ["..bp.Name.."]")
	end
end

RegisterItem(ITEM)