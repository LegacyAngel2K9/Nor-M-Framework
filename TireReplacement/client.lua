------------------------------------------
-- ldt Tire Replacement (Standalone) --
------------------------------------------

local ldtBusy = false
local tiresCfg = {
    ["wheel_lf"] = 0, ["wheel_rf"] = 1,
    ["wheel_lm1"] = 2, ["wheel_rm1"] = 3,
    ["wheel_lr"] = 4, ["wheel_rr"] = 5
}
local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lr", "wheel_rr"}

RegisterNetEvent('ldt_opony:fix')
AddEventHandler('ldt_opony:fix', function(option)
    local plyPed = PlayerPedId()
    local vehicle = GetClosestVehicleToPlayer()

    if ldtBusy == false then
        if vehicle ~= 0 then
            local closestTire = GetClosestVehicleTire(vehicle)
            if closestTire ~= nil then
                if IsVehicleTyreBurst(vehicle, closestTire.tireIndex) then
                    ldtBusy = true
                    TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)

                    Citizen.CreateThread(function()
                        local needed_time = (option == 2) and 1000 or 1700
                        local timer = needed_time
                        while timer > 0 do
                            timer = timer - 1    
                            local del = 100 - (100 * (timer / needed_time))
                            Draw3DText(closestTire.bonePos.x, closestTire.bonePos.y, closestTire.bonePos.z, "~r~Repairing "..math.floor(del).."%")
                            Citizen.Wait(10)
                        end

                        Notify("Tire replaced successfully!", "success")
                        SetVehicleTyreFixed(vehicle, closestTire.tireIndex)
                        ldtBusy = false
                        ClearPedTasksImmediately(plyPed)
                    end)
                else
                    Notify("The tire is fine!", "error")
                end
            end
        else
            Notify("No nearby car!", "error")
        end
    end
end)

RegisterNetEvent("ldt_opony:naprawiono")
AddEventHandler("ldt_opony:naprawiono", function(tireIndex)
    Notify("Someone replaced your tire!", "success")
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleTyreFixed(vehicle, tireIndex)
end)

function Notify(msg, type)
    local color = (type == "success") and {0, 255, 0} or {255, 0, 0}
    TriggerEvent("chat:addMessage", {
        args = {"[TIRE REPLACEMENT]", msg},
        color = color
    })
end

function GetClosestVehicleToPlayer()
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed, false)
    local radius = 3.0
    local closestVehicle = nil
    local minDistance = radius + 1.0

    for vehicle in EnumerateVehicles() do
        local vehiclePos = GetEntityCoords(vehicle)
        local distance = #(plyPos - vehiclePos)

        if distance < minDistance then
            minDistance = distance
            closestVehicle = vehicle
        end
    end

    return closestVehicle or 0
end

-- Utility function to loop through all vehicles
function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, veh = FindFirstVehicle()
        local success
        repeat
            coroutine.yield(veh)
            success, veh = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
    end)
end

function GetClosestVehicleTire(vehicle)
    local tireBones = {
        "wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lr", "wheel_rr"
    }
    local tiresCfg = {
        ["wheel_lf"] = 0, ["wheel_rf"] = 1,
        ["wheel_lm1"] = 2, ["wheel_rm1"] = 3,
        ["wheel_lr"] = 4, ["wheel_rr"] = 5
    }

    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed, false)
    local minDistance = 1.0
    local closestTire = nil

    for _, bone in ipairs(tireBones) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, bone)
        if boneIndex ~= -1 then
            local bonePos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            local distance = #(plyPos - bonePos)

            if closestTire == nil or distance < closestTire.boneDist then
                closestTire = {
                    bone = bone,
                    boneDist = distance,
                    bonePos = bonePos,
                    tireIndex = tiresCfg[bone]
                }
            end
        end
    end

    return (closestTire and closestTire.boneDist <= minDistance) and closestTire or nil
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local distance = #(vector3(px, py, pz) - vector3(x, y, z))
    
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.5 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()
        SetTextCentre(true)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
