-- Nor-M Framework | Jobs System (Client-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local PlayerJob = nil
local Jobs = {
    ["police"] = "Law Enforcement Officer",
    ["ems"] = "Emergency Medical Services",
    ["mechanic"] = "Mechanic",
    ["taxi"] = "Taxi Driver",
    ["unemployed"] = "Unemployed"
}

-- Function to Set Player Job
RegisterNetEvent("norm:setJob")
AddEventHandler("norm:setJob", function(jobName)
    if Jobs[jobName] then
        PlayerJob = jobName
        Notify("Your new job is: " .. Jobs[jobName])
    else
        Notify("Unknown job assigned.")
    end
end)

-- Function to Get Player Job
function GetPlayerJob()
    return PlayerJob
end

-- Function to Display Job Info on UI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000) -- Update every 5 seconds
        if PlayerJob then
            SendNUIMessage({
                action = "updateJob",
                job = Jobs[PlayerJob]
            })
        end
    end
end)

-- Police Duty System
RegisterNetEvent("norm:toggleDuty")
AddEventHandler("norm:toggleDuty", function()
    if PlayerJob == "police" or PlayerJob == "ems" then
        Notify("You are now on duty as a " .. Jobs[PlayerJob])
        TriggerServerEvent("norm:logDuty", PlayerJob, true)
    else
        Notify("You are not in an emergency service job!")
    end
end)

-- Notification Helper Function
function Notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

-- Keybind for toggling duty (default: F6)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 167) then -- F6 Key
            TriggerEvent("norm:toggleDuty")
        end
    end
end)
