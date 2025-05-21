---@param entity number
---@param options table
local function create(entity, label, icon, distance, action)
    return exports.ox_target:addLocalEntity(entity, {
        label = label,
        icon = icon,
        onSelect = action,
        distance = distance
    })
end

return {
    create = create
}