
CreateThread(function()
    for k,v in pairs(Config.JobActions.Blips) do 
        local blip = AddBlipForCoord(v.coords)
        SetBlipSprite(blip, v.id)
        SetBlipScale(blip, v.scale)
        SetBlipColour(blip, v.color)
        SetBlipAsShortRange(blip, true)
    
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(blip)
    end 
    for blipsType, actions in pairs(Config.Farming) do
        for _, blipsData in pairs(actions) do
            local blip  = AddBlipForCoord(blipsData.position)
            SetBlipSprite(blip, blipsData.blipsId)
            SetBlipScale(blip, blipsData.blipsScale)
            SetBlipColour(blip, blipsData.blipsColor)
            SetBlipAsShortRange(blip, true)
        
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(blipsData.label)
            EndTextCommandSetBlipName(blip)
        end 
    end 
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local NearZone = false
        for k,v in pairs(Config.JobActions.Points) do
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
        if NearZone then
            Wait(1)
        else
            Wait(500)
        end
        NearZone = NearZone
    end
end)


local farmingActive = false

CreateThread(function()
    while true do
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local NearZone = false

        for actionType, actions in pairs(Config.Farming) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and not ESX.PlayerData.dead then
                for _, actionData in pairs(actions) do
                    if #(pCoords - actionData.position) < 10 then
                        NearZone = true
                        DrawMarker(25, actionData.position , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.5, 255, 255, 255, 180, 0, 0, 2, 0, nil, nil, 0)

                        if #(pCoords - actionData.position) <= 3 then
                            if not farmingActive then
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

        if not NearZone then
            Wait(500)
            if farmingActive then
                TriggerServerEvent('stopFarming', GetPlayerServerId(PlayerId()))
            end 
        end
        NearZone = NearZone
        Wait(1)
    end
end)



local progressCancelled = false 
RegisterNetEvent('showProgress')
AddEventHandler('showProgress', function(actionType, actionData)
    farmingActive = true
    while farmingActive do
        local animDict = nil
        local animName = nil
        
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
            if not progressCancelled then
                TriggerServerEvent('stopFarming', GetPlayerServerId(PlayerId()))
            end
        end

        progressCancelled = false 
        Wait(0)
    end
end)



RegisterNetEvent('deleteProgress')
AddEventHandler('deleteProgress', function()
    lib.cancelProgress()
    farmingActive = false
    progressCancelled = true
end)

