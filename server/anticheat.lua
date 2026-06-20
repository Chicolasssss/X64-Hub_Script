-- Anticheat / Logger avanzado para X64HUB
-- Este módulo intercepta eventos comunes de FiveM (explosiones, armas) y expone exports para otros anticheats (ej. WaweShield).

-- Evento exportado para que otros scripts (Anticheats externos o Frameworks) envíen logs.
-- Ejemplo de uso desde otro script: exports["x64-hub"]:LogEvent("anticheat", source, "Aimbot detectado", "info_extra")
exports("LogEvent", function(category, source, reason, details)
    if not Config._configured then return end
    local src = tonumber(source)
    local discordId = src and GetDiscordId(src) or nil
    local playerName = src and GetPlayerName(src) or "Desconocido"

    local eventType = "server_log"
    if category == "anticheat" or category == "anticheat_flag" then
        eventType = "anticheat_trigger"
    end

    X64API.SendEvent(eventType, src, {
        category = category,
        name = playerName,
        discord_id = discordId,
        reason = reason,
        details = details or {}
    })
end)

-- 1. Detección de Explosiones Masivas (Posible modder)
AddEventHandler("explosionEvent", function(sender, ev)
    if not Config._configured or not Config.EnableAnticheat then return end
    
    local src = tonumber(sender)
    if src <= 0 then return end
    
    local isDamage = ev.isDamage or false
    local explosionType = ev.explosionType or -1
    
    -- Tipos de explosiones comunes en mod menus (ej: 0=grenade, 29=blimp, 9=gas, 2=stickybomb)
    local blacklistedExplosions = { [29] = true, [32] = true, [33] = true, [35] = true, [36] = true, [37] = true, [38] = true }
    
    if blacklistedExplosions[explosionType] then
        CancelEvent() -- Bloqueamos la explosión
        exports["x64-hub"]:LogEvent("anticheat_flag", src, "Intento de explosión masiva", { explosion_type = explosionType })
    end
end)

-- 2. Detección de Daño Modificado o Armas prohibidas
AddEventHandler("weaponDamageEvent", function(sender, ev)
    if not Config._configured or not Config.EnableAnticheat then return end
    local src = tonumber(sender)
    if src <= 0 then return end
    
    -- Si el daño base supera un umbral ridículo (ej 1000)
    if ev.weaponDamage and ev.weaponDamage > 500 then
        exports["x64-hub"]:LogEvent("anticheat_flag", src, "Daño de arma anormalmente alto detectado", { damage = ev.weaponDamage, weaponType = ev.weaponType })
    end
end)

-- 3. Interceptar chat (Logs de chat)
AddEventHandler('chatMessage', function(source, name, message)
    if not Config._configured or not Config.LogChat then return end
    if string.sub(message, 1, 1) == "/" then return end -- No loguear comandos aquí
    
    exports["x64-hub"]:LogEvent("chat", source, "Mensaje de chat", { message = message })
end)

-- 4. Interceptar intentos de reinicio de recursos desde el lado del cliente (típico de mod menus)
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then return end
    -- Si el anticheat quiere saber si alguien apaga un recurso
    exports["x64-hub"]:LogEvent("system", nil, "Recurso detenido: " .. resourceName, {})
end)
