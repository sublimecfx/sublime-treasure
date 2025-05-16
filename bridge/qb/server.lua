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

return {
    getGroup = getGroup
}
