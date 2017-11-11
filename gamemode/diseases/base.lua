local DISEASE = {}
DISEASE.DataName = "base"

if SERVER then
	function DISEASE:CreateTable()
		local tab = {}
			tab.Name = self.DataName
			tab.Duration = CurTime() + 5
		
		return tab
	end
	
	function DISEASE:OnContract(pl)
	end
	
	function DISEASE:OnPlayerSay(pl, text)
	end
	
	function DISEASE:DiseaseThink(pl)
	end
	
	function DISEASE:OnCured(pl)
	end
end

if CLIENT then
end

RegisterDisease(DISEASE)