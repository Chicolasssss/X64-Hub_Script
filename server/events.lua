-- Eventos: connect, disconnect, death, sync

-- Extraer identificadores
function GetIdentifiers(src)
    local ids = GetPlayerIdentifiers(src)
    local result = { discord = nil, steam = nil, license = nil, all = ids }
    for _, id in ipairs(ids) do
        if string.find(id, "discord:") then
            result.discord = string.gsub(id, "discord:", "")
        elseif string.find(id, "steam:") then
            result.steam = id
        elseif string.find(id, "license:") then
            result.license = id
        end
    end
    return result
end

function GetDiscordId(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.find(id, "discord:") then return string.gsub(id, "discord:", "") end
    end
    return nil
end

function GetSteamId(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.find(id, "steam:") then return id end
    end
    return nil
end

function GetLicense(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.find(id, "license:") then return id end
    end
    return nil
end

function CheckSanctions(discordId, deferrals)
    X64API.GetWithTimeout("/api/servers/" .. Config.ServerId .. "/sanctions/active?discord=" .. discordId, 10000, function(ok, code, data)
        if not ok then deferrals.done("Error al verificar sanciones (timeout).") return end
        if data.sanctioned then
            local s = data.sanctions[1]
            local duracion = s.expires_at and ("hasta " .. s.expires_at) or "permanente"
            deferrals.done("Tienes una sanción activa: " .. (s.reason or "No especificado") .. " (" .. duracion .. ")") return
        end
        deferrals.done()
    end)
end

local PlayerJoinTimes = {}

-- Al conectar
AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    if not Config._configured then return end
    local src = source
    local ids = GetIdentifiers(src)
    local discordId = ids.discord

    if discordId then
        PlayerJoinTimes[discordId] = os.time()
    end

    if Config.LogJoinLeave then
        X64API.SendEvent("player_join", src, {
            name = playerName, discord_id = discordId, identifiers = ids.all
        })
    end

    if Config.EnableWhitelist and not discordId then
        deferrals.defer(); Citizen.Wait(0)
        deferrals.done("Debes iniciar sesión con Discord en https://x64hub.com para acceder a este servidor.")
        return
    end

    if Config.EnableWhitelist and discordId then
        deferrals.defer(); Citizen.Wait(0)

        local cacheOk = WhitelistSync.IsWhitelisted(discordId)
        if cacheOk == true then
            if Config.EnableSanctions then
                CheckSanctions(discordId, deferrals)
            else deferrals.done() end
            return
        end
        if cacheOk == false then
            deferrals.done("No tienes whitelist aprobada. Estado: no aprobada")
            return
        end

        X64API.GetWithTimeout("/api/servers/" .. Config.ServerId .. "/whitelist/check?discord=" .. discordId, 10000, function(ok, code, data)
            if not ok then deferrals.done("Error al verificar whitelist (timeout). Intenta de nuevo.") return end
            if data.status == "no_account" then
                deferrals.done("Debes iniciar sesión en https://x64hub.com con Discord para acceder.") return
            end
            if not data.whitelisted then
                local estado = data.status == "pending" and "pendiente" or data.status == "rejected" and "rechazada" or "no solicitada"
                deferrals.done("No tienes whitelist aprobada. Estado: " .. estado) return
            end
            if Config.EnableSanctions then
                CheckSanctions(discordId, deferrals)
            else deferrals.done() end
        end)
        return
    end

    if Config.EnableSanctions and discordId then
        deferrals.defer(); Citizen.Wait(0)
        CheckSanctions(discordId, deferrals)
        return
    end
end)

-- Desconexión
AddEventHandler("playerDropped", function(reason)
    if not Config._configured then return end
    local src = source
    local discordId = GetDiscordId(src)
    
    local playtimeMinutes = 0
    if discordId and PlayerJoinTimes[discordId] then
        playtimeMinutes = math.floor((os.time() - PlayerJoinTimes[discordId]) / 60)
        PlayerJoinTimes[discordId] = nil
    end

    if Config.LogJoinLeave then
        X64API.SendEvent("player_leave", src, {
            name = GetPlayerName(src), discord_id = discordId, reason = reason, playtime_minutes = playtimeMinutes
        })
    end
end)

-- Muertes batch
local DeathCounts = {}
CreateThread(function()
    Wait(5000)
    if not Config._configured then return end
    while true do
        Wait(Config.HeartbeatInterval * 1000)
        local batch = {}
        for src, count in pairs(DeathCounts) do
            table.insert(batch, { src = src, count = count })
        end
        if #batch > 0 then X64API.SendEvent("deaths_batch", nil, { deaths = batch }) end
        DeathCounts = {}
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)
    if not Config._configured or not Config.LogDeath then return end
    if name == "CEventDeath" then
        local victim = NetworkGetEntityOwner(args[1])
        if victim ~= -1 then
            DeathCounts[tostring(victim)] = (DeathCounts[tostring(victim)] or 0) + 1
        end
    end
end)

-- Player sync batch
CreateThread(function()
    Wait(15000)
    if not Config._configured or not Config.EnablePlayerSync then return end
    while true do
        local players = GetPlayers()
        local batch = {}
        for i = 1, #players do
            local src = tonumber(players[i])
            local ids = GetIdentifiers(src)
            if ids.discord then
                table.insert(batch, {
                    id = src, name = GetPlayerName(src), discord_id = ids.discord,
                    steam_id = ids.steam, license = ids.license, ping = GetPlayerPing(src)
                })
            end
        end
        if #batch > 0 then X64API.SendEvent("players_sync", nil, { players = batch, count = #batch }) end
        Wait(600000)
    end
end)
