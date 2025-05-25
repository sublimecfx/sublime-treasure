---@param dict string
local function loadAnimation(dict)
    if not dict or HasAnimDictLoaded(dict) then return end

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

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
        Wait(1000) -- Attendre que le ped se tourne
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