-- Nor-M Framework | Chat System
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

-- Function: Register Chat Commands
RegisterCommand("me", function(source, args, rawCommand)
    local message = table.concat(args, " ")
    if message and message ~= "" then
        TriggerClientEvent("norm:sendProximityMessage", -1, source, "^5[ME] ^7" .. message)
    else
        Notify(source, "Usage: /me <message>")
    end
end, false)

RegisterCommand("do", function(source, args, rawCommand)
    local message = table.concat(args, " ")
    if message and message ~= "" then
        TriggerClientEvent("norm:sendProximityMessage", -1, source, "^3[DO] ^7" .. message)
    else
        Notify(source, "Usage: /do <message>")
    end
end, false)

RegisterCommand("ooc", function(source, args, rawCommand)
    local message = table.concat(args, " ")
    if message and message ~= "" then
        TriggerClientEvent("chat:addMessage", -1, {
            args = {"^8[OOC] " .. GetPlayerName(source), message},
            color = {200, 200, 200}
        })
    else
        Notify(source, "Usage: /ooc <message>")
    end
end, false)

RegisterCommand("911", function(source, args, rawCommand)
    local message = table.concat(args, " ")
    if message and message ~= "" then
        TriggerClientEvent("chat:addMessage", -1, {
            args = {"^1[911 CALL] " .. GetPlayerName(source), message},
            color = {255, 0, 0}
        })
    else
        Notify(source, "Usage: /911 <message>")
    end
end, false)

RegisterCommand("911r", function(source, args, rawCommand)
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
        Notify(source, "You must be a police officer to use this command.")
    end
end, false)

RegisterCommand("staff", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local message = table.concat(args, " ")
        if message and message ~= "" then
            TriggerClientEvent("chat:addMessage", -1, {
                args = {"^6[STAFF] " .. GetPlayerName(source), message},
                color = {255, 165, 0}
            })
        else
            Notify(source, "Usage: /staff <message>")
        end
    else
        Notify(source, "You do not have permission to use this command.")
    end
end, false)

-- Function: Handle Proximity Messages
RegisterNetEvent("norm:sendProximityMessage")
AddEventHandler("norm:sendProximityMessage", function(playerId, message)
    local players = GetPlayers()
    local playerCoords = GetEntityCoords(GetPlayerPed(playerId))

    for _, otherPlayer in ipairs(players) do
        local otherCoords = GetEntityCoords(GetPlayerPed(otherPlayer))
        if #(playerCoords - otherCoords) < 20.0 then
            TriggerClientEvent("chat:addMessage", otherPlayer, {
                args = {message},
                color = {150, 150, 150}
            })
        end
    end
end)

-- Function: Notify Player
function Notify(playerId, message)
    TriggerClientEvent("chat:addMessage", playerId, {
        args = {"[CHAT]", message},
        color = {255, 255, 0}
    })
end

-- Function: Check If Player Is Police
function IsPlayerPolice(playerId)
    local identifier = GetPlayerIdentifier(playerId, 0)
    local job = "unemployed"

    ExecuteSQL("SELECT job FROM players WHERE identifier = ?", {identifier}, function(result)
        if result and #result > 0 then
            job = result[1].job
        end
    end)

    return job == "police"
end

-- Function: Check If Player Is Admin
function IsPlayerAdmin(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, id in ipairs(identifiers) do
        if string.match(id, "steam:1100001") or string.match(id, "license:") then
            return true
        end
    end
    return false
end
