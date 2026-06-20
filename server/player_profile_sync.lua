-- Sincronización de perfiles de jugadores (Zero-Click Portal)
-- Envía datos al panel cada 5 minutos para mantener actualizado el perfil

PlayerProfileSync = {}

function PlayerProfileSync.SyncPlayers()
    if not Config._configured or not Config.EnablePlayerSync then return end
    
    local payload = {
        server_id = Config.ServerId,
        players = {}
    }

    local players = GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        local ids = GetIdentifiers(src)
        
        if ids and ids.discord then
            local data = {
                discord_id = ids.discord,
                steam_id = ids.steam,
                license = ids.license,
                player_name = GetPlayerName(src),
            }

            local bank, cash = GetPlayerEconomy(src)
            local vehicles = GetPlayerVehicles(src)
            
            print("^3[X64HUB-DEBUG] Player " .. src .. " | Bank: " .. tostring(bank) .. " | Cash: " .. tostring(cash) .. " | Vehicles: " .. tostring(#vehicles) .. "^7")
            if bank ~= nil then data.bank = bank end
            if cash ~= nil then data.cash = cash end
            data.vehicles = vehicles

            table.insert(payload.players, data)
        end
    end

    if #payload.players > 0 then
        X64API.Post("/api/portal/sync", payload, function() end)
    end
end

function PlayerProfileSync.Start()
    if not Config.EnablePlayerSync then return end
    Citizen.CreateThread(function()
        Wait(15000)
        if not Config._configured then return end
        while true do
            if Config._configured then
                PlayerProfileSync.SyncPlayers()
            end
            Wait(300000)
        end
    end)
end

function GetPlayerVehicles(src)
    local vehicles = {}
    -- Qbox / QBCore
    if GetResourceState('qbx_core') == 'started' or GetResourceState('qb-core') == 'started' then
        local citizenid = nil
        if GetResourceState('qbx_core') == 'started' then
            local Player = exports.qbx_core:GetPlayer(src)
            if Player then citizenid = Player.PlayerData.citizenid end
        else
            local QBCore = exports['qb-core']:GetCoreObject()
            if QBCore then
                local Player = QBCore.Functions.GetPlayer(src)
                if Player then citizenid = Player.PlayerData.citizenid end
            end
        end
        
        if citizenid then
            local results = exports.oxmysql:query_async("SELECT plate, vehicle FROM player_vehicles WHERE citizenid = ?", {citizenid})
            if results then
                for i = 1, #results do
                    table.insert(vehicles, { plate = results[i].plate, model = results[i].vehicle })
                end
            end
        end
    -- ESX
    elseif GetResourceState('es_extended') == 'started' then
        local ESX = exports['es_extended']:getSharedObject()
        if ESX then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer and xPlayer.identifier then
                local results = exports.oxmysql:query_async("SELECT plate, vehicle FROM owned_vehicles WHERE owner = ?", {xPlayer.identifier})
                if results then
                    for i = 1, #results do
                        local vData = json.decode(results[i].vehicle)
                        table.insert(vehicles, { plate = results[i].plate, model = vData and (vData.model or "Vehículo") or "Vehículo" })
                    end
                end
            end
        end
    end
    return vehicles
end

function GetPlayerEconomy(src)
    -- ESX
    if GetResourceState('es_extended') == 'started' then
        local ESX = exports['es_extended']:getSharedObject()
        if ESX then
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                local accounts = xPlayer.getAccounts()
                local bank, cash = 0, 0
                for _, acc in ipairs(accounts) do
                    if acc.name == "bank" then bank = acc.money or 0 end
                    if acc.name == "money" then cash = acc.money or 0 end
                end
                if bank > 0 or cash > 0 then return bank, cash end
            end
        end
    end

    -- Qbox
    if GetResourceState('qbx_core') == 'started' then
        local Player = exports.qbx_core:GetPlayer(src)
        if Player and Player.PlayerData and Player.PlayerData.money then
            local cash = Player.PlayerData.money.cash or 0
            local bank = Player.PlayerData.money.bank or 0
            if cash > 0 or bank > 0 then return bank, cash end
        end
    end

    -- QBCore (Legacy)
    if GetResourceState('qb-core') == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        if QBCore then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player and Player.PlayerData and Player.PlayerData.money then
                local cash = Player.PlayerData.money.cash or 0
                local bank = Player.PlayerData.money.bank or 0
                if cash > 0 or bank > 0 then return bank, cash end
            end
        end
    end

    return nil, nil
end
