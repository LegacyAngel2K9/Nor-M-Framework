-- Nor-M Framework Configuration
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

Config = {}

-- Database Configuration
Config.Database = {
    UseMySQL = true,  -- Set to false to use SQLite instead of MySQL
    Host = "localhost",
    Username = "root",
    Password = "password",
    DatabaseName = "norm_framework",
    Port = 3306
}

-- General Settings
Config.FrameworkName = "Nor-M Framework"
Config.DebugMode = false  -- Enable to show debug messages

-- Player Settings
Config.MaxCharacters = 5  -- Max number of characters per player
Config.StartingCash = 5000  -- Amount of cash new players start with
Config.StartingBank = 15000 -- Amount of money in bank for new players

-- Voice System
Config.Voice = {
    UsePMAVoice = true, -- Set to false if using a different voice system
    DefaultRange = 15.0 -- Default voice range
}

-- Vehicle System
Config.Vehicle = {
    FuelEnabled = true, -- Enable or disable fuel system
    SeatbeltEnabled = true, -- Enable or disable seatbelt system
    DamageSync = true -- Enable or disable synced vehicle damage
}

-- Job Settings
Config.Jobs = {
    EnablePolice = true,
    EnableEMS = true,
    EnableMechanic = false -- Change to true if mechanic job is added
}

-- Admin Settings
Config.Admin = {
    AdminMenuEnabled = true,
    StaffChatEnabled = true,
    AntiCheat = true
}

-- Logging System
Config.Logging = {
    EnableLogging = true,
    LogToDiscord = false,
    WebhookURL = "YOUR_DISCORD_WEBHOOK_HERE" -- If LogToDiscord is true, set the webhook URL
}

-- Weather & Time Settings
Config.Weather = {
    DefaultWeather = "CLEAR",
    DynamicWeather = true
}

Config.Time = {
    UseRealTime = false,
    DefaultHour = 12,
    DefaultMinute = 0
}

-- Other Features
Config.Features = {
    EnableGraffiti = true,
    EnableCustomPlates = true,
    EnableDarts = true,
    EnablePool = true
}

return Config
