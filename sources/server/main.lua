local CONFIG <const> = sl.loadConfig('main')

CreateThread(function()
    while true do
        Wait(CONFIG.eventFrequency)
        
        if not sl.treasureEvent then
            sl.startTreasureEvent()
        end
    end
end)