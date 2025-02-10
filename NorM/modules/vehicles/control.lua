-- Nor-M Framework | Vehicle Control System
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local seatbeltOn = false
local cruiseControl = false

-- Function: Toggle Engine
RegisterCommand("engine", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and vehicle ~= 0 then
        local engineStatus = GetIsVehicleEngineRunning(vehicle)
        SetVehicleEngineOn(vehicle, not engineStatus, false, true)
        Notify(engineStatus and "Engine turned off." or "Engine started.")
    end
end, false)

-- Function: Lock/Unlock Vehicle
RegisterCommand("lock", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and vehicle ~= 0 then
        local locked = GetVehicleDoorLockStatus(vehicle)
        if locked == 1 then
            SetVehicleDoorsLocked(vehicle, 2)
            Notify("Vehicle locked.")
        else
            SetVehicleDoorsLocked(vehicle, 1)
            Notify("Vehicle unlocked.")
        end
    end
end, false)

-- Function: Toggle Seatbelt
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 29) then -- "B" key for seatbelt
            seatbeltOn = not seatbeltOn
            Notify(seatbeltOn and "Seatbelt fastened." or "Seatbelt removed.")
        end

        if seatbeltOn then
            DisableControlAction(0, 75, true) -- Disable exit vehicle key
        end
    end
end)

-- Function: Toggle Cruise Control
RegisterCommand("cruise", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and vehicle ~= 0 then
        if cruiseControl then
            cruiseControl = false
            SetVehicleForwardSpeed(vehicle, 0.0)
            Notify("Cruise control disabled.")
        else
            cruiseControl = true
            local speed = GetEntitySpeed(vehicle)
            SetVehicleForwardSpeed(vehicle, speed)
            Notify("Cruise control enabled.")
        end
    end
end, false)

-- Function: Notify Players
function Notify(message)
    TriggerEvent("chat:addMessage", {
        args = {"[VEHICLE CONTROL]", message},
        color = {255, 215, 0}
    })
end
