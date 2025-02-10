-- Nor-M Framework | Database System (Server-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local MySQL = nil

-- Load MySQL depending on server configuration
Citizen.CreateThread(function()
    Wait(500)
    if Config.Database.UseMySQL then
        MySQL = exports['oxmysql'] or exports['mysql-async']
        if MySQL then
            print("^2[Database] Connected to MySQL successfully!^7")
        else
            print("^1[Database] MySQL plugin not found!^7")
        end
    else
        print("^3[Database] Using SQLite (no MySQL connection needed).^7")
    end
end)

-- Function: Execute a SQL Query (with Callback)
function ExecuteSQL(query, params, callback)
    if MySQL then
        MySQL.query(query, params, function(result)
            if callback then
                callback(result)
            end
        end)
    else
        print("^1[Database] SQL execution failed: No MySQL connection.^7")
        if callback then callback(nil) end
    end
end

-- Function: Execute SQL without a Callback
function ExecuteSQLSync(query, params)
    if MySQL then
        return MySQL.query.await(query, params)
    else
        print("^1[Database] SQL execution failed: No MySQL connection.^7")
        return nil
    end
end

-- Function: Initialize Player in Database
RegisterServerEvent("norm:initPlayer")
AddEventHandler("norm:initPlayer", function(playerId, identifier, playerName)
    local src = source
    ExecuteSQL("SELECT * FROM players WHERE identifier = ?", {identifier}, function(result)
        if result and #result > 0 then
            -- Player exists, load data
            TriggerClientEvent("norm:setPlayerData", src, result[1])
        else
            -- New player, insert into database
            ExecuteSQL("INSERT INTO players (identifier, name, job, cash, bank) VALUES (?, ?, ?, ?, ?)", 
                {identifier, playerName, "unemployed", Config.StartingCash, Config.StartingBank}, 
                function()
                    print("[Database] New player added: " .. playerName)
                end
            )
        end
    end)
end)

-- Function: Save Player Data
RegisterServerEvent("norm:savePlayerData")
AddEventHandler("norm:savePlayerData", function(playerId, data)
    ExecuteSQL("UPDATE players SET job = ?, cash = ?, bank = ? WHERE identifier = ?", 
        {data.job, data.cash, data.bank, data.identifier})
end)

-- Function: Log Player Disconnect
AddEventHandler("playerDropped", function(reason)
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId, 0)

    ExecuteSQL("UPDATE players SET last_logout = NOW() WHERE identifier = ?", {identifier})
    print("[Database] Player disconnected: " .. GetPlayerName(playerId) .. " | Reason: " .. reason)
end)

-- Debugging Command: Check Player Database Entry
RegisterCommand("checkplayer", function(source, args)
    if IsPlayerAdmin(source) then
        local identifier = args[1]
        ExecuteSQL("SELECT * FROM players WHERE identifier = ?", {identifier}, function(result)
            if result and #result > 0 then
                print(json.encode(result, {indent = true}))
            else
                print("[Database] Player not found.")
            end
        end)
    end
end, false)
