local CONFIG <const> = sl.loadConfig('main')
local T <const> = sl.loadLocale()

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    local hasPermission = sl.require('modules.perms.server')

    if s ~= 0 then
        if not hasPermission(s) then
            local framework = sl.loadBridge()
            return framework.notify(s, T['no_permission'], 'error', 5000)
        end
    end

    print("test")
end)