fx_version 'cerulean'
games {'gta5'};
lua54 'yes'


shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/**/*.lua',
}
 

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'client/*.lua'
}

server_script {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'server/*.lua'
}

dependencies {
	'es_extended',
	'ox_inventory',
	'ox_lib',
	'esx_society'
}
