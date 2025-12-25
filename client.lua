--========================================================
--    PolyZone Based Ped Restriction System
--========================================================

local zones = {}
local combo = nil

local DEBUG_POLY = false  -- set true to see zone outlines

--========================================================
--  DEFINE YOUR POLYZONES HERE
--========================================================

-- Sauce
-- zones[#zones+1] = PolyZone:Create({
--     vector2(-461.59222412109, 259.2063293457),
--     vector2(-460.38702392578, 271.92236328125),
--     vector2(-479.74038696289, 274.00677490234),
--     vector2(-481.31689453125, 261.75094604492)
-- }, {
--     name = "saucenoped",
--     --minZ = 82.93,
--     --maxZ = 83.41,
--     debugPoly = DEBUG_POLY,
-- })

-- Pillbox
zones[#zones+1] = PolyZone:Create({
    vector2(295.73202514648, -555.48547363281),
    vector2(274.81198120117, -610.68560791016),
    vector2(288.42013549805, -614.92108154297),
    vector2(304.45037841797, -570.81683349609)
}, {
    name = "pillnoped",
    --minZ = 29.37,
    --maxZ = 43.43,
    debugPoly = DEBUG_POLY,
})

combo = ComboZone:Create(zones, {
    name = "restricted_combo",
    debugPoly = DEBUG_POLY,
})

--========================================================
--  POPULATION BLOCKER (prevents ambient peds from spawning)
--========================================================

AddEventHandler("populationPedCreating", function(x, y, z, model, setters)
    if combo and combo:isPointInside(vector3(x, y, z)) then
        CancelEvent()
    end
end)

--========================================================
--  HARD CLEANUP (delete any ped that slips inside)
--========================================================

CreateThread(function()
    while true do
        if combo then
            local handle, ped = FindFirstPed()
            local success

            repeat
                if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                    local coords = GetEntityCoords(ped)
                    if combo:isPointInside(coords) then
                        DeleteEntity(ped)
                    end
                end

                success, ped = FindNextPed(handle)
            until not success

            EndFindPed(handle)
        end

        Wait(2000) -- safe interval
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

        Wait(0)
    end
end)
