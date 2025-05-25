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
        -- Utiliser un intervalle plus long pour vérifier la fin de l'événement
        -- 10 secondes est excessif pour une simple vérification de temps
        while sl.treasureEvent do
            if os.time() >= sl.treasureEventEndTime then
                sl.treasureEvent = false
                sl.treasureEventZone = nil
                sl.treasureEventStartTime = nil
                sl.treasureEventEndTime = nil
                sl.treasureCoords = nil
                break
            end

            Wait(30000) -- Vérifier toutes les 30 secondes au lieu de 10 secondes
        end
    end)

    local treasureCoords = random(ZONE.treasureSpawn)
    sl.treasureCoords = treasureCoords

    TriggerClientEvent('sl_treasurehunt:startEvent', -1, ZONE, treasureCoords)
end

local function stopTreasureEvent()
    TriggerClientEvent('sl_treasurehunt:stopEvent', -1)

    sl.treasureEvent = false
    sl.treasureEventZone = nil
    sl.treasureEventStartTime = nil
    sl.treasureEventEndTime = nil
    sl.treasureCoords = nil
end

---@param t table
---@return any
local function randomWithChance(t)
    local totalChance = 0

    for i = 1, #t do
        totalChance = totalChance + t[i].chance
    end
    
    local random = math.random(1, totalChance)
    local currentChance = 0
    
    for i = 1, #t do
        currentChance = currentChance + t[i].chance
        if random <= currentChance then
            return t[i]
        end
    end
end

sl.startTreasureEvent = startTreasureEvent
sl.stopTreasureEvent = stopTreasureEvent
sl.randomWithChance = randomWithChance