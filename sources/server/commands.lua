local CONFIG = sl.loadConfig('main')

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    local hasPermission = sl.require('modules.perms.server')

    if s ~= 0 then
        if not hasPermission(s) then
            return warn('You do not have permission to use this command.')
        end
    end

    print("test")
end)