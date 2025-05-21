---@param entity number
---@param options table
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