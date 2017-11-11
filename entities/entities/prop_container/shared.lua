ENT.Type = "anim"

function ENT:GetDieTime()
	return self:GetDTFloat(0)
end

function ENT:SetDieTime(dtime)
	self:SetDTFloat(0, dtime)
end

function ENT:AddOpener(pl)
	table.insert(self.Openers, pl)
end

function ENT:RemoveOpener(pl)
	for index, play in pairs(self.Openers) do
		if play == pl then
			table.remove(self.Openers, index)
		end
	end
end

function ENT:GetOpenedBy()
	return self.Openers
end