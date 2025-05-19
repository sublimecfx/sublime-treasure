local T <const> = sl.loadLocale()

---@param t table
---@return any
local function random(t)
    return t[math.random(1, #t)]
end

local function randomClue()
    if not next(sl.treasureEventClues) then return false end

    local index = math.random(1, #sl.treasureEventClues)
    local clue = sl.treasureEventClues[index]

    table.remove(sl.treasureEventClues, index)

    return clue
end

---@param clue string
local function sendClueToAllPlayers(clue)
    local FRAMEWORK <const> = sl.loadBridge()
    
    for i = 1, #GetPlayers() do
        local playerId = i

        if playerId then
            FRAMEWORK.notify(playerId, T['clue'] .. ': ' .. clue, 'info', 10000)
        end
    end
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
    sl.treasureEventClues = ZONE.clues

    CreateThread(function()
        while sl.treasureEvent do
            if os.time() >= sl.treasureEventEndTime then
                sl.treasureEvent = false
                sl.treasureEventZone = nil
                sl.treasureEventStartTime = nil
                sl.treasureEventEndTime = nil
                sl.treasureEventClues = nil
                sl.treasureCoords = nil
                break
            end

            Wait(CONFIG.clueSentTime)

            local CLUE <const> = randomClue()

            if CLUE then
                sendClueToAllPlayers(CLUE)
            end
        end
    end)

    local treasureCoords = random(ZONE.treasureSpawn)
    sl.treasureCoords = treasureCoords

    TriggerClientEvent('sl_treasurehunt:startEvent', -1, ZONE, treasureCoords)
end

sl.startTreasureEvent = startTreasureEvent