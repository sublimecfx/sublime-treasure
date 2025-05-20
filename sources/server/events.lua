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
        print(reward.name, reward.amount)
        return
    end

    if reward.type == 'money' then
        print(reward.amount)
        return
    end

    if reward.type == 'weapon' then
        print(reward.name, reward.amount)
        return
    end
    
    if reward.type == 'car' then
        print(reward.name)
        return
    end
end)
