---@param text string
local function displayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(1, false, false, 0)
end

---@param coords vector3
local function playTreasureEffects(coords)
    RequestNamedPtfxAsset("scr_xs_celebration")
    while not HasNamedPtfxAssetLoaded("scr_xs_celebration") do
        Wait(0)
    end

    for i = 1, 5 do
        UseParticleFxAssetNextCall("scr_xs_celebration")
        StartParticleFxNonLoopedAtCoord("scr_xs_confetti_burst", 
            coords.x + math.random(-1.0, 1.0), 
            coords.y + math.random(-1.0, 1.0), 
            coords.z + math.random(0.0, 1.0), 
            0.0, 0.0, 0.0, 2.0, false, false, false)
        Wait(200)
    end
end

local function openTreasure()
    local PROP <const> = sl.require('modules.prop.client')
    local CONFIG <const> = sl.loadConfig('main')

    playTreasureEffects(sl.treasureCoords)

    PROP.delete(sl.treasureEntity)
    sl.treasureEntity = nil

    local newProp = PROP.create(CONFIG.treasureEntity.model.opened, sl.treasureCoords, CONFIG.treasureEntity.data)
    sl.treasureEntity = newProp
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
        while sl.treasureEvent do
            local interval = 5000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local tcv3 = vec3(treasureCoords.x, treasureCoords.y, treasureCoords.z)
            local treasureDistance = #(playerCoords - tcv3)
            local PROP <const> = sl.require('modules.prop.client')

            if treasureDistance <= 50.0 then
                interval = 1000

                if not sl.treasureEntity then
                    local prop = PROP.create(CONFIG.treasureEntity.model.closed, treasureCoords, CONFIG.treasureEntity.data)
                    sl.treasureEntity = prop
                end

                if treasureDistance <= 3.0 then
                    interval = 0
                    displayHelpText(T['treasure_found'])
                    SetFloatingHelpTextStyle(0, 2, 2, 0, 3, 0)
                    local entityCoords = GetEntityCoords(sl.treasureEntity)
                    local offset = GetEntityHeightAboveGround(sl.treasureEntity) + 1.0
                    SetFloatingHelpTextWorldPosition(0, entityCoords.x, entityCoords.y, entityCoords.z + offset)

                    if not CONFIG.target then 
                        if IsControlJustPressed(0, 51) then
                            openTreasure()
                            break
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

sl.startTreasureEvent = startTreasureEvent