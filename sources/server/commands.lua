local CONFIG = sl.loadConfig('main')

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    local hasPermission = sl.require('modules.perms.server')

    if s ~= 0 then
        if not hasPermission(s) then
            local framework = sl.loadBridge()
            local T <const> = sl.loadLocale()
            return framework.notify(s, T['no_permission'], 'error', 5000)
        end
    end

    local T <const> = sl.loadLocale()
    print(T['no_permission'])
end)