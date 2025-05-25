local SERVICE <const> = (IsDuplicityVersion() and 'server') or 'client'

---@class Sublime
---@field service string<"client" | "server">
---@field resourceName string<"sublime-treasure">
---@field resourceVersion string
---@field isResourceStarted fun(resource: string): boolean
---@field require fun(path: string): any
---@field loadBridge fun(): any
---@field loadConfig fun(name: string): any
---@field loadLocale fun(): any
---@field loadTarget fun(): any
local sl = {}

local module_loaded = {}

---@param path string
---@return any
local function loadModule(path)
    if module_loaded[path] then
        return module_loaded[path]
    end

    local module_path = ("%s.lua"):format(path)
    local module_file = LoadResourceFile(GetCurrentResourceName(), module_path)
    if not module_file then
        error("Failed to find module: "..path)
    end

    module_loaded[path] = load(module_file)()
    return module_loaded[path]
end

---@param path string
---@return any
local function callModule(path)
    path = path:gsub('%.', '/')
    local module = loadModule(path)
    if not module then
        return error("Failed to load module: "..path)
    end
    return module
end

---@param resource string
---@return boolean
local function isResourceStarted(resource)
    if not resource or type(resource) ~= 'string' then return end

    return GetResourceState(resource) == 'started'
end

---@param name string
---@return table
local function loadConfig(name)
    return callModule('configs.' .. name)
end

local function loadBridge()
    if isResourceStarted('es_extended') then
        return callModule('bridge.framework.esx.' .. SERVICE)
    elseif isResourceStarted('qb-core') then
        return callModule('bridge.framework.qb.' .. SERVICE)
    else
        return callModule('bridge.framework.custom.' .. SERVICE)
    end
end

local function loadTarget()
    if isResourceStarted('ox_target') then
        return callModule('bridge.target.ox.' .. SERVICE)
    elseif isResourceStarted('qb-target') then
        return callModule('bridge.target.qb.' .. SERVICE)
    else
        return callModule('bridge.target.custom.' .. SERVICE)
    end
end

local function loadLocale()
    local LOCALE <const> = loadConfig('locale')

    if not LOCALE then return warn('Failed to load locale.') end

    return callModule('locales.' .. LOCALE)
end

local METADATA <const> = {
    service = SERVICE,
    resourceName = GetCurrentResourceName(),
    resourceVersion = GetResourceMetadata(GetCurrentResourceName(), 'version'),
    isResourceStarted = isResourceStarted,
    require = callModule,
    loadBridge = loadBridge,
    loadConfig = loadConfig,
    loadLocale = loadLocale,
    loadTarget = loadTarget
}

setmetatable(sl, {
    __index = METADATA,
    __newindex = function(self, key, value)
        rawset(self, key, value)
    end
})

_ENV.sl = sl

-- Ajouter cette fonction pour mettre en cache les configurations
local configCache = {}
function sl.loadConfig(name)
    if configCache[name] then return configCache[name] end
    
    local config = LoadResourceFile(GetCurrentResourceName(), ('configs/%s.lua'):format(name))
    if not config then return {} end
    
    local chunk, err = load(config, ('configs/%s.lua'):format(name), 't')
    if not chunk then return {} end
    
    local success, result = pcall(chunk)
    if not success then return {} end
    
    configCache[name] = result
    return result
end

-- Même principe pour les locales
local localeCache = nil
function sl.loadLocale()
    if localeCache then return localeCache end
    
    local locale = sl.loadConfig('locale')
    local localeName = locale.locale or 'en'
    
    local localeFile = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.lua'):format(localeName))
    if not localeFile then return {} end
    
    local chunk, err = load(localeFile, ('locales/%s.lua'):format(localeName), 't')
    if not chunk then return {} end
    
    local success, result = pcall(chunk)
    if not success then return {} end
    
    localeCache = result
    return result
end