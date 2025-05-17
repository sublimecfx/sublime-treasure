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

local function randomTreasureSpawn(zone)
    return zone.treasureSpawn[math.random(1, #zone.treasureSpawn)]
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

---@param coords vector3
---@param entity table
---@return table
local function createTreasureEntity(coords, entity)
    local treasureEntity = nil

    if entity.model then
        treasureEntity = CreateObject(entity.model.closed, coords.x, coords.y, coords.z, true, true, false)
    end

    if entity.frozen then
        FreezeEntityPosition(treasureEntity, true)
    end

    return {
        entity = treasureEntity,
        coords = coords
    }
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

    local treasureCoords = randomTreasureSpawn(ZONE)
    sl.treasureCoords = treasureCoords

    local treasureEntity = createTreasureEntity(treasureCoords, CONFIG.treasureEntity)
    sl.treasureEntity = treasureEntity.entity

    TriggerClientEvent('sl_treasurehunt:startEvent', -1, ZONE, treasureEntity)
end

sl.startTreasureEvent = startTreasureEvent