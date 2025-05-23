RegisterNetEvent('sl_treasurehunt:startEvent', function(zone, treasureCoords)
    local T <const> = sl.loadLocale()
    if sl.treasureEvent then return warn(T['start_failed_already_started']) end    
    sl.startTreasureEvent(zone, treasureCoords)
end)

RegisterNetEvent('sl_treasurehunt:stopEvent', function()
    local T <const> = sl.loadLocale()
    if not sl.treasureEvent then return warn(T['stop_failed_not_started']) end
    sl.stopTreasureEvent()
end)

RegisterNetEvent('sl_treasurehunt:spawnVehicle', function(model)
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then return warn(T['invalid_model']) end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    local vehicle = CreateVehicle(model, 0, 0, 0, 0, true, true)

    SetModelAsNoLongerNeeded(model)

    if not vehicle then return end


    local FRAMEWORK <const> = sl.loadBridge()

    local props = FRAMEWORK.getVehicleProperties(vehicle)

    if not props then return end

    local plate = (props.plate or GetVehicleNumberPlateText(vehicle))

    if not plate then return end

    TriggerServerEvent('sl_treasurehunt:giveVehicle', model, plate, props)

    DeleteEntity(vehicle)
end)