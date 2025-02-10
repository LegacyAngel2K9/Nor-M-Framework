-- Nor-M Framework | Police System
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local PoliceJobs = {"police", "sheriff", "statepolice"} -- Define police job roles

-- Function: Cuff a Player
RegisterServerEvent("norm:cuffPlayer")
AddEventHandler("norm:cuffPlayer", function(targetId)
    local src = source
    if IsPlayerPolice(src) then
        TriggerClientEvent("norm:cuffPlayer", targetId)
        Notify(src, "You have handcuffed " .. GetPlayerName(targetId))
        Notify(targetId, "You have been handcuffed by police.")
    else
        Notify(src, "You are not police and cannot use this command.")
    end
end)

-- Function: Uncuff a Player
RegisterServerEvent("norm:uncuffPlayer")
AddEventHandler("norm:uncuffPlayer", function(targetId)
    local src = source
    if IsPlayerPolice(src) then
        TriggerClientEvent("norm:uncuffPlayer", targetId)
        Notify(src, "You have uncuffed " .. GetPlayerName(targetId))
        Notify(targetId, "You have been uncuffed by police.")
    else
        Notify(src, "You are not police and cannot use this command.")
    end
end)

-- Function: Send a Player to Jail
RegisterServerEvent("norm:jailPlayer")
AddEventHandler("norm:jailPlayer", function(targetId, jailTime)
    local src = source
    if IsPlayerPolice(src) then
        TriggerClientEvent("norm:sendToJail", targetId, jailTime)
        Notify(src, "You have jailed " .. GetPlayerName(targetId) .. " for " .. jailTime .. " minutes.")
        Notify(targetId, "You have been jailed for " .. jailTime .. " minutes.")
    else
        Notify(src, "You are not police and cannot use this command.")
    end
end)

-- Function: Release a Player from Jail
RegisterServerEvent("norm:releaseJail")
AddEventHandler("norm:releaseJail", function(targetId)
    local src = source
    if IsPlayerPolice(src) then
        TriggerClientEvent("norm:releaseFromJail", targetId)
        Notify(src, "You have released " .. GetPlayerName(targetId) .. " from jail.")
        Notify(targetId, "You have been released from jail.")
    else
        Notify(src, "You are not police and cannot use this command.")
    end
end)

-- Function: Police Duty Toggle
RegisterCommand("pduty", function(source)
    if IsPlayerPolice(source) then
        TriggerClientEvent("norm:toggleDuty", source)
        Notify(source, "You are now on duty as Police.")
    else
        Notify(source, "You are not police.")
    end
end, false)

-- Function: Respond to 911 Calls
RegisterCommand("911r", function(source, args)
    if IsPlayerPolice(source) then
        local message = table.concat(args, " ")
        if message and message ~= "" then
            TriggerClientEvent("chat:addMessage", -1, {
                args = {"^4[911 RESPONSE] " .. GetPlayerName(source), message},
                color = {0, 0, 255}
            })
        else
            Notify(source, "Usage: /911r <message>")
        end
    else
        Notify(source, "You must be police to use this command.")
    end
end, false)

-- Function: Check If Player Is Police
function IsPlayerPolice(playerId)
    local identifier = GetPlayerIdentifier(playerId, 0)
    local job = "unemployed"

    ExecuteSQL("SELECT job FROM players WHERE identifier = ?", {identifier}, function(result)
        if result and #result > 0 then
            job = result[1].job
        end
    end)

    return HasValue(PoliceJobs, job)
end

-- Function: Notify Player
function Notify(playerId, message)
    TriggerClientEvent("chat:addMessage", playerId, {
        args = {"[POLICE SYSTEM]", message},
        color = {0, 0, 255}
    })
end

-- Function: Check If Value Exists in Table
function HasValue(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end
