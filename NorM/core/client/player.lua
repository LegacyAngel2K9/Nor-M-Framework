-- Nor-M Framework | Player System (Client-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local PlayerData = {
    id = nil,
    name = "Unknown",
    job = "unemployed",
    cash = 0,
    bank = 0,
    coords = vector3(0, 0, 0)
}

-- Event: Set Player Data from Server
RegisterNetEvent("norm:setPlayerData")
AddEventHandler("norm:setPlayerData", function(data)
    if data then
        PlayerData.id = data.id or GetPlayerServerId(PlayerId())
        PlayerData.name = data.name or GetPlayerName(PlayerId())
        PlayerData.job = data.job or "unemployed"
        PlayerData.cash = data.cash or 0
        PlayerData.bank = data.bank or 0
        PlayerData.coords = data.coords or GetEntityCoords(PlayerPedId())

        Notify("Player data updated: " .. PlayerData.name)
    end
end)

-- Function: Get Player Data
function GetPlayerData()
    return PlayerData
end

-- Auto-Update Player Coordinates
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000) -- Update every 5 seconds
        PlayerData.coords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("norm:updatePlayerCoords", PlayerData.coords)
    end
end)

-- Health Regeneration System (Optional)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        if GetEntityHealth(ped) < 150 then
            SetEntityHealth(ped, GetEntityHealth(ped) + 1)
        end
    end
end)

-- Notification Helper Function
function Notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

-- Keybind for Checking Player Info (Default: F5)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 166) then -- F5 Key
            Notify("Player: " .. PlayerData.name .. "\nJob: " .. PlayerData.job .. "\nCash: $" .. PlayerData.cash)
        end
    end
end)
