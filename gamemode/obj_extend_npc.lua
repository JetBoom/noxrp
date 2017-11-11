local meta = FindMetaTable("NPC")
if not meta then return end

function meta:GetAttackers()
	self.Attackers = self.Attackers or {}
	return self.Attackers
end

if SERVER then
	function meta:AddAttacker(attacker)
		self:GetAttackers()[attacker] = CurTime()
	end
end