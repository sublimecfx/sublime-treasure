local T <const> = sl.loadLocale()

---@param t table
---@return any
local function random(t)
    return t[math.random(1, #t)]
end

local function startTreasureEvent()
    if sl.treasureEvent then return warn(T['start_failed_already_started']) end

    local CONFIG <const> = sl.loadConfig('main')

    sl.treasureEvent = true
    sl.treasureEventStartTime = os.time()
    sl.treasureEventEndTime = sl.treasureEventStartTime + CONFIG.eventDuration

    local ZONE <const> = random(sl.loadConfig('zones'))

    if not ZONE then return warn(T['start_failed_no_zone']) end

    sl.treasureEventZone = ZONE

    CreateThread(function()
        while sl.treasureEvent do
            if os.time() >= sl.treasureEventEndTime then
                sl.treasureEvent = false
                sl.treasureEventZone = nil
                sl.treasureEventStartTime = nil
                sl.treasureEventEndTime = nil
                sl.treasureCoords = nil
                break
            end

            Wait(10000)
        end
    end)

    local treasureCoords = random(ZONE.treasureSpawn)
    sl.treasureCoords = treasureCoords

    TriggerClientEvent('sl_treasurehunt:startEvent', -1, ZONE, treasureCoords)
end

sl.startTreasureEvent = startTreasureEvent