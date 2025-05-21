local PERMS <const> = sl.loadConfig('perms')

---@param id any license or source
---@return boolean
local function hasPermission(id)
    if not id then return false end

    local FRAMEWORK <const> = sl.loadBridge()

    if type(id) == 'number' then
        local group = FRAMEWORK.getGroup(id, PERMS.groups)

        if not group then return false end

        if PERMS.groups[group] then
            return true
        end

        local license = GetPlayerIdentifierByType(id, 'license')

        if not license then return false end

        return PERMS.licenses[license]
    end
    
    if type(id) == 'string' then
        return PERMS.licenses[id]
    end

    return false
end

return hasPermission