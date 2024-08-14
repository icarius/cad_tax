fx_version 'cerulean'
game 'gta5'

author 'cFour'
description 'QBOX Tax System'
version '1.0.1'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/sv_config.lua',
    'server/sv_tax.lua'
}

server_exports {
    'GetCurrentTax',
    'PlayersTax',
    'CarsTax',
    'HousesTax',
}

use_experimental_fxv2_oal 'yes'
lua54 'yes'
