local restrictedZones = {
    {coords = vector3(-494.7597, 288.4936, 83.4150), radius = 25.0},  -- Sauce Mechanics
    {coords = vector3(309.1922, -589.1412, 43.2684), radius = 30.0},  -- Hospital
    {coords = vector3(-589.2979, -718.1133, 36.2606), radius = 25.0}, -- Police Department
}

CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, zone in pairs(restrictedZones) do
            local distance = #(playerCoords - zone.coords)
            if distance < zone.radius then
                SetPedDensityMultiplierThisFrame(0.0)
                SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetRandomVehicleDensityMultiplierThisFrame(0.0)
                SetParkedVehicleDensityMultiplierThisFrame(0.0)
                SetGarbageTrucks(false)
                SetRandomBoats(false)
                ClearAreaOfPeds(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius, 1)
                ClearAreaOfVehicles(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius, false, false, false, false, false)
            end
        end

        Wait(1000)
    end
end)
