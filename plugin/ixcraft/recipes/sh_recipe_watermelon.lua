
RECIPE.name = "Pastèque"
RECIPE.description = "Fabriquez une pastèque."
RECIPE.model = "models/props_junk/watermelon01.mdl"
RECIPE.category = "Pastèque"
RECIPE.requirements = {
	["water"] = 1
}
RECIPE.results = {
	["melon"] = 1
}
RECIPE.tools = {
	"cid"
}
RECIPE.flag = "V"

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "Vous devez être près d'un établi."
end)
