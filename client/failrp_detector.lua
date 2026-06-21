-- client/failrp_detector.lua

local lastSpokeTime = GetGameTimer()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        -- NetworkIsPlayerTalking usually works with native mumble and pma-voice
        if NetworkIsPlayerTalking(PlayerId()) then
            lastSpokeTime = GetGameTimer()
        end
    end
end)

-- Detect combat events (RDM Detection)
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local isFatal = args[6] == 1
        
        -- Check if the current player is the attacker and the victim is a player
        if isFatal and attacker == PlayerPedId() and IsPedAPlayer(victim) and attacker ~= victim then
            local currentTime = GetGameTimer()
            local timeSinceLastSpoke = currentTime - lastSpokeTime
            
            -- If the player hasn't spoken in the last 3 minutes (180000 ms), flag as potential RDM
            if timeSinceLastSpoke > 180000 then
                local timeSinceMinutes = math.floor(timeSinceLastSpoke / 60000)
                
                TriggerServerEvent('x64hub:server:failrpAlert', {
                    type = "RDM",
                    victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim)),
                    timeSinceSpoke = timeSinceMinutes,
                    weapon = args[7]
                })
            end
        end
    end
end)
