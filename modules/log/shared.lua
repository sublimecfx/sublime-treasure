local LOG <const> = sl.require('configs.log')

---@param type 'debug' | 'info'
---@param message string
local function log(type, message)
    if not LOG.enabled then return end

    if LOG.debug and type == 'debug' then
        print(('[^5%s:debug^7] %s'):format(sl.resourceName, message))
    end

    if LOG.info and type == 'info' then
        print(('[^5%s:info^7] %s'):format(sl.resourceName, message))
    end
end

return log