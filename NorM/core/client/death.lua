-- Nor-M Framework | Death System
-- Author: Legacy DEV Team
-- Website: https://legacyh.dev
-- Support: https://discord.legacyh.dev
-- GitHub: https://github.com/LegacyAngel2K9/Nor-M-Framework
-- Issues: https://github.com/LegacyAngel2K9/Nor-M-Framework/issues

local isDead = false
local respawnTime = 300 -- Seconds before respawn
local bleedOutTime = 180 -- Seconds before automatic death
local reviveKey = 38 -- [E] Key for reviving

RegisterNetEvent("norm:playerDied")
AddEventHandler("norm:playerDied", function(killer, weapon)
    if isDead then return end
    isDead = true

    local ped = PlayerPedId()
    SetEntityHealth(ped, 0) -- Force the player into a dead state
    StartDeathTimer() -- Start death handling
end)

function StartDeathTimer()
    local timer = bleedOutTime
    while timer > 0 and isDead do
        Citizen.Wait(1000)
        timer = timer - 1
        if timer <= 0 then
            TriggerServerEvent("norm:confirmDeath")
        end
    end
end

-- Respawn System
RegisterNetEvent("norm:revivePlayer")
AddEventHandler("norm:revivePlayer", function()
    if not isDead then return end
    isDead = false

    local ped = PlayerPedId()
    local respawnCoords = vector3(298.78, -584.64, 43.26) -- Default hospital respawn
    NetworkResurrectLocalPlayer(respawnCoords.x, respawnCoords.y, respawnCoords.z, true, true)
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
end)

-- Revive Command (Admin/EMS)
RegisterCommand("revive", function(source, args, rawCommand)
    if not isDead then return end
    TriggerEvent("norm:revivePlayer")
end, false)

-- EMS Nearby Revive
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isDead then
            DrawText3D(GetEntityCoords(PlayerPedId()), "[E] Call EMS")
            if IsControlJustReleased(0, reviveKey) then
                TriggerServerEvent("norm:requestRevive")
            end
        end
    end
end)

-- Helper function for 3D Text
function DrawText3D(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end
