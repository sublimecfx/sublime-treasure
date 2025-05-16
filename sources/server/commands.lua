local CONFIG = sl.loadConfig('main')

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    local hasPermission = sl.require('modules.perms.server')

    if s ~= 0 then
        if not hasPermission(s) then
            local framework = sl.loadBridge()
            return framework.notify(s, 'You do not have permission to use this command.', 'error', 5000)
        end
    end

    print("test")
end)