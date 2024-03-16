
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/AeCVP2F8h7  -------------
---------------------------------------------------------------

local function DoProgress(cb)
    if Config.Progress == "qb" then
        QBCore.Functions.Progressbar("opening-gunrack", "Opening Gunrack",  5000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            cb(true)
        end, function()
            cb(false)
        end)
    else
        if lib.progressCircle({
			duration = 5000,
			label = "Opening Gunrack",
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true,
			},
			position= 'bottom',
		}) then 
            cb(true)
		else 
			cb(false)
		end
    end
end
local function OpenGunrack(plate, doProgress)
    if doProgress then
        local p = promise:new()
        DoProgress(function(status)
            p:resolve(status)
        end)
        local status = Citizen.Await(p)
        if not status then
            lib.notify({description = "You cancelled the action.", type = "error"})
            return
        end
    end
    if Config.Inventory == "qb" or Config.Inventory == "qs" then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "gunrack_car_"..plate, {
            maxweight = Config.StashSize,
            slots = Config.StashSlots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "gunrack_car_"..plate)
    elseif Config.Inventory == "ox" then
        TriggerServerEvent("snipe-cargunrack:server:registerStash","gunrack_car_"..plate, "ox")
        exports.ox_inventory:openInventory("stash", "gunrack_car_"..plate)
    elseif Config.Inventory == "mf" then
        TriggerServerEvent("snipe-cargunrack:server:registerStash", "gunrack_car_"..plate, "mf")
        exports['mf-inventory']:openOtherInventory("gunrack_car_"..plate)
    elseif Config.Inventory == "codem" then
        exports["codem-inventory"]:OpenStash("gunrack_car_"..plate, Config.StashSize, Config.StashSlots)
    end
end

local function OpenCarGunrack()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        lib.notify({description = "You are not in a vehicle.", type = "error"})
        return
    end
    if GetVehicleClass(vehicle) ~= 18 and not Config.AllowedCarsModel[GetEntityModel(vehicle)] then
        lib.notify({description = "You are not in a vehicle that has a gunrack.", type = "error"})
        return
    end
    if not Config.AllowOnlyJobsToAccessGunracks or (Config.JobsToAccessGunracks[PlayerInfo.job] and Config.JobsToAccessGunracks[PlayerInfo.job] <= PlayerInfo.jobGrade) then
        local plate = GetVehicleNumberPlateText(vehicle)
        if Config.AllowGunracksForOwnedVehicles then
            local isOwned = lib.callback.await("snipe-cargunrack:server:isOwnedVehicle", false, plate)
            if isOwned then
                OpenGunrack(plate, true)
            else
                lib.notify({description = "Cannot access gunrack for non owned vehicles", type = "error"})
                return
            end
        else
            OpenGunrack(plate, true)
        end
    else
        lib.notify({description = "You are not allowed to access gunrack.", type = "error"})
        return
    end
end

exports('OpenCarGunrack', OpenCarGunrack)

local function ForceOpenGunrack(plate)
    OpenGunrack(plate, false)
end

exports('ForceOpenGunrack', ForceOpenGunrack)

RegisterCommand("cargunrack", function()
    OpenCarGunrack()
end, false)