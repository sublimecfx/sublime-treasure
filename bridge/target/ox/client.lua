---@param entity number
---@param label string
---@param icon string
---@param distance number
---@param action function
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