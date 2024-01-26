local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    for zoneName, zone in pairs(Config.PolyZones) do
        Config.PolyZones[zoneName].polyZone = PolyZone:Create(zone.coords, {
            name = zoneName,
            minZ = zone.minZ,
            maxZ = zone.maxZ,
            debugPoly = false,
        })
    end

    while true do
        Citizen.Wait(0)
        for zoneName, zone in pairs(Config.PolyZones) do
            local playerPed = GetPlayerPed(-1)
            local coords = GetEntityCoords(playerPed)

            if zone.polyZone:isPointInside(coords) then
                local hasAccess = false

                if QBCore.Functions.HasItem(zone.requireditem) then
                    hasAccess = true
                else
                    local playerData = QBCore.Functions.GetPlayerData()
                    local citizenId = playerData.citizenid
                    local license = playerData.license

                    for _, citizenidcheck in pairs(zone.citizenids) do
                        if citizenId == citizenidcheck then
                            hasAccess = true
                            break
                        end
                    end

                    for _, licensecheck in pairs(zone.licenses) do
                        if license == licensecheck then
                            hasAccess = true
                            break
                        end
                    end
                end

                if not hasAccess then
                    DoScreenFadeOut(1000)
                    Wait(1000)
                    SetEntityCoords(playerPed, zone.teleportLocation.x, zone.teleportLocation.y, zone.teleportLocation.z, false, false, false, false)
                    Wait(1000)
                    DoScreenFadeIn(1000)
                    QBCore.Functions.Notify("You do not have access to " .. zoneName .. "!", "error")
                end
            end
        end
    end
end)
