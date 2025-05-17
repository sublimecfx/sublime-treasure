local CONFIG <const> = sl.loadConfig('main')
local ZONES <const> = sl.loadConfig('zones')
local T <const> = sl.loadLocale()
local framework = sl.loadBridge()

local function randomZone()
    return ZONES[math.random(1, #ZONES)]
end

local function randomClue()
    local index = math.random(1, #sl.treasureEventClues)
    local clue = sl.treasureEventClues[index]

    table.remove(sl.treasureEventClues, index)

    return clue
end

---@param clue string
local function sendClueToAllPlayers(clue)
    for i = 1, #GetPlayers() do
        local playerId = i

        if playerId then
            framework.notify(playerId, T['clue'] .. ': ' .. clue, 'info', 10000)
        end
    end
end

local function startTreasureEvent()
    if sl.treasureEvent then return warn(T['start_failed_already_started']) end

    sl.treasureEvent = true
    sl.treasureEventStartTime = os.time()
    sl.treasureEventEndTime = sl.treasureEventStartTime + CONFIG.eventDuration

    local ZONE <const> = randomZone()

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
                break
            end

            Wait(CONFIG.clueSentTime)

            local CLUE <const> = randomClue()

            sendClueToAllPlayers(CLUE)
        end
    end)

    TriggerClientEvent('sl_treasurehunt:startEvent', -1, ZONE)
end

sl.startTreasureEvent = startTreasureEvent