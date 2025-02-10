-- Nor-M Framework | Jobs System (Server-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local Jobs = {
    ["police"] = "Law Enforcement Officer",
    ["ems"] = "Emergency Medical Services",
    ["mechanic"] = "Mechanic",
    ["taxi"] = "Taxi Driver",
    ["unemployed"] = "Unemployed"
}

-- Function: Set Player Job
RegisterServerEvent("norm:setJob")
AddEventHandler("norm:setJob", function(jobName)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    if Jobs[jobName] then
        ExecuteSQL("UPDATE players SET job = ? WHERE identifier = ?", {jobName, identifier}, function()
            TriggerClientEvent("norm:setJob", src, jobName)
            Notify(src, "Your job is now: " .. Jobs[jobName])
        end)
    else
        Notify(src, "Invalid job selection.")
    end
end)

-- Function: Get Player Job
function GetPlayerJob(playerId, callback)
    local identifier = GetPlayerIdentifier(playerId, 0)

    ExecuteSQL("SELECT job FROM players WHERE identifier = ?", {identifier}, function(result)
        if result and #result > 0 then
            callback(result[1].job)
        else
            callback("unemployed")
        end
    end)
end

-- Function: Notify Players
function Notify(playerId, message)
    TriggerClientEvent("chat:addMessage", playerId, {
        args = {"[JOB SYSTEM]", message},
        color = {0, 255, 0}
    })
end

-- Police Duty System
RegisterServerEvent("norm:toggleDuty")
AddEventHandler("norm:toggleDuty", function()
    local src = source
    GetPlayerJob(src, function(job)
        if job == "police" or job == "ems" then
            TriggerClientEvent("norm:toggleDuty", src)
            Notify(src, "You are now on duty as a " .. Jobs[job])
        else
            Notify(src, "You are not in an emergency service job!")
        end
    end)
end)

-- Debugging Command: Check Player Job
RegisterCommand("checkjob", function(source, args)
    local targetId = tonumber(args[1]) or source
    GetPlayerJob(targetId, function(job)
        Notify(source, "Player's job: " .. job)
    end)
end, false)
