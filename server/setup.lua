-- Configuración desde archivo JSON + setup wizard in-game

-- Cargar config desde cfg/config.json (se ejecuta al parsear el archivo)
function X64Hub_LoadConfig()
    local data = LoadResourceFile(GetCurrentResourceName(), "cfg/config.json")
    if not data then return false end

    local ok, parsed = pcall(json.decode, data)
    if not ok or not parsed then return false end

    local sid = parsed.ServerId and parsed.ServerId ~= "" or false
    local sec = parsed.WebhookSecret and parsed.WebhookSecret ~= "" or false
    if not sid or not sec then return false end

    Config.ApiUrl = parsed.ApiUrl or Config.ApiUrl
    Config.ServerId = parsed.ServerId
    Config.WebhookSecret = parsed.WebhookSecret
    Config.ServerSlug = parsed.ServerSlug or Config.ServerSlug
    Config.HeartbeatInterval = parsed.HeartbeatInterval or Config.HeartbeatInterval
    Config.EnableWhitelist = parsed.EnableWhitelist ~= nil and parsed.EnableWhitelist or Config.EnableWhitelist
    Config.WhitelistSyncInterval = parsed.WhitelistSyncInterval or Config.WhitelistSyncInterval
    Config.EnableSanctions = parsed.EnableSanctions ~= nil and parsed.EnableSanctions or Config.EnableSanctions
    Config.EnablePlayerSync = parsed.EnablePlayerSync ~= nil and parsed.EnablePlayerSync or Config.EnablePlayerSync
    Config.LogDeath = parsed.LogDeath ~= nil and parsed.LogDeath or Config.LogDeath
    Config.LogJoinLeave = parsed.LogJoinLeave ~= nil and parsed.LogJoinLeave or Config.LogJoinLeave

    return true
end

RegisterCommand("x64setup", function(src, args, raw)
    local serverId = args[1]
    local secret = args[2]
    local slug = args[3] or ""

    if not serverId or not secret then
        if src == 0 then
            print("^1[X64HUB]^7 Uso: x64setup <serverId> <secret> [slug]")
        else
            TriggerClientEvent("chat:addMessage", src, {
                args = { "[X64HUB]", "^1Uso: /x64setup <serverId> <secret> [slug]^7" }
            })
        end
        return
    end

    -- If in-game, check if they are admin.
    if src ~= 0 and not (IsPlayerAceAllowed(src, "command") or IsPlayerAceAllowed(src, "group.admin")) then
        TriggerClientEvent("chat:addMessage", src, {
            args = { "[X64HUB]", "^1No tienes permisos para usar este comando.^7" }
        })
        return
    end

    local cfg = {
        ApiUrl = Config.ApiUrl,
        ServerId = serverId,
        WebhookSecret = secret,
        ServerSlug = slug ~= "" and slug or nil,
        HeartbeatInterval = Config.HeartbeatInterval,
        EnableWhitelist = Config.EnableWhitelist,
        WhitelistSyncInterval = Config.WhitelistSyncInterval,
        EnableSanctions = Config.EnableSanctions,
        EnablePlayerSync = Config.EnablePlayerSync,
        LogDeath = Config.LogDeath,
        LogJoinLeave = Config.LogJoinLeave
    }

    SaveResourceFile(GetCurrentResourceName(), "cfg/config.json", json.encode(cfg, {indent=true}), -1)

    if src == 0 then
        print("^2[X64HUB] ✅ Configuración guardada en cfg/config.json^7")
        print("^3[X64HUB] Ejecuta: restart x64-hub para aplicar los cambios.^7")
    else
        TriggerClientEvent("chat:addMessage", src, {
            args = { "[X64HUB]", "^2✅ Configuración guardada en config.json^7" }
        })
        TriggerClientEvent("chat:addMessage", src, {
            args = { "[X64HUB]", "^3Ejecuta: restart x64-hub^7 para aplicar los cambios." }
        })
        print("^2[X64HUB] Configuración guardada por " .. GetPlayerName(src) .. "^7")
    end
end, false) -- false = dejamos que nuestra lógica interna de IsPlayerAceAllowed maneje los permisos
