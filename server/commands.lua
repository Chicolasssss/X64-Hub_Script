-- Comandos in-game
local cmdName = Config.Command or "x64"

RegisterCommand(cmdName, function(src, args, raw)
    if src == 0 then return end
    if not Config._configured then
        TriggerClientEvent("chat:addMessage", src, {
            args = { "[X64HUB]", "^1El resource no está configurado. Usa /x64setup^7" }
        })
        return
    end

    local ids = GetIdentifiers(src)

    TriggerClientEvent("x64hub:openUI", src, {
        command = cmdName,
        playerName = GetPlayerName(src),
        discordId = ids.discord,
        steamId = ids.steam,
        playerId = src,
        serverName = GetConvar("sv_hostname", "Servidor RP"),
        onlinePlayers = #GetPlayers(),
        maxPlayers = GetConvar("sv_maxclients", "64")
    })
end, false)

RegisterCommand("report", function(src, args, raw)
    if src == 0 then return end
    if not Config._configured then
        TriggerClientEvent("chat:addMessage", src, {
            args = { "[X64HUB]", "^1El resource no está configurado. Usa /x64setup^7" }
        })
        return
    end

    local msg = table.concat(args, " ")
    if msg == "" then
        TriggerClientEvent("chat:addMessage", src, {
            args = { "[X64HUB]", "Usa: /report <mensaje>" }
        })
        return
    end

    local ids = GetIdentifiers(src)
    X64API.SendEvent("player_report", src, {
        name = GetPlayerName(src),
        message = msg,
        discord_id = ids.discord
    })

    TriggerClientEvent("chat:addMessage", src, {
        args = { "[X64HUB]", "Reporte enviado a los administradores." }
    })
end, false)

RegisterCommand("x64whitelist", function(src, args, raw)
    if src == 0 then return end
    if not Config._configured then
        TriggerClientEvent("chat:addMessage", src, {
            args = { "[X64HUB]", "^1El resource no está configurado. Usa /x64setup^7" }
        })
        return
    end
    WhitelistSync.Fetch(function(ok, data)
        if ok then
            TriggerClientEvent("chat:addMessage", src, {
                args = { "[X64HUB]", "^2✅ Whitelist sincronizada: " .. tostring(data.total or 0) .. " jugadores aprobados^7" }
            })
        else
            TriggerClientEvent("chat:addMessage", src, {
                args = { "[X64HUB]", "^1Error al sincronizar whitelist^7" }
            })
        end
    end)
end, false)
