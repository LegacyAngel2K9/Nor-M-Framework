-- Nor-M Framework | Anti-Cheat System (Server-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local blacklistedWeapons = {
    "WEAPON_RAILGUN",
    "WEAPON_MINIGUN",
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_RPG",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_GRENADE",
    "WEAPON_PROXMINE",
    "WEAPON_PIPEBOMB",
    "WEAPON_STICKYBOMB",
    "WEAPON_MOLOTOV"
}

local maxHealth = 200
local maxArmor = 100

-- Function: Detect Health/Armor Hacks
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for _, playerId in ipairs(GetPlayers()) do
            local playerPed = GetPlayerPed(playerId)
            if DoesEntityExist(playerPed) then
                local health = GetEntityHealth(playerPed)
                local armor = GetPedArmour(playerPed)

                if health > maxHealth then
                    SetEntityHealth(playerPed, maxHealth)
                    DropPlayer(playerId, "Detected exceeding maximum health limit.")
                end

                if armor > maxArmor then
                    SetPedArmour(playerPed, maxArmor)
                    DropPlayer(playerId, "Detected exceeding maximum armor limit.")
                end
            end
        end
    end
end)

-- Function: Detect Vehicle Spawning Hacks
RegisterServerEvent("norm:checkVehicleSpawn")
AddEventHandler("norm:checkVehicleSpawn", function(vehicleModel)
    local _source = source
    if not IsModelInCdimage(vehicleModel) then
        DropPlayer(_source, "Detected spawning unauthorized vehicles.")
    end
end)

-- Function: Move Weapon Detection to Client
RegisterNetEvent("norm:checkWeapons")
AddEventHandler("norm:checkWeapons", function(weapons)
    local _source = source
    for _, weapon in ipairs(weapons) do
        for _, blacklisted in ipairs(blacklistedWeapons) do
            if weapon == blacklisted then
                DropPlayer(_source, "Detected using blacklisted weapon: " .. weapon)
            end
        end
    end
end)

-- Function: Notify Admins (Expand if needed)
function NotifyAdmins(message)
    print("[ANTI-CHEAT] " .. message) -- Modify to notify admins properly
end
