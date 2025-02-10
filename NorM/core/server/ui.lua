-- Nor-M Framework | UI System (Server-Side)
-- Author: Legacy DEV Team

RegisterServerEvent("norm:closeMenuOnJoin")
AddEventHandler("norm:closeMenuOnJoin", function()
    local src = source
    TriggerClientEvent("norm:forceCloseUI", src)
end)

-- Ensure the UI closes when the player loads in
AddEventHandler("playerSpawned", function()
    local src = source
    TriggerClientEvent("norm:forceCloseUI", src)
end)
