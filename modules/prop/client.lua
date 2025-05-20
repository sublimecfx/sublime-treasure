---@param model string
---@param coords vector3
---@param data table
---@return number
local function create(model, coords, data)
    local prop = nil

    if model then
        prop = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
    end

    if coords.w then 
        SetEntityHeading(prop, coords.w)
    end

    if data.frozen then
        FreezeEntityPosition(prop, true)
    end

    if not data.collision then
        SetEntityCollision(prop, false, false)
    end

    if data.invulnerable then
        SetEntityInvincible(prop, true)
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