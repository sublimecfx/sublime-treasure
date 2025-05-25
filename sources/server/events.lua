local T <const> = sl.loadLocale()
local WEBHOOKS <const> = sl.loadConfig('webhooks')
local LOGS <const> = sl.require('modules.logs.server')

local function logEventEnd()
    if not sl.treasureEvent then return end
    
    LOGS.send(WEBHOOKS.stopEvent, T['log_event_ended'], T['log_event_ended_desc'], 'info', {
        coords = {
            x = sl.treasureCoords.x,
            y = sl.treasureCoords.y,
            z = sl.treasureCoords.z
        }
    })
end

RegisterNetEvent('sl_treasurehunt:openTreasure', function()
    if not sl.treasureEvent then 
        LOGS.send(WEBHOOKS.cheat, T['log_invalid_interaction'], T['log_invalid_interaction_desc'], 'cheat', {
            player = source
        })
        return CancelEvent() 
    end

    local winner = source

    local winnerPed = GetPlayerPed(winner)
    local winnerCoords = GetEntityCoords(winnerPed)
    local tcv3 = vec3(sl.treasureCoords.x, sl.treasureCoords.y, sl.treasureCoords.z)
    local distance = #(winnerCoords - tcv3)

    -- Optimisation: Utiliser une vérification de distance plus efficace
    -- Vérifier d'abord si le joueur est dans le même quadrant de la carte
    local xDiff = math.abs(winnerCoords.x - tcv3.x)
    local yDiff = math.abs(winnerCoords.y - tcv3.y)
    
    if xDiff > 100 or yDiff > 100 then
        LOGS.send(WEBHOOKS.cheat, T['log_cheat_distance'], T['log_cheat_distance_desc'], 'cheat', {
            player = winner,
            coords = {
                x = winnerCoords.x,
                y = winnerCoords.y,
                z = winnerCoords.z
            },
            treasureCoords = {
                x = tcv3.x,
                y = tcv3.y,
                z = tcv3.z
            },
            distance = distance
        })
        return DropPlayer(winner, T["cheat_detected"])
    end
    
    -- Vérification précise de la distance seulement si nécessaire
    if distance > 5 then 
        LOGS.send(WEBHOOKS.cheat, T['log_cheat_distance'], T['log_cheat_distance_desc'], 'cheat', {
            player = winner,
            coords = {
                x = winnerCoords.x,
                y = winnerCoords.y,
                z = winnerCoords.z
            },
            treasureCoords = {
                x = tcv3.x,
                y = tcv3.y,
                z = tcv3.z
            },
            distance = distance
        })
        return DropPlayer(winner, T["cheat_detected"])
    end

    sl.stopTreasureEvent()
    logEventEnd()

    if not winner then return end

    local FRAMEWORK = sl.loadBridge()

    -- Au lieu d'envoyer une notification à chaque joueur individuellement
    local players = GetPlayers()
    local notificationData = {
        message = T["treasure_found"],
        type = 'info',
        duration = 5000
    }
    
    for i = 1, #players do
        local playerId = tonumber(players[i])
        if playerId ~= winner then
            FRAMEWORK.notify(playerId, notificationData.message, notificationData.type, notificationData.duration)
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

    FRAMEWORK.notify(winner, T["treasure_reward"]:format(reward.label, (reward.amount or '1')), 'success', 5000)

    LOGS.send(WEBHOOKS.win, T['treasure_found'], T['win_logs']:format(GetPlayerName(winner)), 'info', {
        player = winner,
        reward = reward,
        coords = {
            x = winnerCoords.x,
            y = winnerCoords.y,
            z = winnerCoords.z
        }
    })
end)

RegisterNetEvent('sl_treasurehunt:giveVehicle', function(model, plate, props)
    local FRAMEWORK <const> = sl.loadBridge()

    FRAMEWORK.addVehicle(source, model, props, plate)
    
    LOGS.send(WEBHOOKS.win, T['log_vehicle_reward'], T['log_vehicle_reward_desc'], 'info', {
        player = source,
        reward = {
            type = 'vehicle',
            label = model,
            amount = plate
        }
    })
end)
