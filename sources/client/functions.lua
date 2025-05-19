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
            print('loop')
            local interval = 5000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local treasureDistance = #(playerCoords - sl.treasureCoords)
            local PROP <const> = sl.require('modules.prop.client')

            if treasureDistance <= 10.0 then
                print('loop 2')
                interval = 1000

                if not sl.treasureEntity then
                    local prop = PROP.create(CONFIG.treasureEntity.model.closed, sl.treasureCoords, CONFIG.treasureEntity.data)
                    sl.treasureEntity = prop
                end

                if treasureDistance <= 5.0 then
                    interval = 0
                    print('Treasure found')
                end
            else
                print('loop 3')
                if sl.treasureEntity then
                    PROP.delete(sl.treasureEntity)
                    DeleteObject(sl.treasureEntity)
                    DeleteEntity(sl.treasureEntity)
                    sl.treasureEntity = nil
                end
            end

            Wait(interval)
        end
    end)
end

sl.startTreasureEvent = startTreasureEvent