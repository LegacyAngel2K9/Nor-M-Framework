-- Nor-M Framework | Utility Functions (Client-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

Utils = {}

-- Function: Show Notification
function Utils.Notify(message, duration)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

-- Function: Draw 3D Text
function Utils.DrawText3D(coords, text, size)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(size or 0.35, size or 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

-- Function: Get Closest Player
function Utils.GetClosestPlayer()
    local players = GetActivePlayers()
    local closestPlayer = nil
    local closestDistance = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(players) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)

            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

-- Function: Get Closest Vehicle
function Utils.GetClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool("CVehicle")
    local closestVehicle = nil
    local closestDistance = -1

    for _, vehicle in ipairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehicleCoords)

        if closestDistance == -1 or distance < closestDistance then
            closestVehicle = vehicle
            closestDistance = distance
        end
    end

    return closestVehicle, closestDistance
end

-- Function: Get Street Name from Player Position
function Utils.GetStreetName()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local streetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    return GetStreetNameFromHashKey(streetHash)
end

-- Function: Play Animation
function Utils.PlayAnimation(dict, anim, duration)
    local playerPed = PlayerPedId()
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end

    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, duration or -1, 49, 0, false, false, false)
end

-- Function: Get Time in Game
function Utils.GetGameTime()
    return GetClockHours(), GetClockMinutes()
end

-- Function: Get Player Heading
function Utils.GetHeading()
    return GetEntityHeading(PlayerPedId())
end

return Utils
