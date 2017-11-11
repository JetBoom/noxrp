local DISEASE = {}
DISEASE.DataName = "gbs"
DISEASE.Base = "base"
DISEASE.DeathCures = true

if SERVER then
	function DISEASE:CreateTable()
		local tab = {}
			tab.Name = self.DataName
			tab.Duration = CurTime() + 30
			tab.GBSTime = 0
			tab.GBSEffect = 0
		
		return tab
	end
	
	function DISEASE:OnContract(pl)
	end

	function DISEASE:OnPlayerSay(pl, text)
	end
	
	function DISEASE:DiseaseThink(pl, disease)
		if not disease.GBSTime then disease.GBSTime = 0 end
		
		if disease.GBSTime < CurTime() then
			disease.GBSTime = CurTime() + math.random(4, 5)
			if not pl.c_Disease_GBS_Effect then pl.c_Disease_GBS_Effect = 0 end
			
			disease.GBSEffect = disease.GBSEffect + 1
			
			pl:EmitSound("ambient/voices/cough1.wav", 100, math.random(90, 110))
			
			if disease.GBSEffect == 1 then
				pl:ChatPrint("You feel yourself aching all over.")
			elseif disease.GBSEffect == 2 then
				pl:ChatPrint("You're starting to feel very weak...")
			elseif disease.GBSEffect == 3 then
				pl:ChatPrint("Your body feels as if it's trying to rip itself open...")
			elseif disease.GBSEffect == 4 then
				pl:TakeDamage(400)
			end
		end
	end
	
	function DISEASE:OnCured(pl)
	--	table.insert(pl.c_DiseaseResistances, "cold")
	end
end

if CLIENT then
end

RegisterDisease(DISEASE)