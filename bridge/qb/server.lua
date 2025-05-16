local QBCore = exports['qb-core']:GetCoreObject()

---@param id number
---@param groups table
---@return string | false
local function getGroup(id, groups)
    if not id then return false end

    for k, v in pairs(groups) do
        if IsPlayerAceAllowed(id, 'qbcore.' .. k) then
            return k
        end
    end

    return false
end

---@param id number
---@param message string
---@param type string
---@param duration number
local function notify(id, message, type, duration)
    if not id or not message then return end

    local player = QBCore.Functions.GetPlayer(id)

    if not player then return end

    return player.Functions.Notify(message, type, duration)
end


return {
    getGroup = getGroup,
    notify = notify
}
