local T <const> = sl.loadLocale()

---@param message string
---@param type 'info' | 'cheat'
local function send(webhook, message, type)
    if not webhook or not message then return warn(T['invalid_webhook_or_message']) end
    
end

return {
    send = send
}