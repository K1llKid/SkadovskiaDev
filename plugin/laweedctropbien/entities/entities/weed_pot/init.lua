
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/the_weed/the_weed_pot.mdl") -- model du pot
	self:SetStage(0)
	self:PhysicsInit(SOLID_VPHYSICS) -- dumb shit
	self:SetMoveType(MOVETYPE_VPHYSICS) -- dumb shit
	self:SetSolid(SOLID_VPHYSICS) -- dumb shit

	local phy = self:GetPhysicsObject()

	if phy:IsValid() then

		phy:Wake()

	end

end



function ENT:Use( activator , caller , SIMPLE_USE )
	local char = activator:GetCharacter()
	local inventory = char:GetInventory()
	local curTime = CurTime()
	if inventory:HasItem("dirt") then
	if self:GetStage() == 0 then
	self:SetModel("models/the_weed/the_weed_potdirt.mdl")
	else
    if (self.nextDelay or 0) > curTime then return end
    self.nextDelay = curTime + 5

    activator:ChatNotify("Tu as besoin de terre")
end
	local GetInv = inventory
	if (GetInv:HasItem("dirt")) then
	if (self.nextDelay or 0) > curTime then return end
    self.nextDelay = curTime + 5
    GetInv:HasItem("dirt"):Remove()
	self:Growing()
	end
	end
	end
	
function ENT:Growing()
	self:SetStage(1)
	self:SetModel("models/the_weed/the_weed_potdirt.mdl")
	timer.Create("WeedPlant" .. self:EntIndex(), growtime, 0, function()
		if self:GetStage() == 7 then
			timer.Remove("WeedPlant" .. self:EntIndex())
			self:SetStage(0)
			self:SetModel("models/the_weed/the_weed_pot.mdl")
			ix.item.Spawn("weed", self:GetPos() + Vector(0, 0, 20))
		else
			self:SetModel("models/the_weed/the_weed_growing0"..self:GetStage()..".mdl")
			self:SetStage(self:GetStage() + 1)
			self:EmitSound("physics/cardboard/cardboard_box_impact_bullet3.wav")
		end
		end)
		end

-- ne pas juger l'indentation merci :c <3