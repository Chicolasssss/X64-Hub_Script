-- Verificación de whitelist al conectar
-- Primero verifica caché local, luego API

function X64CheckWhitelist(playerId, discordId, cb)
    local cached = WhitelistSync.IsWhitelisted(discordId)
    if cached ~= nil then
        cb(true, { whitelisted = cached, status = cached and "approved" or "no_submission", cached = true })
        return
    end

    X64API.Get("/api/servers/" .. Config.ServerId .. "/whitelist/check?discord=" .. discordId, function(ok, code, data)
        if not ok then
            print("[X64HUB] Error al verificar whitelist: " .. tostring(code))
            cb(false, nil)
            return
        end

        cb(true, data)
    end)
end
