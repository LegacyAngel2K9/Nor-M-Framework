-- Nor-M Framework | Admin Tools
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

-- Function: Revive a Player
RegisterCommand("arevive", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1]) or source
        if GetPlayerName(targetId) then
            TriggerClientEvent("norm:revivePlayer", targetId)
            Notify(source, "Revived " .. GetPlayerName(targetId))
        else
            Notify(source, "Invalid player ID.")
        end
    end
end, false)

-- Function: Heal a Player
RegisterCommand("aheal", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1]) or source
        if GetPlayerName(targetId) then
            TriggerClientEvent("norm:healPlayer", targetId)
            Notify(source, "Healed " .. GetPlayerName(targetId))
        else
            Notify(source, "Invalid player ID.")
        end
    end
end, false)

-- Function: Set Player Job
RegisterCommand("asetjob", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1])
        local jobName = args[2]
        if targetId and jobName then
            TriggerClientEvent("norm:setJob", targetId, jobName)
            Notify(source, "Set " .. GetPlayerName(targetId) .. "'s job to " .. jobName)
        else
            Notify(source, "Usage: /asetjob <id> <job>")
        end
    end
end, false)

-- Function: Teleport to Player
RegisterCommand("goto", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1])
        if targetId and GetPlayerName(targetId) then
            TriggerClientEvent("norm:teleportToPlayer", source, targetId)
            Notify(source, "Teleported to " .. GetPlayerName(targetId))
        else
            Notify(source, "Invalid player ID.")
        end
    end
end, false)

-- Function: Teleport Player to Admin
RegisterCommand("bring", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1])
        if targetId and GetPlayerName(targetId) then
            TriggerClientEvent("norm:bringPlayer", targetId, source)
            Notify(source, "Brought " .. GetPlayerName(targetId) .. " to you.")
        else
            Notify(source, "Invalid player ID.")
        end
    end
end, false)

-- Function: Announce a Message to the Server
RegisterCommand("announce", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local message = table.concat(args, " ")
        TriggerClientEvent("chat:addMessage", -1, {
            args = {"[SERVER ANNOUNCEMENT]", message},
            color = {255, 0, 0}
        })
    end
end, false)

-- Function: Kick a Player
RegisterCommand("akick", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1])
        local reason = table.concat(args, " ", 2)
        if targetId and GetPlayerName(targetId) then
            DropPlayer(targetId, "Kicked by admin: " .. (reason or "No reason provided"))
            Notify(source, "Kicked " .. GetPlayerName(targetId))
        else
            Notify(source, "Invalid player ID.")
        end
    end
end, false)

-- Function: Ban a Player
RegisterCommand("aban", function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        local targetId = tonumber(args[1])
        local reason = table.concat(args, " ", 2)
        if targetId and GetPlayerName(targetId) then
            ExecuteSQL("INSERT INTO bans (identifier, reason) VALUES (?, ?)", 
                {GetPlayerIdentifier(targetId, 0), reason})
            DropPlayer(targetId, "Banned by admin: " .. (reason or "No reason provided"))
            Notify(source, "Banned " .. GetPlayerName(targetId))
        else
            Notify(source, "Invalid player ID.")
        end
    end
end, false)

-- Function: Check if Player is an Admin
function IsPlayerAdmin(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, id in ipairs(identifiers) do
        if string.match(id, "steam:1100001") or string.match(id, "license:") then
            return true
        end
    end
    return false
end

-- Function: Notify Players
function Notify(playerId, message)
    TriggerClientEvent("chat:addMessage", playerId, {
        args = {"[ADMIN]", message},
        color = {255, 69, 0}
    })
end
