
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/AeCVP2F8h7  -------------
---------------------------------------------------------------

Config = {}

-- if you have renamed your qb-core, es_extended, event names, make sure to change them. Based on this information your framework will be detected.
Config.FrameworkTriggers = {
    ["qb"] = {
        ResourceName = "qb-core",
        PlayerLoaded = "QBCore:Client:OnPlayerLoaded",
        PlayerUnload = "QBCore:Client:OnPlayerUnload",
        OnJobUpdate = "QBCore:Client:OnJobUpdate",
    },
    ["esx"] = {
        ResourceName = "es_extended",
        PlayerLoaded = "esx:playerLoaded",
        PlayerUnload = "esx:playerDropped",
        OnJobUpdate = "esx:setJob",
        OnPlayerUnload = "esx:onPlayerLogout",
    }
}

-- if the vehicle class is not 18, then you can whitelist the vehicle models here.
Config.AllowedCarsModel = {
    [`sultan`] = true,

}

Config.Inventory = "ox" -- qb || qs || ox || mf || codem

-- if you set this as false and a player opens a vehicle is not owned by anyone, the gunrack will not appear after restart because the plate wont match!
Config.AllowGunracksForOwnedVehicles = true -- if true, only owned vehicles will have gunracks.

Config.AllowOnlyJobsToAccessGunracks = true -- if true, only the jobs listed in JobsToAccessGunracks will be able to access the gunracks.
Config.JobsToAccessGunracks = {
    ["police"] = 0, -- minimum grade level to access the gunrack
}

Config.StashSlots = 5
Config.StashSize = 5000

-- DO NOT TOUCH THIS!!!!

for k, v in pairs(Config.FrameworkTriggers) do
    if GetResourceState(v.ResourceName) == "started" then
        Config.Framework = k
        print("^2[snipe-cargunrack]^0 Detected Framework: ^2"..k.."^0")
        break
    end
end
