local CONFIG = sl.loadConfig('main')

RegisterCommand(CONFIG.manualCommand, function(s, a, rc)
    print("test")
end)