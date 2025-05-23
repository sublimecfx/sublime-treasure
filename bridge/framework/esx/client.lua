local ESX = exports['es_extended']:getSharedObject()

---@param vehicle number
---@return table | nil
local function getVehicleProperties(vehicle)
    if not vehicle then return end

    return ESX.Game.GetVehicleProperties(vehicle)
end

return {
    getVehicleProperties = getVehicleProperties
}