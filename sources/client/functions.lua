---@param text string
local function displayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(1, false, false, 0)
end

local function openTreasure()
    if sl.targetId then
        local TARGET <const> = sl.loadTarget()
        TARGET.remove(sl.targetId)
        sl.targetId = nil
    end

    local CONFIG <const> = sl.loadConfig('main')
    local playerPed = PlayerPedId()

    local ANIM <const> = sl.require('modules.anim.client')
    ANIM.play(playerPed, sl.treasureEntity, CONFIG.animations.open)

    local PROP <const> = sl.require('modules.prop.client')
    PROP.delete(sl.treasureEntity)
    sl.treasureEntity = nil

    local newProp = PROP.create(CONFIG.treasureEntity.model.opened, sl.treasureCoords, CONFIG.treasureEntity.data)
    sl.treasureEntity = newProp

    local EFFECT <const> = sl.require('modules.effect.client')
    EFFECT.play(newProp, CONFIG.effects)

    TriggerServerEvent('sl_treasurehunt:openTreasure')
end

---@param zone table
---@param treasureCoords table
local function startTreasureEvent(zone, treasureCoords)
    sl.treasureEvent = true
    sl.treasureCoords = treasureCoords

    local zone = zone

    local CONFIG <const> = sl.loadConfig('main')
    local T <const> = sl.loadLocale()

    if CONFIG.blip.enabled then
        local BLIP <const> = sl.require('modules.blip.client')

        local blipZone = BLIP.addZone(zone.center, {
            colour = CONFIG.blip.colour,
            alpha = CONFIG.blip.alpha
        }, zone.radius)

        local blip = BLIP.add(zone.center, {
            sprite = CONFIG.blip.sprite,
            scale = CONFIG.blip.scale,
            colour = CONFIG.blip.colour,
            name = T['blip_name']
        })

        sl.treasureEventBlipZone = blipZone
        sl.treasureEventBlip = blip
    end

    CreateThread(function()
        local PROP <const> = sl.require('modules.prop.client')
        local TARGET <const> = sl.loadTarget()

        local key = CONFIG.target and '~INPUT_CHARACTER_WHEEL~' or '~INPUT_PICKUP~'

        while sl.treasureEvent do
            local interval = 5000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local tcv3 = vec3(treasureCoords.x, treasureCoords.y, treasureCoords.z)
            local treasureDistance = #(playerCoords - tcv3)

            if treasureDistance <= 50.0 then
                interval = 1000

                if not sl.treasureEntity then
                    local prop = PROP.create(CONFIG.treasureEntity.model.closed, treasureCoords, CONFIG.treasureEntity.data)
                    sl.treasureEntity = prop
                end

                if treasureDistance <= 3.0 then
                    interval = 0
                    displayHelpText(T['treasure_pickup']:format(key))
                    SetFloatingHelpTextStyle(0, 2, 2, 0, 3, 0)
                    local entityCoords = GetEntityCoords(sl.treasureEntity)
                    local offset = GetEntityHeightAboveGround(sl.treasureEntity) + 1.0
                    SetFloatingHelpTextWorldPosition(0, entityCoords.x, entityCoords.y, entityCoords.z + offset)

                    if not CONFIG.target then 
                        if IsControlJustPressed(0, 51) then
                            openTreasure()
                            break
                        end
                    else
                        if not sl.targetCreated then
                            print('creating target')
                            local label = string.upper(string.sub(T['treasure_pickup'], 9, 9)) .. string.sub(T['treasure_pickup'], 10, -1)
                            local target = TARGET.create(sl.treasureEntity, label, 'fa-solid fa-gem', 3.0, openTreasure)

                            sl.targetCreated = true
                        end
                    end
                end
            else
                if sl.treasureEntity then
                    PROP.delete(sl.treasureEntity)
                    sl.treasureEntity = nil
                end
            end

            Wait(interval)
        end
    end)
end

local function stopTreasureEvent()
    sl.treasureEvent = false
    sl.treasureCoords = nil

    local CONFIG <const> = sl.loadConfig('main')

    if CONFIG.blip.enabled then
        local BLIP <const> = sl.require('modules.blip.client')
        BLIP.remove(sl.treasureEventBlip)
        BLIP.remove(sl.treasureEventBlipZone)

        sl.treasureEventBlip = nil
        sl.treasureEventBlipZone = nil
    end

    if sl.treasureEntity then
        local PROP <const> = sl.require('modules.prop.client')
        PROP.delete(sl.treasureEntity)
        sl.treasureEntity = nil
    end
end

sl.startTreasureEvent = startTreasureEvent
sl.stopTreasureEvent = stopTreasureEvent
