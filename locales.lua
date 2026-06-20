Locales = {}

Locales['es'] = {
    ['not_configured'] = "❌ NO CONFIGURADO",
    ['enter_game_exec'] = "Entra al juego y ejecuta:",
    ['data_at'] = "Los datos están en:",
    ['then_type_restart'] = "Luego escribe: restart x64-hub",
    ['connecting_to'] = "✅ Conectando a ",
    ['yes'] = "SI",
    ['no'] = "NO",
    ['error_sending_event'] = "Error enviando evento",
    ['warning_event'] = "Advertencia en evento",
    ['setup_ingame_only'] = "Este comando solo se puede usar desde el juego.",
    ['config_saved_by'] = "Configuración guardada por ",
    ['error_whitelist'] = "Error al verificar whitelist: ",
    ['whitelist_synced'] = "Whitelist sincronizada: %s jugadores aprobados",
    ['remote_action_kick'] = "Expulsado por Administrador remoto.",
    ['no_discord_id'] = "No se pudo obtener tu ID de Discord",
    ['not_whitelisted'] = "No estás en la Whitelist",
    ['wait_eval'] = "Tu solicitud está pendiente",
    ['denied'] = "Has sido rechazado de la Whitelist",
    ['banned'] = "Estás baneado. Razón: %s",
    ['plan'] = "Plan:",
    ['cmd'] = "Comando:"
}

Locales['en'] = {
    ['not_configured'] = "❌ NOT CONFIGURED",
    ['enter_game_exec'] = "Enter the game and execute:",
    ['data_at'] = "The data is at:",
    ['then_type_restart'] = "Then type: restart x64-hub",
    ['connecting_to'] = "✅ Connecting to ",
    ['yes'] = "YES",
    ['no'] = "NO",
    ['error_sending_event'] = "Error sending event",
    ['warning_event'] = "Warning in event",
    ['setup_ingame_only'] = "This command can only be used in-game.",
    ['config_saved_by'] = "Configuration saved by ",
    ['error_whitelist'] = "Error checking whitelist: ",
    ['whitelist_synced'] = "Whitelist synced: %s approved players",
    ['remote_action_kick'] = "Kicked by Remote Administrator.",
    ['no_discord_id'] = "Could not get your Discord ID",
    ['not_whitelisted'] = "You are not Whitelisted",
    ['wait_eval'] = "Your application is pending",
    ['denied'] = "Your Whitelist application was denied",
    ['banned'] = "You are banned. Reason: %s",
    ['plan'] = "Plan:",
    ['cmd'] = "Command:"
}

Locales['pt'] = {
    ['not_configured'] = "❌ NÃO CONFIGURADO",
    ['enter_game_exec'] = "Entre no jogo e execute:",
    ['data_at'] = "Os dados estão em:",
    ['then_type_restart'] = "Depois digite: restart x64-hub",
    ['connecting_to'] = "✅ Conectando a ",
    ['yes'] = "SIM",
    ['no'] = "NÃO",
    ['error_sending_event'] = "Erro ao enviar evento",
    ['warning_event'] = "Aviso no evento",
    ['setup_ingame_only'] = "Este comando só pode ser usado no jogo.",
    ['config_saved_by'] = "Configuração salva por ",
    ['error_whitelist'] = "Erro ao verificar whitelist: ",
    ['whitelist_synced'] = "Whitelist sincronizada: %s jogadores aprovados",
    ['remote_action_kick'] = "Expulso pelo Administrador remoto.",
    ['no_discord_id'] = "Não foi possível obter seu Discord ID",
    ['not_whitelisted'] = "Você não está na Whitelist",
    ['wait_eval'] = "Sua solicitação está pendente",
    ['denied'] = "Você foi rejeitado da Whitelist",
    ['banned'] = "Você está banido. Motivo: %s",
    ['plan'] = "Plano:",
    ['cmd'] = "Comando:"
}

function _U(str, ...)
    local locale = Config.Locale or 'es'
    if Locales[locale] ~= nil and Locales[locale][str] ~= nil then
        return string.format(Locales[locale][str], ...)
    else
        return 'Translation [' .. locale .. '][' .. str .. '] does not exist'
    end
end
