local CONFIG <const> = sl.loadConfig('main')
local T <const> = sl.loadLocale()

---@param coords vector3
---@param sprite number
---@param scale number
---@param colour number
---@param name string
---@return number
local function addBlip(coords, sprite, scale, colour, name)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, (sprite or 1))
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, (scale or 1.0))
    SetBlipColour(blip, (colour or 1))
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString((name or 'Treasure Hunt'))
    EndTextCommandSetBlipName(blip)

    return blip
end

---@param coords vector3
---@param radius number
---@param colour number
---@param alpha number
---@return number
local function addBlipZone(coords, radius, colour, alpha)
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, tonumber(radius))

    SetBlipColour(blip, (colour or 1))
    SetBlipAlpha(blip, (alpha or 125))

    return blip
end

---@param blip number
local function removeBlipZone(blip)
    if not blip then return warn('removeBlipZone: missing args') end

    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

---@param zone table
local function startTreasureEvent(zone)
    sl.treasureEvent = true

    local zone = zone

    print(json.encode(zone, {indent = true}))

    if CONFIG.blip.enabled then
        local blipZone = addBlipZone(zone.center, zone.radius, CONFIG.blip.colour, CONFIG.blip.alpha)
        local blip = addBlip(zone.center, CONFIG.blip.sprite, CONFIG.blip.scale, CONFIG.blip.colour, T['blip_name'])

        sl.treasureEventBlipZone = blipZone
        sl.treasureEventBlip = blip
    end
end

sl.startTreasureEvent = startTreasureEvent
