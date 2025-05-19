RegisterNetEvent('sl_treasurehunt:startEvent', function(zone, treasureCoords)
    local T <const> = sl.loadLocale()
    if sl.treasureEvent then return warn(T['start_failed_already_started']) end    
    sl.startTreasureEvent(zone, treasureCoords)
end)