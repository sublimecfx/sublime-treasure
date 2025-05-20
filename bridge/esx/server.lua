local ESX = exports['es_extended']:getSharedObject()

---@param id number
---@param groups table
---@return string | false
local function getGroup(id, groups)
    if not id then return false end

    local player = ESX.GetPlayerFromId(id)

    if not player then return false end

    local group = player.getGroup()

    if not group then return false end
    
    return group
end

---@param id number
---@param message string
---@param type string
---@param duration number
local function notify(id, message, type, duration)
    if not id or not message then return end

    local player = ESX.GetPlayerFromId(id)

    if not player then return end

    return player.showNotification(message, type, duration)
end

---@param id number
---@param name string
---@param amount number
local function addItem(id, name, amount)
    if not id or not name or not amount then return end
end

---@param id number
---@param amount number
local function addMoney(id, amount)
    if not id or not amount then return false end
end

---@param id number
---@param name string
---@param amount number
local function addWeapon(id, name, amount)
    if not id or not name or not amount then return false end
end

---@param id number
---@param name string
---@param amount number
local function addVehicle(id, name, amount)
    if not id or not name or not amount then return false, nil, nil end
end

return {
    getGroup = getGroup,
    notify = notify,
    addItem = addItem,
    addMoney = addMoney,
    addWeapon = addWeapon,
    addVehicle = addVehicle
}