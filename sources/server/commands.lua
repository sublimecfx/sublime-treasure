local CONFIG <const> = sl.loadConfig('main')

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    local hasPermission = sl.require('modules.perms.server')

    if s ~= 0 then
        if not hasPermission(s) then
            local T <const> = sl.loadLocale()
            local framework = sl.loadBridge()
            return framework.notify(s, T['no_permission'], 'error', 5000)
        end
    end

    sl.startTreasureEvent()
end)