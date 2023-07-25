
rVigneron = {}

rVigneron.openVigneActions = function()

    local Vigneron = RageUI.CreateMenu(TranslateCap("menuTitle"), TranslateCap("menuSubTitle"))
    local Announce = RageUI.CreateSubMenu(Vigneron, TranslateCap("announceTitle"), TranslateCap("announceSubTitle"))


    RageUI.Visible(Vigneron, not RageUI.Visible(Vigneron))
    while Vigneron do
        Wait(1)
        RageUI.IsVisible(Vigneron, function()
            local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestPlayerDistance > 1.5 then
                RageUI.Item.Button(TranslateCap("makeBill"), nil, {RightLabel = '→'}, false, {})
            else 
                RageUI.Item.Button(TranslateCap("makeBill"), nil, {RightLabel = '→'}, true, {
                    onActive = function()
                            local cCoords = GetEntityCoords(PlayerPedId())
                            DrawMarker(20, cCoords.x, cCoords.y, cCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                    end, 
                    onSelected = function()
                        local input = lib.inputDialog(TranslateCap("billingTitle"), {
                            {type = 'number', description = TranslateCap("billingConfirmationText"), icon = 'dollar-sign'},
                        })   
                        if not input then 
                            return
                        else 
                            if input[1] == 0 then 
                                ESX.ShowNotification(TranslateCap("billingError"))
                                return 
                            else 
                                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_vigne', TranslateCap("billingTitle"), input[1], true)
                            end 
                        end
                    end,
                })
            end 
            RageUI.Item.Button(TranslateCap("announceTitle"), nil, {RightLabel = '→'}, true, {}, Announce)
        end)
        RageUI.IsVisible(Announce, function()
            for k,v in pairs(Config.JobActions.AnnounceMessage) do 
                RageUI.Item.Button(v.label, nil, {RightLabel = '→'}, true, {
                    onSelected = function()
                        local alert = lib.alertDialog({
                            header = "Confirmation de l'annonce",
                            content = TranslateCap("announceConfirmationText"),
                            centered = true,
                            cancel = true
                        })
                        if alert and alert == "confirm" then 
                            TriggerServerEvent('rVigneron:announce', v.title, v.message)
                        else 
                            return
                        end 
                    end,
                })
            end 
        end) 
        if not RageUI.Visible(Vigneron) and not RageUI.Visible(Announce) then
            Vigneron = RMenu:DeleteType('Vigneron', true)
        end
    end
end

RegisterCommand('vigneActions', function(source, args)
    if ESX.PlayerData.job and ESX.PlayerData.job.name == "vigne" then
        rVigneron.openVigneActions()
    end 
end)
RegisterKeyMapping('vigneActions', TranslateCap("openActionMenuKey"), 'keyboard', Config.keyMenu)



local function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.JobActions.Locker[job].clothes.male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.JobActions.Locker[job].clothes.male)
			else
				ESX.ShowNotification(TranslateCap('noClothes'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.JobActions.Locker[job].clothes.female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.JobActions.Locker[job].clothes.female)
			else
				ESX.ShowNotification(TranslateCap('noClothes'))
			end
		end
	end)
end

rVigneron.openLockers = function()
    local Locker = RageUI.CreateMenu(TranslateCap("clothesMenuTitle"), TranslateCap("clothesMenuSubTitle"))
    RageUI.Visible(Locker, not RageUI.Visible(Locker))
    while Locker do
        Wait(1)
        RageUI.IsVisible(Locker, function()
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
            RageUI.Line()
            for k,v in pairs(Config.JobActions.Locker) do 
                if ESX.PlayerData.job.grade >= v.grade then 
                    RageUI.Item.Button(v.label, nil, {RightLabel = '→'}, true, {
                        onSelected = function()
                            setUniform(k, PlayerPedId())
                        end,
                    })
                end 
            end 
        end)
        if not RageUI.Visible(Locker) then
            Locker = RMenu:DeleteType('Locker', true)
        end
    end
end

