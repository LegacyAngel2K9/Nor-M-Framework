-- Nor-M Framework | Server Commands
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

RegisterCommand("announce", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local message = table.concat(args, " ")
        TriggerClientEvent("chat:addMessage", -1, {
            args = {"[SERVER ANNOUNCEMENT]", message},
            color = {255, 0, 0}
        })
    else
        TriggerClientEvent("chat:addMessage", source, {
            args = {"[ERROR]", "You do not have permission to use this command."},
            color = {255, 0, 0}
        })
    end
end, false)

RegisterCommand("kick", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1])
        local reason = table.concat(args, " ", 2)
        if targetId and GetPlayerName(targetId) then
            DropPlayer(targetId, "Kicked by admin: " .. (reason or "No reason provided"))
            TriggerClientEvent("chat:addMessage", -1, {
                args = {"[SERVER]", GetPlayerName(targetId) .. " was kicked from the server."},
                color = {255, 0, 0}
            })
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = {"[ERROR]", "Invalid player ID."},
                color = {255, 0, 0}
            })
        end
    end
end, false)

RegisterCommand("ban", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1])
        local reason = table.concat(args, " ", 2)
        if targetId and GetPlayerName(targetId) then
            TriggerEvent("norm:banPlayer", targetId, reason)
            DropPlayer(targetId, "Banned by admin: " .. (reason or "No reason provided"))
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = {"[ERROR]", "Invalid player ID."},
                color = {255, 0, 0}
            })
        end
    end
end, false)

RegisterCommand("revive", function(source, args, rawCommand)
    local targetId = tonumber(args[1]) or source
    if GetPlayerName(targetId) then
        TriggerClientEvent("norm:revivePlayer", targetId)
    else
        TriggerClientEvent("chat:addMessage", source, {
            args = {"[ERROR]", "Invalid player ID."},
            color = {255, 0, 0}
        })
    end
end, false)

RegisterCommand("heal", function(source, args, rawCommand)
    local targetId = tonumber(args[1]) or source
    if GetPlayerName(targetId) then
        TriggerClientEvent("norm:healPlayer", targetId)
    else
        TriggerClientEvent("chat:addMessage", source, {
            args = {"[ERROR]", "Invalid player ID."},
            color = {255, 0, 0}
        })
    end
end, false)

RegisterCommand("coords", function(source)
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)
    TriggerClientEvent("chat:addMessage", source, {
        args = {"[COORDS]", "Your current coordinates: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z},
        color = {0, 255, 0}
    })
end, false)

-- Admin Permission Check Function
function IsPlayerAdmin(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, id in ipairs(identifiers) do
        if string.match(id, "steam:1100001") or string.match(id, "license:") then
            return true
        end
    end
    return false
end
