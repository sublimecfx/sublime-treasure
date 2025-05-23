fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Atoshi (Sublime Store)'
description 'An automatic and legal event system that regularly triggers an immersive treasure hunt in the city or rural areas.'
version '1.0.0'
discord 'https://discord.gg/4Y3PWwfHxq'
repository 'https://github.com/sublimecfx/sublime-treasure'

files {
    'locales/*.lua',
    'configs/*.lua',
    'modules/**/shared.lua',
    'modules/**/server.lua',
    'modules/**/client.lua',
    'bridge/framework/**/server.lua',
    'bridge/framework/**/client.lua',
    'bridge/target/**/client.lua'
}

shared_scripts {
    'init.lua'
}

client_scripts {
    'sources/client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sources/server/*.lua'
}

dependencies {
    'oxmysql'
}