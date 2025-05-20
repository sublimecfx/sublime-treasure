---@param entity number
---@param duration number
---@param effects table
local function play(entity, effects)
    RequestNamedPtfxAsset(effects.asset)
    while not HasNamedPtfxAssetLoaded(effects.asset) do
        Wait(0)
    end

    for i = 1, effects.amount do
        UseParticleFxAssetNextCall(effects.asset)
        StartParticleFxNonLoopedOnEntity(effects.name, 
            entity,
            0.0, 0.0, -5.0,
            0.0, 0.0, 0.0,
            2.0, false, false, false)
        Wait(effects.duration)
    end
end

return {
    play = play
}