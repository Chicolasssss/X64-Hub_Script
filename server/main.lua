-- Orquestador: arranca subsistemas según config

AddEventHandler("onResourceStart", function(name)
    if GetCurrentResourceName() ~= name then return end

    -- Cargar config desde cfg/config.json
    Config._configured = X64Hub_LoadConfig()

    if not Config._configured then
        print("")
        print("^1[X64HUB]^7 =================================")
        print("^1[X64HUB]  " .. _U('not_configured') .. "^7")
        print("^1[X64HUB]^7 =================================")
        print("^1[X64HUB]^7 " .. _U('enter_game_exec'))
        print("^1[X64HUB]^7   /x64setup <ServerId> <WebhookSecret> [slug]^7")
        print("^1[X64HUB]^7 " .. _U('data_at'))
        print("^1[X64HUB]^7   https://x64hub.com/s/[slug]/dashboard/configuracion^7")
        print("^1[X64HUB]^7 " .. _U('then_type_restart'))
        print("^1[X64HUB]^7 =================================^7")
        print("")
        return
    end

    -- Obtener plan del servidor desde la API
    Config.ServerPlan = "free"
    X64API.GetWithTimeout("/api/servers/" .. Config.ServerId .. "/info?t=" .. os.time(), 5000, function(ok, code, data)
        if ok and data and data.plan then
            Config.ServerPlan = data.plan
        else
            print("^1[X64HUB-DEBUG] Fallo al obtener plan. OK: " .. tostring(ok) .. " | Code: " .. tostring(code) .. "^7")
            if data and data.error then print("^1[X64HUB-DEBUG] Error: " .. tostring(data.error) .. "^7") end
        end
    end)

    -- Ajustar comportamiento según el plan
    if Config.ServerPlan == "free" then
        if Config.HeartbeatInterval < 600 then Config.HeartbeatInterval = 600 end
        Config.EnablePlayerSync = false
    end

    print("")
    print("^4[X64HUB]^7 =================================")
    print("^4[X64HUB]^7 " .. _U('connecting_to') .. Config.ApiUrl)
    print("^4[X64HUB]^7    Server ID: " .. Config.ServerId)
    print("^4[X64HUB]^7    Slug: " .. (Config.ServerSlug or Config.ServerId))
    print("^4[X64HUB]^7    " .. _U('plan') .. " ^5" .. Config.ServerPlan .. "^7")
    print("^4[X64HUB]^7    Whitelist: " .. (Config.EnableWhitelist and "^2" .. _U('yes') .. "^7" or "^1" .. _U('no') .. "^7"))
    print("^4[X64HUB]^7    Sanciones: " .. (Config.EnableSanctions and "^2" .. _U('yes') .. "^7" or "^1" .. _U('no') .. "^7"))
    print("^4[X64HUB]^7    Player Sync: " .. (Config.EnablePlayerSync and "^2" .. _U('yes') .. "^7" or "^1" .. _U('no') .. "^7"))
    print("^4[X64HUB]^7    " .. _U('cmd') .. " /" .. (Config.Command or "x64"))
    print("^4[X64HUB]^7 =================================")
    print("")

    WhitelistSync.Start()
    PlayerProfileSync.Start()
    MapSync.Start()

    Citizen.Wait(3000)
    X64API.SendEvent("resource_start", nil, {
        resource_name = GetCurrentResourceName(),
        version = "1.0.0",
        server_name = GetConvar("sv_hostname", "Servidor RP"),
        gametype = GetConvar("gametype", "roleplay"),
        locale = Config.Locale,
        plan = Config.ServerPlan
    })
end)

-- Evento para que el cliente pida datos del servidor
RegisterServerEvent("x64hub:getServerInfo")
AddEventHandler("x64hub:getServerInfo", function()
    if not Config._configured then return end
    local src = source
    local ids = GetIdentifiers(src)

    TriggerClientEvent("x64hub:serverInfo", src, {
        serverId = Config.ServerId,
        apiUrl = Config.ApiUrl,
        slug = Config.ServerSlug or Config.ServerId,
        onlinePlayers = #GetPlayers(),
        maxPlayers = GetConvar("sv_maxclients", "64"),
        serverName = GetConvar("sv_hostname", "Servidor RP"),
        discordId = ids.discord,
        steamId = ids.steam,
        license = ids.license,
        playerName = GetPlayerName(src)
    })
end)

-- Recibir respuesta de whitelist check desde el cliente
RegisterServerEvent("x64hub:checkWhitelistClient")
AddEventHandler("x64hub:checkWhitelistClient", function()
    if not Config._configured then return end
    local src = source
    local discordId = GetDiscordId(src)

    if not discordId then
        TriggerClientEvent("x64hub:whitelistResult", src, {
            whitelisted = false,
            status = "no_discord",
            error = _U('no_discord_id')
        })
        return
    end

    X64API.GetWithTimeout("/api/servers/" .. Config.ServerId .. "/whitelist/check?discord=" .. discordId, 5000, function(ok, code, data)
        TriggerClientEvent("x64hub:whitelistResult", src, data or { whitelisted = false, status = "error" })
    end)
end)
