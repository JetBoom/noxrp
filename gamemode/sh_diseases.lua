DISEASES = {}

function RegisterDisease(DISEASE)
	local info2 = DISEASE
	if info2.Base then
		if DISEASES[info2.Base] then
			local tab = DISEASES[info2.Base]
			
			for k, v in pairs(tab) do
				if info2[k] == nil then
					info2[k] = v
				end
			end

			if info2.IsBase then info2.IsBase = nil end
		end
	end

	if DISEASES[info2.DataName] == nil then
		DISEASES[info2.DataName] = info2
	else
		local tab = DISEASES[DISEASES.DataName]
			
		for k, v in pairs(info2) do
			if DISEASES[DISEASES.DataName][k] == nil then
				DISEASES[DISEASES.DataName][k] = v
			end
		end
	end
end

local dataitems = file.Find("gamemodes/noxrp/gamemode/diseases/*.lua", "GAME")
for k,v in pairs(dataitems) do
	if SERVER then AddCSLuaFile( "diseases/"..v ) end
end

include("diseases/base.lua")
include("diseases/autism.lua")
include("diseases/cold.lua")
include("diseases/gbs.lua")