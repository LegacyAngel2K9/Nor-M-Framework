-- Nor-M Framework | Vehicle System (Server-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local vehicles = {}

-- Function: Register a Vehicle in Database
RegisterServerEvent("norm:registerVehicle")
AddEventHandler("norm:registerVehicle", function(plate, model, owner)
    local identifier = GetPlayerIdentifier(source, 0)
    
    ExecuteSQL("INSERT INTO vehicles (plate, model, owner, stored) VALUES (?, ?, ?, ?)", 
        {plate, model, identifier, 1}, 
        function()
            print("[Database] Vehicle Registered: " .. model .. " | Plate: " .. plate)
        end
    )
end)

-- Function: Fetch Player Vehicles
RegisterServerEvent("norm:getPlayerVehicles")
AddEventHandler("norm:getPlayerVehicles", function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    ExecuteSQL("SELECT * FROM vehicles WHERE owner = ?", {identifier}, function(result)
        if result then
            TriggerClientEvent("norm:receivePlayerVehicles", src, result)
        else
            TriggerClientEvent("norm:receivePlayerVehicles", src, {})
        end
    end)
end)

-- Function: Update Vehicle Storage Status
RegisterServerEvent("norm:updateVehicleStorage")
AddEventHandler("norm:updateVehicleStorage", function(plate, stored)
    ExecuteSQL("UPDATE vehicles SET stored = ? WHERE plate = ?", {stored, plate})
end)

-- Function: Delete a Vehicle
RegisterServerEvent("norm:deleteVehicle")
AddEventHandler("norm:deleteVehicle", function(plate)
    ExecuteSQL("DELETE FROM vehicles WHERE plate = ?", {plate})
end)

-- Function: Spawn a Vehicle (Admin Command)
RegisterCommand("spawnveh", function(source, args)
    if IsPlayerAdmin(source) then
        local model = args[1]
        if model then
            TriggerClientEvent("norm:spawnVehicle", source, model)
        else
            Notify(source, "Usage: /spawnveh <vehicle_model>")
        end
    end
end, false)

-- Function: Lock/Unlock Vehicle
RegisterServerEvent("norm:toggleVehicleLock")
AddEventHandler("norm:toggleVehicleLock", function(plate)
    if vehicles[plate] then
        vehicles[plate].locked = not vehicles[plate].locked
        TriggerClientEvent("norm:updateVehicleLock", -1, plate, vehicles[plate].locked)
    end
end)

-- Function: Get Vehicle Owner
RegisterServerEvent("norm:getVehicleOwner")
AddEventHandler("norm:getVehicleOwner", function(plate)
    local src = source
    ExecuteSQL("SELECT owner FROM vehicles WHERE plate = ?", {plate}, function(result)
        if result and #result > 0 then
            TriggerClientEvent("norm:receiveVehicleOwner", src, result[1].owner)
        else
            TriggerClientEvent("norm:receiveVehicleOwner", src, nil)
        end
    end)
end)

-- Notification Helper Function
function Notify(playerId, message)
    TriggerClientEvent("chat:addMessage", playerId, {
        args = {"[VEHICLE SYSTEM]", message},
        color = {0, 255, 0}
    })
end
