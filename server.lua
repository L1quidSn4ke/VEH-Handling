VehicleMetadata = {}

function GetVehicleMetadata(vehicleNetId, key)
    if VehicleMetadata[vehicleNetId] and VehicleMetadata[vehicleNetId][key] then
        return VehicleMetadata[vehicleNetId][key]
    end
    return nil
end

RegisterServerEvent('vehicle_handling_tires:getTireType')
AddEventHandler('vehicle_handling_tires:getTireType', function(vehicleNetId)
    local source = source
    local tireType = GetVehicleMetadata(vehicleNetId, "tireType")
    if not tireType then
        tireType = "standard"
    end
    TriggerClientEvent('vehicle_handling_tires:setHandling', source, tireType)
end)

function SetVehicleMetadata(vehicleNetId, key, value)
    if not VehicleMetadata[vehicleNetId] then
        VehicleMetadata[vehicleNetId] = {}
    end
    VehicleMetadata[vehicleNetId][key] = value
end

-- Example usage: Setting tire type for a vehicle
-- SetVehicleMetadata(vehicleNetId, "tireType", "offroad")