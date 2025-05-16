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

return {
    getGroup = getGroup
}