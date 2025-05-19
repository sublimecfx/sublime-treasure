local CONFIG <const> = sl.loadConfig('main')
local T <const> = sl.loadLocale()

---@param zone table
---@param treasureEntity table
local function startTreasureEvent(zone, treasureEntity)
    sl.treasureEvent = true

    local zone = zone
    local treasureEntity = treasureEntity

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
end

sl.startTreasureEvent = startTreasureEvent