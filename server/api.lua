-- Wrapper para llamadas HTTP a X64HUB
X64API = {}

function X64API.Headers()
    return {
        ["Content-Type"] = "application/json",
        ["X-Webhook-Secret"] = Config.WebhookSecret
    }
end

function X64API.Post(endpoint, data, cb)
    local url = Config.ApiUrl .. endpoint
    local body = json.encode(data)
    PerformHttpRequest(url, function(code, res, headers)
        if cb then
            local ok = code >= 200 and code < 300
            local parsed = {}
            pcall(function() parsed = json.decode(res) end)
            cb(ok, code, parsed, res)
        end
    end, "POST", body, X64API.Headers())
end

function X64API.Get(endpoint, cb)
    local url = Config.ApiUrl .. endpoint
    PerformHttpRequest(url, function(code, res, headers)
        if cb then
            local ok = code >= 200 and code < 300
            local parsed = {}
            pcall(function() parsed = json.decode(res) end)
            cb(ok, code, parsed, res)
        end
    end, "GET", nil, X64API.Headers())
end

-- GET con timeout (cortesía para deferred events)
function X64API.GetWithTimeout(endpoint, timeoutMs, cb)
    local url = Config.ApiUrl .. endpoint
    local done, result = false, nil

    PerformHttpRequest(url, function(code, res, headers)
        local ok = code >= 200 and code < 300
        local parsed = {}
        pcall(function() parsed = json.decode(res) end)
        result = { ok, code, parsed, res }
        done = true
    end, "GET", nil, X64API.Headers())

    local elapsed = 0
    while not done and elapsed < timeoutMs do
        Citizen.Wait(100)
        elapsed = elapsed + 100
    end

    if not done then
        cb(false, 408, { error = "timeout" }, nil)
        return
    end

    cb(result[1], result[2], result[3], result[4])
end

-- Enviar evento al webhook de FiveM (fire-and-forget)
function X64API.SendEvent(eventType, playerId, metadata)
    X64API.Post("/api/webhooks/fivem", {
        server_id = Config.ServerId,
        event_type = eventType,
        player_id = playerId and tostring(playerId) or nil,
        metadata = metadata or {}
    }, function(ok, code, data, res)
        if not ok then
            print("^1[X64HUB] Error enviando evento " .. eventType .. ": HTTP " .. tostring(code) .. "^7")
            if data and data.error then print("^1[X64HUB] Detalle: " .. tostring(data.error) .. "^7") end
        elseif data and data.errors and #data.errors > 0 then
            print("^3[X64HUB] Advertencia en evento " .. eventType .. ": " .. json.encode(data.errors) .. "^7")
        end
    end)
end
