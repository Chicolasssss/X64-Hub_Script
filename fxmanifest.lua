fx_version "cerulean"
game "gta5"
author "X64HUB"
description "Integración con X64HUB - Panel de administración y métricas"
version "1.0.0"

shared_script "config.lua"

client_script "client.lua"

server_scripts {
    "server/setup.lua",     -- carga cfg/config.json primero
    "server/api.lua",
    "server/heartbeat.lua",
    "server/whitelist.lua",
    "server/whitelist_sync.lua",
    "server/player_profile_sync.lua",
    "server/sanctions.lua",
    "server/events.lua",
    "server/anticheat.lua",
    "server/commands.lua",
    "server/remote_actions.lua",
    "server/main.lua"
}

ui_page "web/ui.html"

files {
    "web/ui.html",
    "web/script.js",
    "web/style.css"
}
