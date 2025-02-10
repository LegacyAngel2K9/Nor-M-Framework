-- Nor-M Framework | UI System (Client-Side)
-- Author: Legacy DEV Team

RegisterNetEvent("norm:openMenu")
AddEventHandler("norm:openMenu", function()
    SendNUIMessage({
        action = "openMenu"
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("norm:forceCloseUI")
AddEventHandler("norm:forceCloseUI", function()
    SendNUIMessage({
        action = "closeMenu"
    })
    SetNuiFocus(false, false)
end)

-- Close UI when Escape Key is Pressed
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 322) or IsControlJustPressed(0, 177) then -- Escape / Backspace Key
            SendNUIMessage({ action = "closeMenu" })
            SetNuiFocus(false, false)
        end
    end
end)

-- Ensure UI is closed when the player spawns
Citizen.CreateThread(function()
    Citizen.Wait(5000) -- Wait for framework to load
    TriggerEvent("norm:forceCloseUI")
end)

-- NUI Callback: Close UI from JavaScript
RegisterNUICallback("closeMenu", function(data, cb)
    TriggerEvent("norm:forceCloseUI")
    cb("ok")
end)
