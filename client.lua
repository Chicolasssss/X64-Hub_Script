local isOpen = false

-- Abrir el NUI
RegisterNetEvent("x64hub:openUI")
AddEventHandler("x64hub:openUI", function(data)
    if isOpen then return end
    isOpen = true
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "x64hub:open",
        command = data.command,
        playerName = data.playerName,
        discordId = data.discordId,
        steamId = data.steamId,
        playerId = data.playerId,
        serverName = data.serverName,
        onlinePlayers = data.onlinePlayers,
        maxPlayers = data.maxPlayers,
        connected = true
    })

    TriggerServerEvent("x64hub:checkWhitelistClient")
    TriggerServerEvent("x64hub:getServerInfo")
end)

-- Recibir info del servidor
RegisterNetEvent("x64hub:serverInfo")
AddEventHandler("x64hub:serverInfo", function(data)
    if not isOpen then return end
    SendNUIMessage({
        type = "x64hub:serverInfo",
        serverName = data.serverName,
        onlinePlayers = data.onlinePlayers,
        maxPlayers = data.maxPlayers,
        playerId = data.discordId and ("@" .. data.discordId) or data.playerName or "---",
        apiUrl = data.apiUrl,
        slug = data.slug,
        connected = true,
        whitelisted = data.whitelisted
    })
end)

-- Recibir resultado whitelist
RegisterNetEvent("x64hub:whitelistResult")
AddEventHandler("x64hub:whitelistResult", function(data)
    if not isOpen then return end
    SendNUIMessage({
        type = "x64hub:whitelistResult",
        whitelisted = data.whitelisted,
        status = data.status
    })
end)

-- Cerrar NUI
RegisterNUICallback("x64hub:closeUI", function(_, cb)
    isOpen = false
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Pedir info del servidor desde el NUI
RegisterNUICallback("x64hub:getServerInfo", function(_, cb)
    TriggerServerEvent("x64hub:getServerInfo")
    cb("ok")
end)

-- Abrir URL en navegador externo del juego
RegisterNUICallback("x64hub:openUrl", function(data, cb)
    if data.url then
        SetNuiFocus(false, false)
        Citizen.CreateThread(function()
            Citizen.Wait(50)
            -- Native para abrir URL en navegador externo
            Citizen.InvokeNative(0xE95C8A14CE0F3C07, data.url)
        end)
    end
    cb("ok")
end)

-- ESC para cerrar (solo check cuando está abierto)
Citizen.CreateThread(function()
    while true do
        if isOpen then
            if IsControlJustPressed(0, 322) then -- ESC
                isOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({ type = "x64hub:close" })
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(300)
        end
    end
end)

-- Acción remota para matar al jugador (Slap)
RegisterNetEvent("x64hub:killPlayer")
AddEventHandler("x64hub:killPlayer", function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 0)
end)
