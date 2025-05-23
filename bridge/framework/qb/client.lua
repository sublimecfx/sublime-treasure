local QBCore = exports['qb-core']:GetCoreObject()

---@param vehicle number
---@return table | nil
local function getVehicleProperties(vehicle)
    if not vehicle then return end

    return QBCore.Functions.GetVehicleProperties(vehicle)
end

return {
    getVehicleProperties = getVehicleProperties
}