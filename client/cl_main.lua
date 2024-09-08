BlipManager = {}
BlipManager.__index = BlipManager

function BlipManager:new()
    local instance = {
        farmingBlips = {},
        jobBlips = {}
    }
    setmetatable(instance, BlipManager)
    return instance
end

function BlipManager:setFarmingBlips()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        for blipsType, actions in pairs(Config.Farming) do
            for _, blipsData in pairs(actions) do
                local blip = AddBlipForCoord(blipsData.position)
                SetBlipSprite(blip, blipsData.blipsId)
                SetBlipScale(blip, blipsData.blipsScale)
                SetBlipColour(blip, blipsData.blipsColor)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(blipsData.label)
                EndTextCommandSetBlipName(blip)
                self.farmingBlips[blipsType] = blip
            end
        end
    else
        for _, blip in pairs(self.farmingBlips) do
            RemoveBlip(blip)
        end
        self.farmingBlips = {}
    end
end

function BlipManager:setJobBlips()
    for _, v in pairs(Config.JobActions.Blips) do
        local blip = AddBlipForCoord(v.coords)
        SetBlipSprite(blip, v.id)
        SetBlipScale(blip, v.scale)
        SetBlipColour(blip, v.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(blip)
        self.jobBlips[v.coords] = blip
    end
end

MarkerManager = {}
MarkerManager.__index = MarkerManager

function MarkerManager:new()
    local instance = {
        farmingActive = false
    }
    setmetatable(instance, MarkerManager)
    return instance
end

function MarkerManager:drawMarkers()
    local pPed = PlayerPedId()
    local pCoords = GetEntityCoords(pPed)
    local NearZone = false

    for actionType, actions in pairs(Config.Farming) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and not ESX.PlayerData.dead then
            for _, actionData in pairs(actions) do
                if #(pCoords - actionData.position) < 10 then
                    NearZone = true
                    DrawMarker(25, actionData.position, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.5, 255, 255, 255, 180, 0, 0, 2, 0, nil, nil, 0)
                    if #(pCoords - actionData.position) <= 3 then
                        if not self.farmingActive then
                            ESX.ShowHelpNotification(actionData.helpNotification)
                            if IsControlJustPressed(1, 38) then
                                TriggerServerEvent('startFarming', actionType, actionData)
                            end
                        end
                    end
                end
            end
        end
    end

    for _, v in pairs(Config.JobActions.Points) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and ESX.PlayerData.job.grade >= v.grade and not ESX.PlayerData.dead then
            if #(pCoords - v.coords) < 10 then
                NearZone = true
                DrawMarker(v.markerId, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.sizeX, v.sizeY, v.sizeZ, v.markerColorR, v.markerColorG, v.markerColorB, 180, 0, 0, 2, 0, nil, nil, 0)
                if #(pCoords - v.coords) <= v.actionRange then
                    ESX.ShowHelpNotification(v.text)
                    if IsControlJustPressed(1, 38) then
                        v.action()
                    end
                end
            end
        end
    end

    if not NearZone then
        Wait(500)
        if self.farmingActive then
            TriggerServerEvent('stopFarming', GetPlayerServerId(PlayerId()))
        end
    end
    Wait(1)
end

FarmingProgress = {}
FarmingProgress.__index = FarmingProgress

function FarmingProgress:new()
    local instance = {
        farmingActive = false
    }
    setmetatable(instance, FarmingProgress)
    return instance
end

function FarmingProgress:showProgress(actionType, actionData)
    self.farmingActive = true
    while self.farmingActive do
        local animDict, animName

        if actionType == "Harvest" or actionType == "Treatment" then
            animDict = "anim@mp_snowball"
            animName = "pickup_snowball"
        end

        if lib.progressCircle({
            duration = actionData.time * 1000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true
            },
            anim = {
                dict = animDict,
                clip = animName
            },
        }) then
            TriggerServerEvent('completeFarming', actionType, actionData)
        else
            TriggerServerEvent('stopFarming', GetPlayerServerId(PlayerId()))
            self.farmingActive = false
        end
        Wait(0)
    end
end

function FarmingProgress:deleteProgress()
    if self.farmingActive then
        lib.cancelProgress()
    end
    self.farmingActive = false
end

local blipManager = BlipManager:new()
local markerManager = MarkerManager:new()
local farmingProgress = FarmingProgress:new()

CreateThread(function()
    blipManager:setFarmingBlips()
    blipManager:setJobBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    blipManager:setFarmingBlips()
    blipManager:setJobBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    blipManager:setFarmingBlips()
    blipManager:setJobBlips()
end)

CreateThread(function()
    while true do
        markerManager:drawMarkers()
    end
end)

RegisterNetEvent('showProgress')
AddEventHandler('showProgress', function(actionType, actionData)
    farmingProgress:showProgress(actionType, actionData)
end)

RegisterNetEvent('deleteProgress')
AddEventHandler('deleteProgress', function()
    farmingProgress:deleteProgress()
end)
