local CONFIG <const> = sl.loadConfig('main')

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    local hasPermission = sl.require('modules.perms.server')

    if s ~= 0 then
        if not hasPermission(s) then
            local T <const> = sl.loadLocale()
            local FRAMEWORK <const> = sl.loadBridge()
            return FRAMEWORK.notify(s, T['no_permission'], 'error', 5000)
        end
    end

    sl.startTreasureEvent()
end)

RegisterCommand(CONFIG.tpCommand, function(s, a, rc)
    if s == 0 then return end

    local T <const> = sl.loadLocale()
    local FRAMEWORK <const> = sl.loadBridge()

    if not sl.treasureEvent then
        return FRAMEWORK.notify(s, T['treasure_event_not_found'], 'error', 5000)
    end

    local hasPermission = sl.require('modules.perms.server')

    if not hasPermission(s) then
        return FRAMEWORK.notify(s, T['no_permission'], 'error', 5000)
    end

    local playerPed = GetPlayerPed(s)
    local playerCoords = GetEntityCoords(playerPed)
    local treasureCoords = sl.treasureCoords

    SetEntityCoords(playerPed, treasureCoords.x, treasureCoords.y, treasureCoords.z)
    FRAMEWORK.notify(s, T['teleported_to_treasure'], 'success', 5000)
end)