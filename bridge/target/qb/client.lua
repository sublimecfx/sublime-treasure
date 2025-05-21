---@param entity number
---@param label string
---@param icon string
---@param distance number
---@param action function
local function create(entity, label, icon, distance, action)
    return exports['qb-target']:AddTargetEntity(entity, {
        options = {
            {
                icon = icon,
                label = label,
                action = action
            }
        },
        distance = distance
    })
end

return {
    create = create
}