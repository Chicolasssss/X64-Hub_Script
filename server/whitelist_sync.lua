-- Sincronización periódica de la whitelist completa
-- Almacena en caché local las IDs de Discord aprobadas

WhitelistSync = { cache = nil, lastSync = 0, interval = Config.WhitelistSyncInterval or 120 }

function WhitelistSync.Fetch(cb)
    X64API.Get("/api/servers/" .. Config.ServerId .. "/whitelist/list", function(ok, code, data)
        if ok and data and data.whitelisted then
            WhitelistSync.cache = {}
            for i = 1, #data.whitelisted do
                WhitelistSync.cache[data.whitelisted[i]] = true
            end
            WhitelistSync.lastSync = GetGameTimer()
            print("[X64HUB] Players sincronizados (" .. tostring(data.total) .. " conectados)")
        end
        if cb then cb(ok, data) end
    end)
end

function WhitelistSync.IsWhitelisted(discordId)
    if WhitelistSync.cache and discordId then
        return WhitelistSync.cache[discordId] == true
    end
    return nil
end

function WhitelistSync.Start()
    if not Config.EnableWhitelist then return end
    Citizen.CreateThread(function()
        Wait(10000)
        if not Config._configured then return end
        WhitelistSync.Fetch()
        while true do
            Wait((Config.WhitelistSyncInterval or 120) * 1000)
            if Config._configured then
                WhitelistSync.Fetch()
            end
        end
    end)
end
