------------------------------------------
-- ldt Tire Replacement (Standalone) --
------------------------------------------

RegisterCommand("replacetire", function(source, args, rawCommand)
    local _source = source
    local wrenchType = 2

    TriggerClientEvent('ldt_opony:fix', _source, wrenchType)
end, false)

RegisterServerEvent("ldt_opony:napraw")
AddEventHandler("ldt_opony:napraw", function(client, tireIndex)
    TriggerClientEvent("ldt_opony:naprawiono", client, tireIndex)
end)
