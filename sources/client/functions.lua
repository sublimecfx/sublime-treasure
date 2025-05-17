local CONFIG <const> = sl.loadConfig('main')
local T <const> = sl.loadLocale()

---@param coords vector3
---@param sprite number
---@param scale number
---@param colour number
---@param name string
---@return number
local function addBlip(coords, sprite, scale, colour, name)
    if not coords or not sprite or not scale or not colour or not name then return warn('addBlip: missing args') end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    return blip
end

---@param coords vector3
---@param radius number
---@param colour number
---@param alpha number
---@return number
local function addBlipZone(coords, radius, colour, alpha)
    if not coords or not radius or not colour or not alpha then return warn('addBlipZone: missing args') end

    print(coords, radius, colour, alpha)

    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, tonumber(radius))

    SetBlipColour(blip, colour)
    SetBlipAlpha(blip, alpha)

    print(blip)
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
