-- Nor-M Framework | EMS System
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local EMSJobs = {"ems", "firefighter"} -- Define EMS job roles

-- Function: Revive a Player
RegisterServerEvent("norm:revivePlayer")
AddEventHandler("norm:revivePlayer", function(targetId)
    local src = source
    if IsPlayerEMS(src) then
        TriggerClientEvent("norm:revivePlayer", targetId)
        Notify(src, "You have revived " .. GetPlayerName(targetId))
        Notify(targetId, "You have been revived by EMS.")
    else
        Notify(src, "You are not EMS and cannot use this command.")
    end
end)

-- Function: Heal a Player
RegisterServerEvent("norm:healPlayer")
AddEventHandler("norm:healPlayer", function(targetId)
    local src = source
    if IsPlayerEMS(src) then
        TriggerClientEvent("norm:healPlayer", targetId)
        Notify(src, "You have healed " .. GetPlayerName(targetId))
        Notify(targetId, "You have been healed by EMS.")
    else
        Notify(src, "You are not EMS and cannot use this command.")
    end
end)

-- Function: Check If Player Is EMS
function IsPlayerEMS(playerId)
    local identifier = GetPlayerIdentifier(playerId, 0)
    local job = "unemployed"

    ExecuteSQL("SELECT job FROM players WHERE identifier = ?", {identifier}, function(result)
        if result and #result > 0 then
            job = result[1].job
        end
    end)

    return HasValue(EMSJobs, job)
end

-- Function: Respond to 911 Calls
RegisterCommand("emsrespond", function(source, args)
    if IsPlayerEMS(source) then
        local message = table.concat(args, " ")
        if message and message ~= "" then
            TriggerClientEvent("chat:addMessage", -1, {
                args = {"^3[EMS RESPONSE] " .. GetPlayerName(source), message},
                color = {0, 255, 0}
            })
        else
            Notify(source, "Usage: /emsrespond <message>")
        end
    else
        Notify(source, "You must be EMS to use this command.")
    end
end, false)

-- Function: EMS Duty Toggle
RegisterCommand("emsduty", function(source)
    if IsPlayerEMS(source) then
        TriggerClientEvent("norm:toggleDuty", source)
        Notify(source, "You are now on duty as EMS.")
    else
        Notify(source, "You are not EMS.")
    end
end, false)

-- Function: Notify Player
function Notify(playerId, message)
    TriggerClientEvent("chat:addMessage", playerId, {
        args = {"[EMS SYSTEM]", message},
        color = {0, 255, 0}
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
