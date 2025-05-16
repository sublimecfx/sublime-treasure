local PERMS <const> = sl.loadConfig('perms')

---@param id any license or source
---@return boolean
local function hasPermission(id)
    if not id then return false end

    print(id)

    local framework = sl.loadBridge()

    if type(id) == 'number' then
        local group = framework.getGroup(id, PERMS.groups)

        if not group then return false end

        print(group)

        return PERMS.groups[group]
    end
    
    if type(id) == 'string' then
        return PERMS.licenses[id]
    end

    return false
end

return hasPermission