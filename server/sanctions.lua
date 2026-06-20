-- Verificación de sanciones activas al conectar
-- Se ejecuta desde events.lua en el hook de playerConnecting

function X64CheckSanctions(playerId, discordId, cb)
    X64API.Get("/api/servers/" .. Config.ServerId .. "/sanctions/active?discord=" .. discordId, function(ok, code, data)
        if not ok then
            print("[X64HUB] Error al verificar sanciones: " .. tostring(code))
            cb(false, nil)
            return
        end

        cb(true, data)
    end)
end
