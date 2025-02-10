-- Nor-M Framework | Basic Anti-Cheat System (Server-Side)
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

-- Function: Detect Blacklisted Weapons
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for _, playerId in ipairs(GetPlayers()) do
            local playerPed = GetPlayerPed(playerId)
            for _, weapon in ipairs(blacklistedWeapons) do
                if HasPedGotWeapon(playerPed, GetHashKey(weapon), false) then
                    RemoveWeaponFromPed(playerPed, GetHashKey(weapon))
                    DropPlayer(playerId, "Detected using blacklisted weapon: " .. weapon)
                end
            end
        end
    end
end)

-- Function: Detect Health/Armor Hacks
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for _, playerId in ipairs(GetPlayers()) do
            local playerPed = GetPlayerPed(playerId)
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
end)

-- Function: Detect Vehicle Spawning Hacks
RegisterServerEvent("norm:checkVehicleSpawn")
AddEventHandler("norm:checkVehicleSpawn", function(vehicleModel)
    local _source = source
    local playerName = GetPlayerName(_source)
    if not IsModelInCdimage(vehicleModel) then
        DropPlayer(_source, "Detected spawning unauthorized vehicles.")
    end
end)

-- Function: Detect Rapid Fire (Weapon Damage Modifiers)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for _, playerId in ipairs(GetPlayers()) do
            local playerPed = GetPlayerPed(playerId)
            local weapon = GetSelectedPedWeapon(playerPed)
            local damage = GetWeaponDamage(weapon)

            if damage > 100 then
                DropPlayer(playerId, "Detected weapon damage modification (Rapid Fire).")
            end
        end
    end
end)

-- Function: Notify Admins (Expand if needed)
function NotifyAdmins(message)
    print("[ANTI-CHEAT] " .. message) -- Modify to notify admins properly
end
