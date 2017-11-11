local DISEASE = {}
DISEASE.DataName = "autism"
DISEASE.Base = "base"

if SERVER then
	function DISEASE:OnContract(pl)
	end

	function DISEASE:CreateTable()
		local tab = {}
			tab.Name = self.DataName

		return tab
	end

	local autisms = {
		"dank memes guys",
		"guys I'm autistic fyi",
		"you should kill me",
		"anyone got some rare pepes",
		"anyone want a waifu pillow",
		"whats your favorite waifu"
	}
	function DISEASE:OnPlayerSay(pl, text)
		if math.random(3) == 1 then
			return autisms[math.random(#autisms)]
		end
	end

	function DISEASE:DiseaseThink(pl)
	end

	function DISEASE:OnCured(pl)
	end
end

if CLIENT then
end

RegisterDisease(DISEASE)