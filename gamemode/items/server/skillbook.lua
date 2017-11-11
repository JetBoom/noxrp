local ITEM = {}
ITEM.DataName = "skillbook"

function ITEM:ItemUse(pl, id)
	if item.Skill and item.SkillAmount then
		pl:AddSkill(item.Skill, item.SkillAmount)
		return true
	end

	return false
end

RegisterItem(ITEM)