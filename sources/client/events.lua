RegisterNetEvent('sl_treasurehunt:startEvent', function(zone, treasureCoords)
    local T <const> = sl.loadLocale()
    if sl.treasureEvent then return warn(T['start_failed_already_started']) end    
    sl.startTreasureEvent(zone, treasureCoords)
end)

RegisterNetEvent('sl_treasurehunt:stopEvent', function()
    print('stopEvent')
    local T <const> = sl.loadLocale()
    if not sl.treasureEvent then return warn(T['stop_failed_not_started']) end
    sl.stopTreasureEvent()
end)
