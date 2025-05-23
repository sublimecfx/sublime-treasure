local QBCore = exports['qb-core']:GetCoreObject()

---@param id number
---@param groups table
---@return string | false
local function getGroup(id, groups)
    if not id then return false end

    local license = GetPlayerIdentifierByType(id, 'license')

    if not license then return false end

    for k, v in pairs(groups) do
        if IsPlayerAceAllowed(license, 'qbcore.' .. k) then
            return k
        end
    end

    return false
end

---@param id number
---@param message string
---@param type string
---@param duration number
local function notify(id, message, type, duration)
    if not id or not message then return end

    local player = QBCore.Functions.GetPlayer(id)

    if not player then return end

    return player.Functions.Notify(message, type, duration)
end

---@param id number
---@param name string
---@param amount number
local function addItem(id, name, amount)
    if not id or not name or not amount then return end

    local T <const> = sl.loadLocale()

    return exports['qb-inventory']:AddItem(id, name, amount, false, false, T['blip_name'])
end

---@param id number
---@param amount number
---@return boolean
local function addMoney(id, amount)
    if not id or not amount then return false end

    local player = QBCore.Functions.GetPlayer(id)

    if not player then return false end

    return player.Functions.AddMoney('cash', amount)
end

---@param id number
---@param name string
local function addWeapon(id, name)
    if not id or not name then return false end

    local T <const> = sl.loadLocale()

    return exports['qb-inventory']:AddItem(id, name, 1, false, false, T['blip_name'])
end

---@param id number
---@param model string
---@param props table
---@param plate string
local function addVehicle(id, model, props, plate)
    if not id or not model or not props or not plate then return false end

    local player = QBCore.Functions.GetPlayer(id)
    local cid = player.PlayerData.citizenid
    local license = GetPlayerIdentifierByType(id, 'license')

    if not license then return false end

    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        license,
        cid,
        model,
        GetHashKey(model),
        '{}',
        plate,
        'pillboxgarage',
        0
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
