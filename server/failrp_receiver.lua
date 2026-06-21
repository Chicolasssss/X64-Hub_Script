RegisterServerEvent('x64hub:server:failrpAlert')
AddEventHandler('x64hub:server:failrpAlert', function(data)
    local src = source
    if not Config._configured then return end

    local attackerId = src
    local victimId = data.victimId
    
    local payload = {
        serverId = Config.ServerId,
        type = data.type,
        attacker = {
            id = attackerId,
            name = GetPlayerName(attackerId),
            discord = GetDiscordId(attackerId)
        },
        victim = {
            id = victimId,
            name = GetPlayerName(victimId)
        },
        timeSinceSpoke = data.timeSinceSpoke,
        weapon = data.weapon,
        timestamp = os.time()
    }

    X64API.Post("/api/servers/" .. Config.ServerId .. "/sanctions/ai-alert", payload, function(ok, code, res)
        if ok then
            print("^3[X64HUB-AI]^7 Posible " .. data.type .. " detectado y enviado al dashboard web.")
        end
    end)
end)
