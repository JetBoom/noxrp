ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "BaseItem")
	self:NetworkVar("String", 1, "DisplayName")

	self:NetworkVar("Vector", 0, "DisplayColor")

	self:NetworkVar("Int", 0, "Temperature")
	self:NetworkVar("Int", 1, "ItemCount")
	self:NetworkVar("Int", 2, "SellPrice")

	self:NetworkVar("Bool", 0, "LockedDown")
	self:NetworkVar("Bool", 1, "DisplayColorEnabled")

	self:NetworkVar("Entity", 0, "TemporaryOwner")

	self:NetworkVar("Float", 0, "TemporaryOwnedTime")

	if self.SetupExtraDataTables then
		self:SetupExtraDataTables()
	end
end

function ENT:SetupExtraDataTables()
end

function ENT:GetItemName()
	local name
	if self.GetDisplayName then
		name = self:GetDisplayName() or self.Data.Name or self.Name
	else
		name = self.Data.Name or self.Name
	end

	return name
end