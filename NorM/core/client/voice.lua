-- Nor-M Framework | Voice System (Client-Side)
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local voiceRange = 15.0 -- Default voice range in meters
local isTalking = false

-- Function: Toggle Voice Range
RegisterCommand("voicerange", function()
    if voiceRange == 5.0 then
        voiceRange = 15.0 -- Normal Range
        Notify("Voice range set to Normal (~15m)")
    elseif voiceRange == 15.0 then
        voiceRange = 30.0 -- Shouting Range
        Notify("Voice range set to Shouting (~30m)")
    else
        voiceRange = 5.0 -- Whispering Range
        Notify("Voice range set to Whispering (~5m)")
    end
    TriggerServerEvent("norm:updateVoiceRange", voiceRange)
end, false)

-- Event: Update Voice Range
RegisterNetEvent("norm:updateVoiceRange")
AddEventHandler("norm:updateVoiceRange", function(range)
    NetworkSetTalkerProximity(range)
end)

-- Voice Indicator (HUD Display)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsPlayerTalking(PlayerId()) then
            if not isTalking then
                isTalking = true
                SendNUIMessage({
                    action = "showVoice",
                    state = true
                })
            end
        else
            if isTalking then
                isTalking = false
                SendNUIMessage({
                    action = "showVoice",
                    state = false
                })
            end
        end
    end
end)

-- Notification Helper Function
function Notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

-- Keybind for Changing Voice Range (Default: Z)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 20) then -- "Z" Key
            ExecuteCommand("voicerange")
        end
    end
end)
