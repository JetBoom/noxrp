local ITEM = {}
ITEM.DataName = "echip_slug"
ITEM.Model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.Name = "Slug E-Chip"
ITEM.ItemWeight = 1
ITEM.Base = "echip__base"

function ITEM:OnCreatedBullet(bullet)
	bullet.PiercingPower = bullet.PiercingPower + 200
end

function ITEM:CanApplyToWeapon(weapon)
	if string.find(weapon.Weapon, "shotgun") then return true end
	return false
end

function ITEM:WeaponStats()
	local tab = {
		{ENHANCEMENT_TYPE_DAMAGE, ENHANCEMENT_MULTIPLY, 1.5},
		{ENHANCEMENT_TYPE_CLIPSIZE, ENHANCEMENT_MULTIPLY, 0.5},
		{ENHANCEMENT_TYPE_BULLETS, ENHANCEMENT_MULTIPLY, 0.01},
		{ENHANCEMENT_TYPE_ACCURACY, ENHANCEMENT_MULTIPLY, 0.25},
		}
	return tab
end

RegisterItem(ITEM)