Config = {
    -- URL base de X64HUB (sin / al final)
    ApiUrl = "https://x64hub.com",

    -- Webhook secret generado al crear el servidor en X64HUB
    WebhookSecret = "pon-aqui-tu-secret",

    -- UUID del servidor en X64HUB
    ServerId = "pon-aqui-el-uuid-del-servidor",

    -- Slug del servidor para URLs limpias (opcional, fallback a ServerId)
    ServerSlug = "tu-slug-personalizado",

    -- Intervalo de heartbeat en segundos (cada cuanto envía estado)
    HeartbeatInterval = 300,

    -- Intervalo de sincronización de whitelist en segundos
    WhitelistSyncInterval = 120,

    -- Activar verificación de whitelist al conectar
    EnableWhitelist = true,

    -- Activar verificación de sanciones activas al conectar
    EnableSanctions = true,

    -- Activar Anticheat (detección de explosiones y armas)
    EnableAnticheat = true,

    -- Activar sincronización de jugadores (banco, efectivo, etc)
    EnablePlayerSync = true,

    -- Canales de logs para eventos (chat, death, etc)
    LogDeath = true,
    LogJoinLeave = true,
    LogChat = false,

    -- Comando para abrir el NUI
    Command = "x64",

    -- Idioma del NUI: "es" o "en"
    Locale = "es"
}
