-- Manejo de acciones remotas (Live Actions) desde X64HUB
CreateThread(function()
    Wait(5000)
    if not Config._configured then return end

    while true do
        PerformHttpRequest(Config.ApiUrl .. "/api/webhooks/fivem/actions?server_id=" .. Config.ServerId, function(err, text, headers)
            if err == 200 and text then
                local data = json.decode(text)
                if data and data.actions and #data.actions > 0 then
                    local completedIds = {}

                    for _, actionObj in ipairs(data.actions) do
                        local action = actionObj.metadata
                        if action and action.status == "pending" then
                            local type = action.action_type
                            local payload = action.payload or {}

                            print("^6[X64HUB-ACTIONS]^7 Executing remote action: " .. tostring(type))

                            if type == "announcement" then
                                TriggerClientEvent("chat:addMessage", -1, {
                                    color = {255, 0, 0},
                                    multiline = true,
                                    args = {"[ANUNCIO GLOBAL]", payload.message or ""}
                                })
                            elseif type == "rcon" then
                                ExecuteCommand(payload.command or "")
                            elseif type == "kick" then
                                DropPlayer(payload.playerId, payload.reason or "Expulsado por Administrador remoto.")
                            elseif type == "kill" then
                                -- Requires a client event to kill the player
                                TriggerClientEvent("x64hub:killPlayer", tonumber(payload.playerId))
                            elseif type == "give_money" then
                                -- Qbox/QBCore specific logic
                                local Player = exports.qbx_core:GetPlayer(tonumber(payload.playerId))
                                if Player then
                                    Player.Functions.AddMoney('cash', tonumber(payload.amount), "Remote Action")
                                end
                            elseif type == "give_item" then
                                local Player = exports.qbx_core:GetPlayer(tonumber(payload.playerId))
                                if Player then
                                    Player.Functions.AddItem(payload.item, tonumber(payload.amount))
                                end
                            elseif type == "ban" then
                                -- Use txAdmin or simple drop
                                ExecuteCommand("txAdmin:ban " .. tostring(payload.playerId) .. " " .. tostring(payload.reason or "Ban desde X64HUB"))
                            elseif type == "spawn_vehicle" then
                                local ped = GetPlayerPed(tonumber(payload.playerId))
                                if ped and ped ~= 0 then
                                    local coords = GetEntityCoords(ped)
                                    local vehicleHash = GetHashKey(payload.vehicleModel or "adder")
                                    -- Very basic server-side spawn for demonstration (ideally requires client-side RequestModel)
                                    local veh = CreateVehicle(vehicleHash, coords.x, coords.y, coords.z, 0.0, true, true)
                                    SetPedIntoVehicle(ped, veh, -1)
                                end
                            elseif type == "set_weather" then
                                ExecuteCommand("weather " .. tostring(payload.weather or "EXTRASUNNY"))
                            end

                            table.insert(completedIds, actionObj.id)
                        end
                    end

                    -- Marcar como completadas
                    if #completedIds > 0 then
                        PerformHttpRequest(Config.ApiUrl .. "/api/webhooks/fivem/actions", function(e, t, h) end, "POST", json.encode({
                            server_id = Config.ServerId,
                            action_ids = completedIds
                        }), { ["Content-Type"] = "application/json", ["X-Webhook-Secret"] = Config.WebhookSecret })
                    end
                end
            end
        end, "GET", "", { ["Content-Type"] = "application/json", ["X-Webhook-Secret"] = Config.WebhookSecret })

        Wait(10000) -- Polling cada 10 segundos
    end
end)
