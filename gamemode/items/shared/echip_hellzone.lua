local ITEM = {}
ITEM.DataName = "echip_hellzone"
ITEM.Model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.Name = "Hellzone E-Chip"
ITEM.ItemWeight = 1
ITEM.Base = "echip__base"

function ITEM:OnWeaponUpdate(wep)
	wep.BulletClass = "projectile_firebullet"
end

function ITEM:WeaponStats()
	local tab = {
		{ENHANCEMENT_TYPE_DAMAGE, ENHANCEMENT_MULTIPLY, 0.6}
		}
	return tab
end

RegisterItem(ITEM)