local T <const> = sl.loadLocale()

-- Ajouter une file d'attente pour les webhooks
local webhookQueue = {}
local processingQueue = false

---@param message string
---@param type 'info' | 'cheat'
---@param data table
local function send(webhook, title, message, type, data)
    if not webhook or not message then return warn(T['invalid_webhook_or_message']) end
    
    local color = type == 'cheat' and 15158332 or 3987431
    
    local fields = {}
    
    if data and data.player then
        local player = data.player
        local steam = (GetPlayerIdentifierByType(player, 'steam') or 'N/A')
        local license = (GetPlayerIdentifierByType(player, 'license') or 'N/A')
        local discord = ('<@' .. (GetPlayerIdentifierByType(player, 'discord') or 'N/A'):gsub('discord:', '') .. '>')
        local ip = (GetPlayerEndpoint(player) or 'N/A')
        
        table.insert(fields, {
            name = 'Player Information',
            value = string.format('**Name:** %s\n**ID:** %s\n**Steam:** %s\n**License:** %s\n**Discord:** %s\n**IP:** %s',
                GetPlayerName(player),
                player,
                steam,
                license,
                discord,
                ip
            ),
            inline = false
        })
    end
    
    if data and data.reward then
        local reward = data.reward
        table.insert(fields, {
            name = 'Reward Information',
            value = string.format('**Type:** %s\n**Name:** %s\n**Amount:** %s',
                reward.type,
                reward.label,
                reward.amount or '1'
            ),
            inline = true
        })
    end
    
    if data and data.coords then
        table.insert(fields, {
            name = 'Location',
            value = string.format('**X:** %.2f\n**Y:** %.2f\n**Z:** %.2f',
                data.coords.x,
                data.coords.y,
                data.coords.z
            ),
            inline = true
        })
    end
    
    table.insert(fields, {
        name = 'Server Information',
        value = string.format('**Players:** %d/%d\n**Uptime:** %s',
            #GetPlayers(),
            GetConvarInt('sv_maxclients', 32),
            os.date('%H:%M:%S')
        ),
        inline = true
    })

    local embed = {
        {
            ['title'] = (title or 'Logs'),
            ['description'] = message,
            ['color'] = color,
            ['fields'] = fields,
            ["footer"] = {
                ["text"] = 'Sublime Store (https://discord.gg/4Y3PWwfHxq)',
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1371568229310402560/1375552203665702922/Logo_Sublime10.png?ex=68321a51&is=6830c8d1&hm=9b6d9193a8b47d8366752b2d8c80bde51b571f0098b64d6b539c3621ac7ca645&'
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    -- Ajouter à la file d'attente au lieu d'envoyer immédiatement
    table.insert(webhookQueue, {
        webhook = webhook,
        payload = json.encode({embeds = embed})
    })
    
    -- Démarrer le traitement de la file d'attente si ce n'est pas déjà fait
    if not processingQueue then
        processingQueue = true
        processWebhookQueue()
    end
end

-- Fonction pour traiter la file d'attente
local function processWebhookQueue()
    CreateThread(function()
        while #webhookQueue > 0 do
            local item = table.remove(webhookQueue, 1)
            PerformHttpRequest(item.webhook, function(err, text, headers) end, 'POST', item.payload, {['Content-Type'] = 'application/json'})
            Wait(1000) -- Attendre 1 seconde entre chaque envoi pour éviter le rate limiting
        end
        processingQueue = false
    end)
end

return {
    send = send
}