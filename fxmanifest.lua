fx_version 'cerulean'
games {'gta5'};
lua54 'yes'


shared_scripts {
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
    "config.lua",
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/**/*.lua",
}
 

client_scripts {
    'client/*.lua'
}

server_script {
    'server/*.lua'
}

dependencies {
	'es_extended',
	'ox_inventory',
	'esx_society'
}