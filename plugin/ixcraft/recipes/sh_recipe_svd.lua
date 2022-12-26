
RECIPE.name = "Dragunov SVD"
RECIPE.description = "Fabriquez un SVD."
RECIPE.model = "models/weapons3/w_stalker_svd.mdl"
RECIPE.category = "ARMES"
RECIPE.requirements = {
	["compenant"] = 6
}
RECIPE.results = {
	["svd"] = 1
}
RECIPE.tools = {
	"toolsbasic"
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
