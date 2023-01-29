local PLUGIN = PLUGIN

PLUGIN.name = "Première personne immersive"
PLUGIN.description = "vous permet de visualiser votre corps entier et votre tête."
PLUGIN.author = ""
PLUGIN.schema = "Any"
PLUGIN.license = [[
cope
]]

ix.option.Add("FirstPersonEnable", ix.type.bool, false, {
    category = "Première personne",
    phrase = "Première personne activée"
})

ix.option.Add("FullBody", ix.type.bool, false, {
    category = "Première personne",
    phrase = "Corps complet"
})

function PLUGIN:CalcView(ply, origin, angles, fov)
    local view = {
        origin = origin,
        angles = angles,
        fov = 90,
        drawviewer = true
    }
    local head = ply:LookupAttachment("eyes")
    head = ply:GetAttachment(head)
    if not head or not head.Pos then return end
    if IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu) then return end
    if not ix.option.Get("FirstPersonEnable", false) then return end
    if (ply:GetMoveType() == MOVETYPE_NOCLIP) then return end

    if not ply.BonesRattled then
        ply.BonesRattled = true

        ply:InvalidateBoneCache()
        ply:SetupBones()

        local matrix

        for bone = 0, (ply:GetBoneCount() or 1) do
            if ply:GetBoneName(bone):lower():find("head") then
                matrix = ply:GetBoneMatrix(bone)
                break
            end
        end

        if IsValid(matrix) then
            matrix:SetScale(Vector(0, 0, 0))
        end
    end

    view.origin = head.Pos + head.Ang:Up()
    if ix.option.Get("FullBody", false) then
        view.angles = head.Ang
    else
        view.angles = Angle(head.Ang.p, head.Ang.y, angles.r)
    end

    return view
end
