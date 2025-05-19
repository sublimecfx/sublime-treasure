---@param coords table
---@param data table
---@return number
local function add(coords, data)
    if not coords then return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, (data.sprite or 1))
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, (data.scale or 1.0))
    SetBlipColour(blip, (data.colour or 1))
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name or "Treasure Hunt")
    EndTextCommandSetBlipName(blip)

    return blip
end

---@param coords table
---@param data table
---@param radius number
---@return number
local function addZone(coords, data, radius)
    if not coords or not radius then return end

    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, radius)

    SetBlipColour(blip, (data.colour or 1))
    SetBlipAlpha(blip, (data.alpha or 125))

    return blip
end

---@param blip number
local function remove(blip)
    if not blip then return end

    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

return {
    add = add,
    addZone = addZone,
    remove = remove
}