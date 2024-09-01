fx_version 'cerulean'
game 'gta5'

author 'cFour & Icarius'
description 'QBOX Tax System'
version '1.1'

ox_libs {
    'locale',
    'cron',
}

files {
    'locales/*.json',
}

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

dependencies {
    'ox_lib',
    'qbx_core',
}

use_experimental_fxv2_oal 'yes'
lua54 'yes'
