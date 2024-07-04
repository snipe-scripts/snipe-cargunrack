
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/AeCVP2F8h7  -------------
---------------------------------------------------------------
QBCore = exports['qb-core']:GetCoreObject()
function Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

lib.callback.register("snipe-cargunrack:server:isOwnedVehicle", function(source, plate)
    if Config.Framework == "qb" then
        local isOwned = MySQL.Sync.fetchScalar("SELECT 1 FROM player_vehicles WHERE plate = @plate", {
            ["@plate"] = Trim(plate),
        })
        return isOwned
    elseif Config.Framework == "esx" then
        local isOwned = MySQL.Sync.fetchScalar("SELECT 1 FROM owned_vehicles WHERE plate = @plate", {
            ["@plate"] = Trim(plate),
        })
        return isOwned
    end
end)

RegisterNetEvent("snipe-cargunrack:server:registerStash", function(stashId, inventory)
    if inventory == "ox" then
        exports.ox_inventory:RegisterStash(stashId, "Gunrack", Config.StashSlots, Config.StashSize)
    elseif inventory == "mf" then
        -- exports['mf-inventory']:registerInventory(stashId, "Motel Stash", Config.StashSlots, Config.StashSize)
        local result = exports['mf-inventory']:getInventory(stashId)

        if not result then
            exports['mf-inventory']:createInventory(stashId, 'inventory', 'stash', stashId, Config.StashSize, Config.StashSlots)
        end
    end
end)

RegisterNetEvent('snipe-cargunrack:server:openGunrack', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        exports['qb-inventory']:OpenInventory(src, 'gunrack_car_'..plate, {
            maxweight = Config.StashSize,
            slots = Config.StashSlots,
        })
    end
end)
