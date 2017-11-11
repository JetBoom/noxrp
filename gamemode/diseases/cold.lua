local DISEASE = {}
DISEASE.DataName = "cold"
DISEASE.Base = "base"

if SERVER then
	function DISEASE:CreateTable()
		local tab = {}
			tab.Name = self.DataName
			tab.Duration = CurTime() + 360

		return tab
	end

	function DISEASE:OnContract(pl)
		pl:ChatPrint("You feel your nose running.")
	end

	function DISEASE:OnPlayerSay(pl, text)
	end

	function DISEASE:DiseaseThink(pl, disease)
		--if not pl.c_Disease_Cold_Time then pl.c_Disease_Cold_Time = 0 end
		if CurTime() >= (pl.ColdTime or 0) then
			pl.ColdTime = CurTime() + math.random(2, 3)

			pl:ViewPunch(Angle(math.Rand(-5, 5), math.Rand(-5, 5), 0))

			pl:EmitSound("ambient/voices/cough1.wav", 100, math.random(90, 110))
		end
	end

	function DISEASE:OnCured(pl)
		--pl.c_DiseaseResistances = pl.c_DiseaseResistances or {}
		--table.insert(pl.c_DiseaseResistances, "cold")

		pl:ChatPrint("You feel your cold has passed.")
	end
end

RegisterDisease(DISEASE)