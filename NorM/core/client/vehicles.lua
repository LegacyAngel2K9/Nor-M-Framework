-- Nor-M Framework | Vehicle System (Client-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local vehicleData = {
    isInVehicle = false,
    vehicle = nil
}

-- Event: Entering a Vehicle
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            if not vehicleData.isInVehicle then
                vehicleData.isInVehicle = true
                vehicleData.vehicle = GetVehiclePedIsIn(ped, false)
                TriggerEvent("norm:enteredVehicle", vehicleData.vehicle)
            end
        else
            if vehicleData.isInVehicle then
                vehicleData.isInVehicle = false
                vehicleData.vehicle = nil
                TriggerEvent("norm:exitedVehicle")
            end
        end
    end
end)

-- Event: Vehicle Entered
RegisterNetEvent("norm:enteredVehicle")
AddEventHandler("norm:enteredVehicle", function(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    Notify("You entered a " .. model .. " | Plate: " .. plate)
end)

-- Event: Vehicle Exited
RegisterNetEvent("norm:exitedVehicle")
AddEventHandler("norm:exitedVehicle", function()
    Notify("You exited the vehicle.")
end)

-- Function: Get Current Vehicle
function GetCurrentVehicle()
    return vehicleData.vehicle
end

-- Function: Get Vehicle Speed
function GetVehicleSpeed()
    if vehicleData.vehicle then
        return math.floor(GetEntitySpeed(vehicleData.vehicle) * 3.6) -- Convert from m/s to km/h
    end
    return 0
end

-- Function: Toggle Engine
RegisterCommand("engine", function()
    local vehicle = GetCurrentVehicle()
    if vehicle then
        local engineStatus = GetIsVehicleEngineRunning(vehicle)
        SetVehicleEngineOn(vehicle, not engineStatus, false, true)
        Notify(engineStatus and "Engine turned off." or "Engine started.")
    end
end, false)

-- Function: Lock/Unlock Vehicle
RegisterCommand("lock", function()
    local vehicle = GetCurrentVehicle()
    if vehicle then
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
local seatbeltOn = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 29) then -- "B" key
            seatbeltOn = not seatbeltOn
            Notify(seatbeltOn and "Seatbelt fastened." or "Seatbelt removed.")
        end

        if seatbeltOn then
            DisableControlAction(0, 75, true) -- Disable exit vehicle key
        end
    end
end)

-- Notification Helper Function
function Notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end
