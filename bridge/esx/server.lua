local ESX = exports['es_extended']:getSharedObject()

---@param id number
---@param groups table
---@return string | false
local function getGroup(id, groups)
    if not id then return false end

    local player = ESX.GetPlayerFromId(id)

    if not player then return false end

    local group = player.getGroup()

    if not group then return false end
    
    return group
end

---@param id number
---@param message string
---@param type string
---@param duration number
local function notify(id, message, type, duration)
    if not id or not message then return end

    local player = ESX.GetPlayerFromId(id)

    if not player then return end

    return player.showNotification(message, type, duration)
end

return {
    getGroup = getGroup,
    notify = notify
}