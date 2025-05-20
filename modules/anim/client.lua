---@param dict string
local function loadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

---@param playerPed number
local function stop(playerPed)
    return ClearPedTasks(playerPed)
end

---@param playerPed number
---@param entity number
---@param animation table
local function play(playerPed, entity, animation)
    local dict = animation.dict
    local anim = animation.anim
    
    loadAnimation(dict)
    
    if entity then
        TaskTurnPedToFaceEntity(playerPed, entity, 1000)
        Wait(1000)
    end
    
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    if animation.duration then
        Wait(animation.duration)
        stop(playerPed)
    end
end

return {
    play = play,
    stop = stop
}