local CONFIG <const> = sl.loadConfig('main')

---@param text string
local function displayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(1, false, false, 0)
end


local PROP <const> = sl.require('modules.prop.client')
local T <const> = sl.loadLocale()

local function openTreasure()
    local playerPed = PlayerPedId()
    local ANIM <const> = sl.require('modules.anim.client')
    ANIM.play(playerPed, sl.treasureEntity, CONFIG.animations.open)

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

    if CONFIG.blip.enabled then
        local BLIP <const> = sl.require('modules.blip.client')
        sl.treasureEventBlipZone = BLIP.addZone(zone.center, {
            colour = CONFIG.blip.colour,
            alpha = CONFIG.blip.alpha
        }, zone.radius)

        sl.treasureEventBlip = BLIP.add(zone.center, {
            sprite = CONFIG.blip.sprite,
            scale = CONFIG.blip.scale,
            colour = CONFIG.blip.colour,
            name = T['blip_name']
        })
    end

    CreateThread(function()
        local TARGET <const> = sl.loadTarget()
        local KEY <const> = CONFIG.target.enabled and '~INPUT_CHARACTER_WHEEL~' or '~INPUT_PICKUP~'
        local treasureCoordsVec3 = vec3(treasureCoords.x, treasureCoords.y, treasureCoords.z)
        local checkDistance = 0
        local lastDistance = 999.0

        while sl.treasureEvent do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local treasureDistance = #(playerCoords - treasureCoordsVec3)

            local interval = treasureDistance > 50.0 and 5000 or (treasureDistance > 3.0 and 1000 or 0)

            if treasureDistance <= 50.0 then
                if not sl.treasureEntity then
                    sl.treasureEntity = PROP.create(CONFIG.treasureEntity.model.closed, treasureCoords, CONFIG.treasureEntity.data)
                end

                if treasureDistance <= 3.0 then
                    local entityCoords = GetEntityCoords(sl.treasureEntity)
                    local offset = GetEntityHeightAboveGround(sl.treasureEntity) + 1.0
                    
                    displayHelpText(T['treasure_pickup']:format(KEY))
                    SetFloatingHelpTextStyle(0, 2, 2, 0, 3, 0)
                    SetFloatingHelpTextWorldPosition(0, entityCoords.x, entityCoords.y, entityCoords.z + offset)

                    if CONFIG.target.enabled then 
                        if not sl.targetCreated then
                            local target = TARGET.create(sl.treasureEntity, CONFIG.target.label, CONFIG.target.icon, CONFIG.target.distance, openTreasure)
                            sl.targetCreated = true
                        end
                    else
                        if IsControlJustPressed(0, 51) then
                            openTreasure()
                            break
                        end
                    end
                end
            elseif sl.treasureEntity then
                PROP.delete(sl.treasureEntity)
                sl.treasureEntity = nil
                sl.targetCreated = false
            end

            Wait(interval)
        end
    end)
end

local function stopTreasureEvent()
    sl.treasureEvent = false
    sl.treasureCoords = nil
    sl.targetCreated = false

    if CONFIG.blip.enabled then
        local BLIP <const> = sl.require('modules.blip.client')
        BLIP.remove(sl.treasureEventBlip)
        BLIP.remove(sl.treasureEventBlipZone)
        sl.treasureEventBlip = nil
        sl.treasureEventBlipZone = nil
    end

    if sl.treasureEntity then
        PROP.delete(sl.treasureEntity)
        sl.treasureEntity = nil
    end
end

sl.startTreasureEvent = startTreasureEvent
sl.stopTreasureEvent = stopTreasureEvent
