fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Atoshi (Sublime Store)'
description 'An automatic and legal event system that regularly triggers an immersive treasure hunt in the city or rural areas.'
version '0.0.1'
discord 'https://discord.gg/sublimestore'
repository 'https://github.com/sublimecfx/sublime-treasure'

files {
    'locales/*.lua',
    'configs/*.lua',
    'modules/**/shared.lua',
    'modules/**/server.lua',
    'modules/**/client.lua',
    'bridge/framework/**/server.lua',
    'bridge/inventory/**/server.lua',
    'bridge/target/**/client.lua'
}

shared_scripts {
    'init.lua'
}

client_scripts {
    'sources/client/*.lua'
}

server_scripts {
    'sources/server/*.lua'
}