local ITEM = {}
ITEM.DataName = "echip_pierce_less"
ITEM.Model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.Name = "Lesser Penetration E-Chip"
ITEM.ItemWeight = 1
ITEM.Base = "echip__base"

function ITEM:OnCreatedBullet(bullet)
	bullet.PiercingPower = bullet.PiercingPower + 20
end

function ITEM:WeaponStats()
	local tab = {}
	return tab
end

RegisterItem(ITEM)