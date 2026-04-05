fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'no_ped_zones'
description 'PolyZone-based ped suppression'
author 'Skeezle'
version '1.2.0'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',  -- optional if you ever need it
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client.lua',                -- your script
}
