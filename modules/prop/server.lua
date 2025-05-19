---@param model string
---@param coords vector3
---@param frozen boolean
---@return number
local function create(model, coords, frozen)
    local prop = nil

    if model then
        prop = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    end

    if frozen then
        FreezeEntityPosition(prop, true)
    end

    return prop
end

---@param prop number
local function delete(prop)
    if prop then
        DeleteObject(prop)
    end
end

return {
    create = create,
    delete = delete
}