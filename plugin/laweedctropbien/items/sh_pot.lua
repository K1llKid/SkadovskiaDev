ITEM.name = "Pot"
ITEM.model = Model("models/the_weed/the_weed_pot.mdl")
ITEM.description = "Un pot en céramique pour planter certaines plantes."

ITEM.functions.Place = {
    OnRun = function(itemTable)
	local client = itemTable.player
local ply = client 
local tr = ply:GetEyeTrace() 
local ent = ents.Create("weed_pot")
ent:SetPos(tr.HitPos)
ent:Spawn()
ply:ChatNotify("Tu as placé un pot.")
end
}