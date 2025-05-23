RegisterNetEvent('sl_treasurehunt:openTreasure', function()
    if not sl.treasureEvent then return CancelEvent() end

    local winner = source

    local winnerPed = GetPlayerPed(winner)
    local winnerCoords = GetEntityCoords(winnerPed)
    local tcv3 = vec3(sl.treasureCoords.x, sl.treasureCoords.y, sl.treasureCoords.z)
    local distance = #(winnerCoords - tcv3)
    local T <const> = sl.loadLocale()

    if distance > 5 then 
        return DropPlayer(winner, T["cheat_detected"])
    end

    sl.stopTreasureEvent()

    if not winner then return end

    local FRAMEWORK = sl.loadBridge()

    for i = 1, #GetPlayers() do
        if i ~= winner then
            FRAMEWORK.notify(i, T["treasure_found"], 'info', 5000)
        end
    end

    local CONFIG <const> = sl.loadConfig('main')
    local reward = sl.randomWithChance(CONFIG.rewards)

    if reward.type == 'item' then
        FRAMEWORK.addItem(winner, reward.name, reward.amount)
    end

    if reward.type == 'money' then
        FRAMEWORK.addMoney(winner, reward.amount)
    end

    if reward.type == 'weapon' then
        FRAMEWORK.addWeapon(winner, reward.name)
    end
    
    if reward.type == 'car' then
        TriggerClientEvent('sl_treasurehunt:spawnVehicle', winner, reward.name)
    end

    FRAMEWORK.notify(winner, T["treasure_reward"]:format(reward.label, reward.amount), 'success', 5000)
end)


RegisterNetEvent('sl_treasurehunt:giveVehicle', function(model, plate, props)
    local FRAMEWORK <const> = sl.loadBridge()

    FRAMEWORK.addVehicle(source, model, props, plate)
end)
