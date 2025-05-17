local T <const> = sl.loadLocale()

RegisterNetEvent('sl_treasurehunt:startEvent', function(zone, treasureEntity)
    if sl.treasureEvent then return warn(T['start_failed_already_started']) end

    sl.startTreasureEvent(zone, treasureEntity)
end)