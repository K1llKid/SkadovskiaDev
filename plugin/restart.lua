local PLUGIN = PLUGIN
PLUGIN.name = "Redémarrage"
PLUGIN.author = "A3R1S"
PLUGIN.desc = "restart le serveur à un temps modifiable"

PLUGIN.NextRestart = 0
PLUGIN.NextNotificationTime = 0
PLUGIN.IsRestarting = false

-- En minutes
PLUGIN.TimeRemainingTable = {
    30,
    15,
    5,
    1,
    0
}

ix.config.Add("serverRestartHour", 6, "A quelle heure le serveur doit redémarrer, en fonction du fuseau horaire.", function()
    if (SERVER) then
        timer.Simple(0.01, function()
            PLUGIN.NextRestart = PLUGIN:GetInitialRestartTime()
            PLUGIN.NextNotificationTime = PLUGIN:GetNextNotificationTimeBreakpoint()
        end)
    end
end, {
    data = {
        min = 0,
        max = 23
    },
    category = "Restart"
})

function PLUGIN:GetTimeToRestart()
    local time = os.time()
    time = self.NextRestart - time
    
    return time
end

function PLUGIN:NotifyServerRestart(client, timeRemaining)
    local timeRemainingMinutes = math.Round(timeRemaining / 60)

    client:Notify("Le serveur redémarre dans "..timeRemainingMinutes.." minutes!")
end

if (SERVER) then
    -- Si nous sommes sur le point de redémarrer, faites-le savoir au client.
    function PLUGIN:CharacterLoaded(character)
        timer.Simple(0, function()
            local timeRemaining = self:GetTimeToRestart()
            local timeRemainingInMinutes = timeRemaining / 60
            
            if (timeRemainingInMinutes < self.TimeRemainingTable[1]) then
                self:NotifyServerRestart(character:GetPlayer(), self:GetTimeToRestart())
            end
        end)
    end

    function PLUGIN:GetInitialRestartTime()
        local temp = os.date("*t")
        local timeNowStruct

        if (temp.hour >= ix.config.Get("serverRestartHour")) then
            timeNowStruct = os.date("*t", os.time() + (24 * 60 * 60)) 
        else
            timeNowStruct = os.date("*t")
        end
        timeNowStruct.hour = ix.config.Get("serverRestartHour") -- redémarrage à l'heure indiquée dans la configuration
        timeNowStruct.min = 0 
        timeNowStruct.sec = 0 
        local timestamp = os.time(timeNowStruct)
        
        return timestamp
    end

    function PLUGIN:GetInitialNotificationTime()
        local nextBreakpoint = self:GetNextNotificationTimeBreakpoint()
        return self.NextRestart - nextBreakpoint
    end

    function PLUGIN:GetNextNotificationTimeBreakpoint()
        local timeMinutes = self:GetTimeToRestart() / 60
        
        for i = 1, #self.TimeRemainingTable do
            if (timeMinutes >= self.TimeRemainingTable[i]) then
                
                return self.TimeRemainingTable[i] * 60
            end
        end
    end

    function PLUGIN:Think()
        if (self.IsRestarting == true) then
            return
        end

        if (self.NextRestart == 0) then
            self.NextRestart = self:GetInitialRestartTime()
            self.NextNotificationTime = self:GetInitialNotificationTime()
            return
        end

        local time = os.time()
        if (time > self.NextNotificationTime or time > self.NextRestart) then
            local nextBreakpoint = self:GetNextNotificationTimeBreakpoint()

            if (!nextBreakpoint) then
                self.IsRestarting = true
                RunConsoleCommand("changelevel", game.GetMap())
            else
                for _, v in pairs(player.GetAll()) do
                    self:NotifyServerRestart(v, self:GetTimeToRestart())
                end

                self.NextNotificationTime = self.NextRestart - nextBreakpoint
            end
        end
    end
end

ix.command.Add("AddServerRestartTime", {
	description = "Ajoute à l'heure actuelle de redémarrage du serveur un nombre spécifique de minutes.",
	adminOnly = true,
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, delay)
		delay = delay or 60
		PLUGIN.NextRestart = PLUGIN.NextRestart + (delay * 60)
        PLUGIN.NextNotificationTime = PLUGIN.NextNotificationTime + (delay * 60)

        ix.util.Notify(string.format("%d minutes au temps de redémarrage du serveur !", delay))
	end
})