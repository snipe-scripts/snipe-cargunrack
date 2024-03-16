-----------------For support, scripts, and more----------------
--------------- https://discord.gg/AeCVP2F8h7  -------------
---------------------------------------------------------------

QBCore, ESX = nil, nil
PlayerInfo = {}
PlayerJob = nil

if Config.Framework == "qb" then
    QBCore = exports[Config.FrameworkTriggers["qb"].ResourceName]:GetCoreObject()
elseif Config.Framework == "esx" then
    local status, errorMsg = pcall(function() ESX = exports[Config.FrameworkTriggers["esx"].ResourceName]:getSharedObject() end)
    if (ESX == nil) then
        while ESX == nil do
            Wait(100)
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
    end
end

local function PopulateData()
    if Config.Framework == "qb" then
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
        PlayerInfo = {
            job = PlayerData.job.name,
            jobGrade = PlayerData.job.grade.level
        }
        PlayerData = nil
    elseif Config.Framework == "esx" then
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        PlayerData = ESX.GetPlayerData()
        PlayerJob = PlayerData.job
        PlayerInfo = {
            job = PlayerData.job.name,
            jobGrade = PlayerData.job.grade
        }
        PlayerData = nil
    end
    print("Snipe-CarGunRack: Player Data Loaded")
end

local function UpdateJob(jobData)
    if Config.Framework == "qb" then
        PlayerInfo.job = jobData.name
        PlayerInfo.jobGrade = jobData.grade.level
    elseif Config.Framework == "esx" then
        PlayerInfo.job = jobData.name
        PlayerInfo.jobGrade = jobData.grade
    end
end

RegisterNetEvent(Config.FrameworkTriggers[Config.Framework].PlayerLoaded)
AddEventHandler(Config.FrameworkTriggers[Config.Framework].PlayerLoaded, function()
    PopulateData()
end)

RegisterNetEvent(Config.FrameworkTriggers[Config.Framework].PlayerUnload)
AddEventHandler(Config.FrameworkTriggers[Config.Framework].PlayerUnload, function()
    PlayerLoaded = false
    PlayerJob = nil
end)

RegisterNetEvent(Config.FrameworkTriggers[Config.Framework].OnJobUpdate)
AddEventHandler(Config.FrameworkTriggers[Config.Framework].OnJobUpdate, function(job)
    PlayerJob = job
    UpdateJob(job)
end)

AddEventHandler("onResourceStart", function(resource)
    Wait(2000)
    if resource == GetCurrentResourceName() then
        PopulateData()
    end
end)