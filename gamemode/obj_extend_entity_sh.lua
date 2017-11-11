local meta = FindMetaTable("Entity")
if not meta then return end

function meta:IsDoor()
	return self:GetClass():find("door", 1, true) ~= nil
end

function meta:IsProjectile()
	return self:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE
end

--Mostly used for cooking containers that need to check temperature. Has a variety of implications, as meat can be cooked when getting the right temp.
--TODO: Get the heating system better coordinated
function meta:SetupDataTables()
	self:NetworkVar("Int", 0, "Temperature")
end

function meta:IsFacing(ent, accuracy, dir)
	accuracy = accuracy or 0.95
	local vec1 = dir or self:GetForward()
	local vec2 = (ent:GetPos() - self:GetPos()):GetNormalized()

	return vec1:Dot(vec2) >= accuracy
end

function meta:GetFacingAccuracy(ent, dir)
	accuracy = accuracy or 0.95
	local vec1 = dir or self:GetForward()
	local vec2 = (ent:GetPos() - self:GetPos()):GetNormalized()

	return vec1:Dot(vec2)
end

function meta:IsNextBot()
	return self.NextBot
end

function meta:TakeSpecialDamage(dmg, attacker, inflictor, dmgtype, dmgpos)
	local dmginfo = DamageInfo()
		dmginfo:SetDamage(dmg)
		dmginfo:SetAttacker(attacker)
		dmginfo:SetInflictor(inflictor)
		dmginfo:SetDamageType(dmgtype)
		dmginfo:SetDamagePosition(dmgpos)

	self:TakeDamageInfo(dmginfo)
end

function meta:ThrowFromPosition(pos, force, knockdown)
	if force == 0 then return end

	if self:GetMoveType() == MOVETYPE_VPHYSICS then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() and phys:IsMoveable() then
			local nearest = self:NearestPoint(pos)
			phys:ApplyForceOffset(force * 50 * (nearest - pos):GetNormalized(), nearest)
		end
	elseif self:GetMoveType() ~= MOVETYPE_NONE then
		self:SetGroundEntity(NULL)
		self:SetVelocity(force * (self:LocalToWorld(self:OBBCenter()) - pos):GetNormalized())
		if knockdown and self.KnockDown then
			self:KnockDown()
		end
	end
end

function meta:AddOverheadText(data)
	if not self:IsValid() then return end

	if not self.v_OverheadText then
		self.v_OverheadText = {}
	end

	local tab = {}

	if type(data) == "string" then
		tab.Text = data
		tab.LifeTime = CurTime() + 5
		tab.Alpha = 200
	elseif type(data) == "table" then
		tab.Text = data.Text
		tab.LifeTime = CurTime() + (data.LifeTime or 5)
		tab.Color = data.Color
		tab.Alpha = data.Alpha or 200
	end

	table.insert(self.v_OverheadText, tab)
end

function meta:GetOverheadText()
	if not self.v_OverheadText then
		self.v_OverheadText = {}
	end

	return self.v_OverheadText
end

function meta:GetVehicleParent()
	return self:GetDTEntity(0)
end

local nodamage = {damage = false, effects = true}
local function BulletCallback(attacker, tr, dmginfo) return nodamage end
local fakebullet = {Num = 1, Tracer = 0, Force = 0, Damage = 0, Spread = Vector(0, 0, 0), Callback = BulletCallback}
function meta:FakeBullet(src, dir)
	fakebullet.Src = src
	fakebullet.Dir = dir
	self:FireBullets(fakebullet)
end

------

function meta:GetItemByUIDOrDataName(argument)
	local itemid = tonumber(argument)
	return itemid and Items[itemid] or self:GetContainer():GetItemNonStrict(argument)
end

function meta:GetUsableItemByUIDOrDataName(argument)
	local item = self:GetItemByUIDOrDataName(argument)
	if item and item:IsUsableBy(self) then return item end
end

if SERVER then
	function meta:GetItem()
		return self.ItemData or Items[self:GetItemUID()]
	end

	function meta:SetItemUID(uid)
		self:SetDTInt(7, uid)
	end
end

if CLIENT then
	function meta:GetItem()
		return Items[self:GetItemUID()] or self.ItemData
	end

	function meta:SetItemUID(uid)
	end
end
meta.GetContainer = meta.GetItem

function meta:SetItem(item)
	self.ItemData = item
	if item then
		self:SetItemUID(item.ID)
	else
		self:SetItemUID(-1)
	end
end

function meta:GetItemUID()
	return self:GetDTInt(7)
end

meta.SetContainer = meta.SetItem

--[[function meta:AddGold(...)
	return self:AddItem("gold_coin", ...)
end
meta.GiveGold = meta.AddGold

function meta:RemoveGold(...)
	return self:RemoveItem("gold_coin", ...)
end
meta.TakeGold = meta.RemoveGold
meta.DestroyGold = meta.RemoveGold

function meta:HasGold(...)
	return self:HasItem("gold_coin", ...)
end

function meta:GetGold()
	return self:GetItemAmount("gold_coin")
end]]

function meta:AddItem(...)
	return self:GetContainer():AddItemNonStrict(...)
end
meta.GiveItem = meta.AddItem

function meta:RemoveItem(...)
	return self:GetContainer():RemoveItemNonStrict(...)
end
meta.TakeItem = meta.RemoveItem
meta.DestroyItem = meta.RemoveItem

function meta:HasItem(...)
	return self:GetContainer():HasItemNonStrict(...)
end

function meta:GetItemAmount(...)
	return self:GetContainer():GetItemAmountNonStrict(...)
end
meta.ItemAmount = meta.GetItemAmount

function meta:SetRemoving(removing)
	self.Removing = removing
end

function meta:GetRemoving()
	return self.Removing
end
meta.IsRemoving = meta.GetRemoving

meta.OldRemove = meta.Remove
function meta:Remove()
	self:SetRemoving(true)
	self:OldRemove()
end
