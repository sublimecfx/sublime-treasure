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

    local player = ESX.GetPlayerFromId(id)

    if not player then return end

    return player.addInventoryItem(name, amount)
end

---@param id number
---@param amount number
local function addMoney(id, amount)
    if not id or not amount then return false end

    local player = ESX.GetPlayerFromId(id)

    if not player then return false end

    return player.addMoney(amount)
end

---@param id number
---@param name string
local function addWeapon(id, name)
    if not id or not name then return false end

    local player = ESX.GetPlayerFromId(id)

    if not player then return end

    return player.addInventoryItem(name, 1)
end

---@param id number
---@param model string
---@param props table
local function addVehicle(id, model, props, plate)
    if not id or not model or not props then return false, nil, nil end

    local license = GetPlayerIdentifierByType(id, 'license')

    if not license then return false end

    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {
        license,
        plate,
        json.encode(props)
    }, function (result)
        if result then
            return true
        end

        return false
    end)
end

return {
    getGroup = getGroup,
    notify = notify,
    addItem = addItem,
    addMoney = addMoney,
    addWeapon = addWeapon,
    addVehicle = addVehicle
}