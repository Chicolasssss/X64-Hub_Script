-- Heartbeat: envía estado del servidor cada X segundos
CreateThread(function()
    -- Esperar a que la config esté lista
    Wait(5000)
    if not Config._configured then return end

    while true do
        local players = GetPlayers()
        local playerCount = #players
        local maxPlayers = GetConvar("sv_maxclients", "64")
        local uptime = math.floor(GetGameTimer() / 1000 / 60)

        local totalPing = 0
        for i = 1, playerCount do totalPing = totalPing + GetPlayerPing(tonumber(players[i])) end

        X64API.SendEvent("heartbeat", nil, {
            players_online = playerCount,
            max_players = tonumber(maxPlayers),
            resources = GetNumResources(),
            uptime_minutes = uptime,
            avg_ping = playerCount > 0 and math.floor(totalPing / playerCount) or 0
        })

        Wait(Config.HeartbeatInterval * 1000)
    end
end)
