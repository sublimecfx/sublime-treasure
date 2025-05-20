RegisterNetEvent('sl_treasurehunt:openTreasure', function()
    if not sl.treasureEvent then return CancelEvent() end

    sl.stopTreasureEvent()

    local winner = source

    if not winner then return end

    local FRAMEWORK = sl.loadBridge()
    local T <const> = sl.loadLocale()

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
        FRAMEWORK.addWeapon(winner, reward.name, reward.amount)
    end
    
    if reward.type == 'car' then
        FRAMEWORK.addVehicle(winner, reward.name, reward.amount)
    end

    FRAMEWORK.notify(winner, T["treasure_reward"]:format(reward.label, reward.amount), 'success', 5000)
end)
