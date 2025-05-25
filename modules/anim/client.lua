-- Ajouter un cache pour les dictionnaires d'animation déjà chargés
local loadedDicts = {}

---@param dict string
local function loadAnimation(dict)
    if not dict then return end
    if loadedDicts[dict] then return end
    if HasAnimDictLoaded(dict) then
        loadedDicts[dict] = true
        return
    end

    RequestAnimDict(dict)
    
    -- Utiliser un timeout pour éviter les boucles infinies
    local timeout = GetGameTimer() + 5000 -- 5 secondes max
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then
            print("^1[ERROR] Failed to load animation dictionary: " .. dict)
            return
        end
        Wait(10) -- Attendre 10ms au lieu de 0ms
    end
    
    loadedDicts[dict] = true
end

-- Nettoyer les dictionnaires périodiquement
CreateThread(function()
    while true do
        Wait(60000) -- Toutes les minutes
        for dict in pairs(loadedDicts) do
            if HasAnimDictLoaded(dict) then
                RemoveAnimDict(dict)
                loadedDicts[dict] = nil
            end
        end
    end
end)

---@param playerPed number
local function stop(playerPed)
    if not playerPed then return end

    return ClearPedTasks(playerPed)
end

---@param playerPed number
---@param entity number | nil
---@param animation table
local function play(playerPed, entity, animation)
    if not playerPed or not animation then return end

    local dict = animation.dict
    local anim = animation.anim
    local flags = animation.flags 
    local duration = animation.duration

    if not dict or not anim then
        return
    end
    
    loadAnimation(dict)
    
    if entity then
        TaskTurnPedToFaceEntity(playerPed, entity, 1000)
        Wait(1000) 
    end
    
    -- flags communs: 1 (Loop), 16 (EnablePlayerControl), 32 (Cancellable), 48 (Loop + EnablePlayerControl)
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, animation.taskDuration or -1, flags or 0, 0, false, false, false)

    if duration then 
        CreateThread(function()
            Wait(duration)
            if DoesEntityExist(playerPed) then 
                stop(playerPed)
            end
        end)
    end
end

return {
    play = play,
    stop = stop
}