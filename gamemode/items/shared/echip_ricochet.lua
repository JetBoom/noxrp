local ITEM = {}
ITEM.DataName = "echip_rico"
ITEM.Model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.Name = "Ricochet E-Chip"
ITEM.ItemWeight = 1
ITEM.Base = "echip__base"
ITEM.Usable = true
ITEM.DestroyOnUse = true

function ITEM:OnWeaponUpdate(wep)
	wep.Primary.Automatic = true
end

function ITEM:WeaponStats()
	local tab = {
		{ENHANCEMENT_TYPE_FIRERATE, ENHANCEMENT_MULTIPLY, 0.8}
		}
	return tab
end

function ITEM:OnCreatedBullet(bullet)
	bullet.MaximumBounces = bullet.MaximumBounces + 1
end

RegisterItem(ITEM)