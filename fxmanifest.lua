fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Atoshi (Sublime Store)'
description 'An automatic and legal event system that regularly triggers an immersive treasure hunt in the city or rural areas.'
version '0.0.1'
discord 'https://discord.gg/sublimestore'

files {
    'locales/*.lua',
    'configs/*.lua',
    'modules/**/shared.lua',
    'bridge/**/client.lua',
    'bridge/**/server.lua'
}

shared_scripts {
    'init.lua'
}

client_scripts {
}

server_scripts {
}
