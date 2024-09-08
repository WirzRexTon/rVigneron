rVigneron = {}
rVigneron.__index = rVigneron

function rVigneron.new()
    local self = setmetatable({}, rVigneron)
    return self
end

function rVigneron:openVigneActions()
    local VigneronMenu = RageUI.CreateMenu(TranslateCap("menuTitle"), TranslateCap("menuSubTitle"))
    local AnnounceMenu = RageUI.CreateSubMenu(VigneronMenu, TranslateCap("announceTitle"), TranslateCap("announceSubTitle"))

    RageUI.Visible(VigneronMenu, not RageUI.Visible(VigneronMenu))
    while VigneronMenu do
        Wait(1)
        RageUI.IsVisible(VigneronMenu, function()
            local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
            local canBill = closestPlayer ~= -1 and closestPlayerDistance <= 1.5

            RageUI.Item.Button(TranslateCap("makeBill"), nil, {RightLabel = '→'}, canBill, {
                onActive = function()
                    local cCoords = GetEntityCoords(PlayerPedId())
                    DrawMarker(20, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end,
                onSelected = function()
                    local input = lib.inputDialog(TranslateCap("billingTitle"), {
                        {type = 'number', description = TranslateCap("billingConfirmationText"), icon = 'dollar-sign'},
                    })
                    if input and input[1] ~= 0 then
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_vigne', TranslateCap("billingTitle"), input[1], true)
                    else
                        ESX.ShowNotification(TranslateCap("billingError"))
                    end
                end,
            })

            RageUI.Item.Button(TranslateCap("announceTitle"), nil, {RightLabel = '→'}, true, {}, AnnounceMenu)
        end)

        RageUI.IsVisible(AnnounceMenu, function()
            for _, v in pairs(Config.JobActions.AnnounceMessage) do
                RageUI.Item.Button(v.label, nil, {RightLabel = '→'}, true, {
                    onSelected = function()
                        local alert = lib.alertDialog({
                            header = "Confirmation de l'annonce",
                            content = TranslateCap("announceConfirmationText"),
                            centered = true,
                            cancel = true
                        })
                        if alert == "confirm" then
                            TriggerServerEvent('rVigneron:announce', v.title, v.message)
                        end
                    end,
                })
            end
        end)

        if not RageUI.Visible(VigneronMenu) and not RageUI.Visible(AnnounceMenu) then
            VigneronMenu = RMenu:DeleteType('Vigneron', true)
        end
    end
end

function rVigneron:openLockers()
    local LockerMenu = RageUI.CreateMenu(TranslateCap("clothesMenuTitle"), TranslateCap("clothesMenuSubTitle"))

    RageUI.Visible(LockerMenu, not RageUI.Visible(LockerMenu))
    while LockerMenu do
        Wait(1)
        RageUI.IsVisible(LockerMenu, function()
            RageUI.Item.Button(TranslateCap("civilianDress"), nil, {RightLabel = '→'}, true, {
                onSelected = function()
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        local isMale = skin.sex == 0

                        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end)
                    end)
                end,
            })

            RageUI.Item.Line()
            for k, v in pairs(Config.JobActions.Locker) do
                if ESX.PlayerData.job.grade >= v.grade then
                    RageUI.Item.Button(v.label, nil, {RightLabel = '→'}, true, {
                        onSelected = function()
                            self:setUniform(k, PlayerPedId())
                        end,
                    })
                end
            end
        end)

        if not RageUI.Visible(LockerMenu) then
            LockerMenu = RMenu:DeleteType('Locker', true)
        end
    end
end

function rVigneron:setUniform(job, playerPed)
    TriggerEvent('skinchanger:getSkin', function(skin)
        local clothes = Config.JobActions.Locker[job].clothes
        if skin.sex == 0 then
            if clothes.male then
                TriggerEvent('skinchanger:loadClothes', skin, clothes.male)
            else
                ESX.ShowNotification(TranslateCap('noClothes'))
            end
        else
            if clothes.female then
                TriggerEvent('skinchanger:loadClothes', skin, clothes.female)
            else
                ESX.ShowNotification(TranslateCap('noClothes'))
            end
        end

        if job == 'bullet_wear' then
            SetPedArmour(playerPed, 100)
        end
    end)
end


function rVigneron:openGarage()
    local GarageMenu = RageUI.CreateMenu('Garage', 'Liste :')
    local DeleteVehicleMenu = RageUI.CreateSubMenu(GarageMenu, 'Ranger', "Liste")
    
    RageUI.Visible(GarageMenu, not RageUI.Visible(GarageMenu))
    self:getAllVehicles()

    while GarageMenu do
        Wait(1)
        RageUI.IsVisible(GarageMenu, function()
            RageUI.Item.Button('Ranger un véhicule', nil, {RightLabel = '→'}, true, {
                onSelected = function()
                    self:getAllVehicles()
                end,
            }, DeleteVehicleMenu)

            RageUI.Item.Line()
            for _, v in pairs(Config.JobActions.GarageList) do
                if v.separatorName then
                    RageUI.Item.Separator(v.separatorName)
                else
                    RageUI.Item.Button(v.label, nil, {RightLabel = '→'}, ESX.PlayerData.job.grade >= v.grade, {
                        onSelected = function()
                            self:spawnVeh(v.name)
                        end,
                    })
                end
            end
        end)

        RageUI.IsVisible(DeleteVehicleMenu, function()
            for k, v in ipairs(self.vehicles) do
                local model = GetEntityModel(v)
                local name = GetDisplayNameFromVehicleModel(model)
                local plate = GetVehicleNumberPlateText(v)
                if plate then
                    RageUI.Item.Button("~o~" .. plate .. " - " .. name, nil, {RightLabel = ">"}, true, {
                        onActive = function()
                            local ObjCoords = GetEntityCoords(v)
                            DrawMarker(0, ObjCoords.x, ObjCoords.y, ObjCoords.z + 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                        end,
                        onSelected = function()
                            DeleteEntity(v)
                            table.remove(self.vehicles, k)
                            self:getAllVehicles()
                        end,
                    })
                end
            end
        end)

        if not RageUI.Visible(GarageMenu) and not RageUI.Visible(DeleteVehicleMenu) then
            GarageMenu = RMenu:DeleteType('Garage', true)
        end
    end
end


function rVigneron:selectSpawnPoint()
    for _, v in pairs(Config.JobActions.VehicleSpawnPoint) do
        if ESX.Game.IsSpawnPointClear(v.coords, 2) then
            return v.coords, v.heading
        end
    end
    ESX.ShowNotification("Aucun point de sortie disponible.")
    return false
end

function rVigneron:getAllVehicles()
    self.vehicles = {}
    for _, v in pairs(Config.JobActions.VehicleSpawnPoint) do
        if not ESX.Game.IsSpawnPointClear(v.coords, 2) then
            local veh = ESX.Game.GetClosestVehicle(v.coords)
            table.insert(self.vehicles, veh)
        end
    end
end

function rVigneron:spawnVeh(name)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        local coords, heading = self:selectSpawnPoint()
        if coords then
            ESX.TriggerServerCallback("Jobs:spawnVehicle", function(netid) end, "vigne", name, coords, heading)
        end
    end
end

RegisterCommand('vigneActions', function(source, args)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "vigne" then
        local instance = rVigneron.new()
        instance:openVigneActions()
    end
end)

RegisterKeyMapping('vigneActions', TranslateCap("openActionMenuKey"), 'keyboard', Config.keyMenu)
