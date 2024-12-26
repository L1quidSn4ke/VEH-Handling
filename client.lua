function GetSurfaceType(vehicle)
    local coords = GetEntityCoords(vehicle)
    --local groundMaterial = GetGroundMaterialType(coords.x, coords.y, coords.z)
    local retval --[[ integer ]] =	GetVehicleWheelType(vehicle --[[ Vehicle ]]	)

    if groundMaterial == "SAND" or groundMaterial == "DIRT" or groundMaterial == "GRASS" then
        return "offroad"
    elseif groundMaterial == "ROAD" or groundMaterial == "PAVED" then
        return "road"
    else
        return "unknown"
    end
end

function SetVehicleHandlingBasedOnTireTypeAndSurface(vehicle, tireType)
    local surfaceType = GetSurfaceType(vehicle)

    if tireType == "offroad" then
        if surfaceType == "offroad" then
            -- Optimal handling for off-road tires on off-road surfaces
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fInitialDragCoeff', 5.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fDriveBiasFront', 0.5)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMax', 2.5)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMin', 2.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveLateral', 20.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionSpringDeltaMax', 0.15)
        else
            -- Suboptimal handling for off-road tires on other surfaces
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fInitialDragCoeff', 6.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fDriveBiasFront', 0.6)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMax', 1.5)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMin', 1.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveLateral', 15.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionSpringDeltaMax', 0.1)
        end
    elseif tireType == "sport" then
        if surfaceType == "road" then
            -- Optimal handling for sport tires on road surfaces
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fInitialDragCoeff', 3.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fDriveBiasFront', 0.3)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMax', 3.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMin', 2.5)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveLateral', 25.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionSpringDeltaMax', 0.2)
        else
            -- Suboptimal handling for sport tires on other surfaces
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fInitialDragCoeff', 4.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fDriveBiasFront', 0.4)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMax', 2.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMin', 1.5)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveLateral', 20.0)
            SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionSpringDeltaMax', 0.15)
        end
    elseif tireType == "standard" then
        -- Standard handling for standard tires on any surface
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fInitialDragCoeff', 4.0)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fDriveBiasFront', 0.4)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMax', 2.2)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMin', 1.8)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveLateral', 20.0)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionSpringDeltaMax', 0.12)
    else
        -- Default handling for unknown tire type
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fInitialDragCoeff', 4.0)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fDriveBiasFront', 0.4)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMax', 2.2)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveMin', 1.8)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionCurveLateral', 20.0)
        SetVehicleHandlingField(vehicle, 'CHandlingData', 'fTractionSpringDeltaMax', 0.12)
    end
end

RegisterNetEvent('vehicle_handling_tires:setHandling')
AddEventHandler('vehicle_handling_tires:setHandling', function(tireType)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        SetVehicleHandlingBasedOnTireTypeAndSurface(vehicle, tireType)
    end
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == "CEventNetworkPlayerEnteredVehicle" then
        local vehicle = args[1]
        TriggerServerEvent('vehicle_handling_tires:getTireType', NetworkGetNetworkIdFromEntity(vehicle))
    end
end)