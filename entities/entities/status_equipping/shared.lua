ENT.Type = "anim"
ENT.Base = "status__base_noxrp"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "DieTime")
	self:NetworkVar("Int", 0, "ItemID")
end

function ENT:PreMove(pl, move)
--	if pl ~= self:GetOwner() then return end

	move:SetMaxSpeed(math.min(move:GetMaxSpeed(), 50))
	move:SetMaxClientSpeed(math.min(move:GetMaxSpeed(), 50))
end