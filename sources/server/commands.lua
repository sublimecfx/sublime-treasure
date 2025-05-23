local CONFIG <const> = sl.loadConfig('main')
local WEBHOOKS <const> = sl.loadConfig('webhooks')
local LOGS <const> = sl.require('modules.logs.server')
local T <const> = sl.loadLocale()

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    local HAS_PERMISSION <const> = sl.require('modules.perms.server')

    if s ~= 0 then
        if not HAS_PERMISSION(s) then
            local FRAMEWORK <const> = sl.loadBridge()
            LOGS.send(WEBHOOKS.cheat, T['log_unauthorized_command'], T['log_unauthorized_command_desc'], 'cheat', {
                player = s,
                command = CONFIG.manualCommand
            })
            return FRAMEWORK.notify(s, T['no_permission'], 'error', 5000)
        end
    end

    sl.startTreasureEvent()
    
    LOGS.send(WEBHOOKS.startEvent, T['log_event_started'], T['log_event_started_desc'], 'info', {
        player = s,
        command = CONFIG.manualCommand
    })
end)

RegisterCommand(CONFIG.tpCommand, function(s, a, rc)
    if s == 0 then return end

    local FRAMEWORK <const> = sl.loadBridge()

    if not sl.treasureEvent then
        LOGS.send(WEBHOOKS.staffCommand, T['log_invalid_command'], T['log_invalid_command_desc'], 'info', {
            player = s,
            command = CONFIG.tpCommand
        })
        return FRAMEWORK.notify(s, T['treasure_event_not_found'], 'error', 5000)
    end

    local HAS_PERMISSION <const> = sl.require('modules.perms.server')

    if not HAS_PERMISSION(s) then
        LOGS.send(WEBHOOKS.cheat, T['log_unauthorized_command'], T['log_unauthorized_command_desc'], 'cheat', {
            player = s,
            command = CONFIG.tpCommand
        })
        return FRAMEWORK.notify(s, T['no_permission'], 'error', 5000)
    end

    local playerPed = GetPlayerPed(s)
    local playerCoords = GetEntityCoords(playerPed)
    local treasureCoords = sl.treasureCoords

    SetEntityCoords(playerPed, treasureCoords.x, treasureCoords.y, treasureCoords.z)
    FRAMEWORK.notify(s, T['teleported_to_treasure'], 'success', 5000)
    
    LOGS.send(WEBHOOKS.staffCommand, T['log_staff_teleport'], T['log_staff_teleport_desc'], 'info', {
        player = s,
        command = CONFIG.tpCommand,
        from = {
            x = playerCoords.x,
            y = playerCoords.y,
            z = playerCoords.z
        },
        to = {
            x = treasureCoords.x,
            y = treasureCoords.y,
            z = treasureCoords.z
        }
    })
end)