-- client.lua
--========================================================
--    PolyZone / ComboZone Ped + Vehicle Restriction System
--    - Blocks ambient ped/vehicle spawns inside defined zones
--    - Hard-cleans peds + vehicles that slip inside
--    - Skips player-occupied vehicles + mission entities
--    - Optional: skip "population type 7" vehicles (more player/script-ish)
--========================================================

local zones = {}
local combo = nil

local DEBUG_POLY = false -- set true to see zone outlines

--========================================================
--  DEFINE YOUR POLYZONES HERE
--========================================================

-- Name: 855 | 2026-02-14T02:12:35Z
zones[#zones+1] = PolyZone:Create({
    vector2(-48.103290557861, -1610.330078125),
    vector2(-49.951770782471, -1607.6937255859),
    vector2(-156.94326782227, -1701.9279785156),
    vector2(-133.74139404297, -1714.8315429688)
}, {
    name = "855",
    -- minZ = 29.200597763062,
    -- maxZ = 32.081741333008,
    debugPoly = DEBUG_POLY,
})

-- Name: forum | 2026-02-14T01:34:26Z
zones[#zones+1] = PolyZone:Create({
    vector2(-126.01026153564, -1545.3104248047),
    vector2(-178.01692199707, -1499.6236572266),
    vector2(-246.76121520996, -1572.3403320312),
    vector2(-241.91230773926, -1707.5006103516),
    vector2(-225.39018249512, -1714.3470458984),
    vector2(-170.09083557129, -1650.1458740234),
    vector2(-137.12689208984, -1616.5603027344),
    vector2(-93.237754821777, -1570.9020996094)
}, {
    name = "forum",
    -- minZ = 32.127876281738,
    -- maxZ = 34.073154449463,
    debugPoly = DEBUG_POLY,
})

-- Name: gsc
zones[#zones+1] = PolyZone:Create({
    vector2(-99.2, -1381.35),
    vector2(-104.33, -1486.41),
    vector2(-24.92, -1583.94),
    vector2(30.18, -1440.03),
}, {
    name = "gsc",
    -- minZ = 29.165901184082,
    -- maxZ = 29.253595352173,
    debugPoly = DEBUG_POLY,
})

-- Pillbox
zones[#zones+1] = PolyZone:Create({
    vector2(295.73202514648, -555.48547363281),
    vector2(274.81198120117, -610.68560791016),
    vector2(288.42013549805, -614.92108154297),
    vector2(304.45037841797, -570.81683349609)
}, {
    name = "pillnoped",
    -- minZ = 29.37,
    -- maxZ = 43.43,
    debugPoly = DEBUG_POLY,
})

combo = ComboZone:Create(zones, {
    name = "restricted_combo",
    debugPoly = DEBUG_POLY,
})

--========================================================
--  HELPERS
--========================================================

local function RequestControl(entity, timeoutMs)
    timeoutMs = timeoutMs or 500
    if not DoesEntityExist(entity) then return false end
    if not NetworkGetEntityIsNetworked(entity) then return true end

    local start = GetGameTimer()
    NetworkRequestControlOfEntity(entity)

    while not NetworkHasControlOfEntity(entity) and (GetGameTimer() - start) < timeoutMs do
        Wait(0)
        NetworkRequestControlOfEntity(entity)
    end

    return NetworkHasControlOfEntity(entity)
end

local function IsPlayerInVehicle(veh)
    if not DoesEntityExist(veh) then return false end

    local model = GetEntityModel(veh)
    if not model or model == 0 then return false end

    local maxSeats = GetVehicleModelNumberOfSeats(model) - 2 -- seats are -1..maxSeats
    for seat = -1, maxSeats do
        local p = GetPedInVehicleSeat(veh, seat)
        if p ~= 0 and DoesEntityExist(p) and IsPedAPlayer(p) then
            return true
        end
    end
    return false
end

--========================================================
--  POPULATION BLOCKER (prevents ambient peds and vehicles from spawning)
--========================================================

AddEventHandler("populationPedCreating", function(x, y, z, model, setters)
    if combo and combo:isPointInside(vector3(x, y, z)) then
        CancelEvent()
    end
end)

AddEventHandler("populationVehicleCreating", function(x, y, z, model, setters)
    if combo and combo:isPointInside(vector3(x, y, z)) then
        CancelEvent()
    end
end)

--========================================================
--  HARD CLEANUP (delete any ped or vehicle that slips inside)
--========================================================

-- Peds
CreateThread(function()
    while true do
        if combo then
            local handle, ped = FindFirstPed()
            local success = true

            repeat
                if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                    local coords = GetEntityCoords(ped)
                    if combo:isPointInside(coords) then
                        if RequestControl(ped, 500) then
                            SetEntityAsMissionEntity(ped, true, true)
                            DeleteEntity(ped)
                        end
                    end
                end

                success, ped = FindNextPed(handle)
            until not success

            EndFindPed(handle)
        end

        Wait(6000) -- safe interval
    end
end)

-- Vehicles
CreateThread(function()
    while true do
        if combo then
            local handle, veh = FindFirstVehicle()
            local success = true

            repeat
                if DoesEntityExist(veh) then
                    local coords = GetEntityCoords(veh)
                    if combo:isPointInside(coords) then
                        -- skip player-occupied vehicles
                        local occupiedByPlayer = IsPlayerInVehicle(veh)

                        if not occupiedByPlayer then
                            -- skip mission/script vehicles
                            if not IsEntityAMissionEntity(veh) then
                                -- OPTIONAL: skip population type 7 (often player/script-ish)
                                -- Remove this block if you WANT to delete everything not occupied.
                                local popType = GetEntityPopulationType(veh)
                                if popType ~= 7 then
                                    if RequestControl(veh, 500) then
                                        SetEntityAsMissionEntity(veh, true, true)
                                        DeleteEntity(veh)
                                    end
                                end
                            end
                        end
                    end
                end

                success, veh = FindNextVehicle(handle)
            until not success

            EndFindVehicle(handle)
        end

        Wait(6000)
    end
end)

--========================================================
--  DENSITY SUPPRESSION WHEN PLAYER IS INSIDE ANY ZONE
--========================================================

CreateThread(function()
    while true do
        if combo then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            if combo:isPointInside(coords) then
                SetPedDensityMultiplierThisFrame(0.0)
                SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetRandomVehicleDensityMultiplierThisFrame(0.0)
                SetParkedVehicleDensityMultiplierThisFrame(0.0)
                SetGarbageTrucks(false)
                SetRandomBoats(false)
            end
        end

        Wait(50)
    end
end)
