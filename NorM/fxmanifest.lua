-- Nor-M Framework | FXManifest
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

fx_version 'cerulean'
game 'gta5'

author 'Legacy DEV Team'
description 'Nor-M Framework - Custom Lua-based FiveM Framework'
version '1.0.0'

shared_scripts {
    'config/config.lua'
}

client_scripts {
    'core/client/ui.lua',  -- UI control script (NEW)
    'core/client/player.lua',
    'core/client/jobs.lua',
    'core/client/vehicles.lua',
    'core/client/voice.lua',
    'core/client/death.lua',
    'core/client/utils.lua',
    'modules/ui/menu.lua',
    'modules/vehicles/control.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Ensure you have MySQL installed
    'core/server/ui.lua',  -- UI control script (NEW)
    'core/server/database.lua',
    'core/server/commands.lua',
    'core/server/jobs.lua',
    'core/server/vehicles.lua',
    'core/server/anti-cheat.lua',
    'modules/admin/tools.lua',
    'modules/chat/chat.lua',
    'modules/ems/system.lua',
    'modules/police/system.lua'
}

ui_page 'core/client/ui/index.html' -- Modify this if using custom UI

files {
    'core/client/ui/index.html',
    'core/client/ui/style.css',
    'core/client/ui/script.js'
}

dependencies {
    'oxmysql' -- MySQL support (if used)
}
