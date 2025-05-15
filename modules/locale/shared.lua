local LANG <const> = sl.loadConfig('locale')
local DATA <const> = sl.require('locales.' .. LANG)

---@param key string
---@return string
local function translate(key)
    if not DATA then 
        warn('Locale file not found for ' .. LANG .. ' locale')
        return key
    end

    local value = DATA[key]

    if not value then 
        warn('Locale key not found for ' .. LANG .. ' locale: ' .. key)
        return key 
    end

    return value
end

return translate