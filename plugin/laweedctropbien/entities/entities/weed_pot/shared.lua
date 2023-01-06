ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pot de weed"

ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "Stage")
end

