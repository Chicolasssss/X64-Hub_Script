MapSync = {}
local syncInterval = 2000 -- 2 seconds

function MapSync.Start()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(syncInterval)
            if Config._configured then
                local playersData = {}
                local players = GetPlayers()

                for i=1, #players do
                    local playerId = players[i]
                    local ped = GetPlayerPed(playerId)
                    if ped and ped ~= 0 then
                        local coords = GetEntityCoords(ped)
                        local heading = GetEntityHeading(ped)
                        local health = GetEntityHealth(ped)
                        local maxHealth = GetEntityMaxHealth(ped)
                        local armor = GetPedArmour(ped)
                        
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local inVehicle = false
                        
                        if vehicle and vehicle ~= 0 then
                            inVehicle = true
                        end

                        table.insert(playersData, {
                            id = playerId,
                            name = GetPlayerName(playerId),
                            x = coords.x,
                            y = coords.y,
                            z = coords.z,
                            heading = heading,
                            health = health,
                            maxHealth = maxHealth,
                            armor = armor,
                            inVehicle = inVehicle
                        })
                    end
                end

                if #playersData > 0 then
                    local payload = {
                        serverId = Config.ServerId,
                        players = playersData
                    }
                    
                    X64API.Post("/api/servers/" .. Config.ServerId .. "/map/sync", payload, function(ok, code, data)
                        -- Silent to avoid console spam
                    end)
                end
            end
        end
    end)
end


