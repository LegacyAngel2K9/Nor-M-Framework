-- Nor-M Framework | Anti-Cheat System (Client-Side)
-- Author: Legacy DEV Team

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000) -- Every 10 seconds, check for blacklisted weapons
        local playerPed = PlayerPedId()
        local weapons = {}

        for _, weapon in ipairs({
            "WEAPON_RAILGUN", "WEAPON_MINIGUN", "WEAPON_GRENADELAUNCHER",
            "WEAPON_RPG", "WEAPON_HOMINGLAUNCHER", "WEAPON_GRENADE",
            "WEAPON_PROXMINE", "WEAPON_PIPEBOMB", "WEAPON_STICKYBOMB",
            "WEAPON_MOLOTOV"
        }) do
            if HasPedGotWeapon(playerPed, GetHashKey(weapon), false) then
                table.insert(weapons, weapon)
            end
        end

        if #weapons > 0 then
            TriggerServerEvent("norm:checkWeapons", weapons)
        end
    end
end)
