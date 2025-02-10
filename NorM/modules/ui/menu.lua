-- Nor-M Framework | UI Menu System
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local isMenuOpen = false

-- Function: Open Main UI Menu
RegisterCommand("menu", function()
    if not isMenuOpen then
        isMenuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openMenu"
        })
    else
        CloseMenu()
    end
end, false)

-- Function: Close UI Menu
function CloseMenu()
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeMenu"
    })
end

-- Register NUI Callback for Closing Menu
RegisterNUICallback("closeMenu", function(data, cb)
    CloseMenu()
    cb("ok")
end)

-- Function: Show Notification
function Notify(message)
    TriggerEvent("chat:addMessage", {
        args = {"[MENU]", message},
        color = {255, 215, 0}
    })
end

-- Example: Register an Option in the Menu
RegisterNUICallback("selectOption", function(data, cb)
    if data.option == "revive" then
        TriggerEvent("norm:revivePlayer")
    elseif data.option == "heal" then
        TriggerEvent("norm:healPlayer")
    elseif data.option == "jobinfo" then
        TriggerEvent("norm:showJobInfo")
    end
    Notify("Selected option: " .. data.option)
    cb("ok")
end)

-- Keybind to Open Menu (Default: F2)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 289) then -- "F2" Key
            ExecuteCommand("menu")
        end
    end
end)
