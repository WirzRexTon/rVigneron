TriggerEvent('esx_society:registerSociety', 'vigne', 'vigne', 'society_vigne', 'society_vigne', 'society_vigne', {type = 'private'})

RegisterServerEvent('rVigneron:announce')
AddEventHandler('rVigneron:announce', function(title, message)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "vigne" then 
        TriggerClientEvent('esx:showAdvancedNotification', -1, TranslateCap('wineMakingName'), title, message, "CHAR_LIFEINVADER", 8) 
	end 
end)

local farmingActive = {}

RegisterServerEvent('startFarming')
AddEventHandler('startFarming', function(actionType, actionData)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and xPlayer.job.name == 'vigne' then
        if not farmingActive[source] then
            farmingActive[source] = true
            TriggerClientEvent('showProgress', source, actionType, actionData)
        else
            farmingActive[source] = false 
        end
    end
end)


RegisterServerEvent('stopFarming')
AddEventHandler('stopFarming', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer and xPlayer.job.name == 'vigne' then
        if farmingActive[playerId] then
            TriggerClientEvent("deleteProgress", xPlayer.source)
            farmingActive[playerId] = false
        end
    else
        TriggerClientEvent("deleteProgress", xPlayer.source)
        farmingActive[playerId] = false
    end
end)


RegisterServerEvent('completeFarming')
AddEventHandler('completeFarming', function(actionType, actionData)
    local xPlayer = ESX.GetPlayerFromId(source)

    if farmingActive[source] then
        if actionType == "Treatment" then 
            for k,v in pairs(actionData.itemForProcessing) do 
                local Inventory = exports.ox_inventory:GetItem(source, v.item)
                if not Inventory or Inventory.count < v.itemCount then 
                    TriggerEvent("stopFarming", source)
                    xPlayer.showNotification(TranslateCap("missingItem", v.label, Inventory.count, v.itemCount))
                    return 
                end 
            end 

            for k,v in pairs(actionData.itemForProcessing) do 
                if exports.ox_inventory:CanCarryItem(source, actionData.receivedItem, actionData.receivedItemCount) then
                    exports.ox_inventory:RemoveItem(source, v.item, v.itemCount)
                else 
                    TriggerEvent("stopFarming", source)
                    return
                end 
            end 
            local success, response = exports.ox_inventory:AddItem(source, actionData.receivedItem, actionData.receivedItemCount)
            if not success then
                TriggerEvent("stopFarming", source)
                return print(response)
            end
        elseif actionType == "Harvest" then
            if exports.ox_inventory:CanCarryItem(source, actionData.item, actionData.harvestCount) then
                local success, response = exports.ox_inventory:AddItem(source, actionData.item, actionData.harvestCount)
                if not success then
                    TriggerEvent("stopFarming", source)
                    return print(response)
                end
            else 
                TriggerEvent("stopFarming", source)
                return
            end 
        else 
            local number = exports.ox_inventory:GetItemCount(source, actionData.itemForSale, {}, true)
            if number > 0 then 
                local success = exports.ox_inventory:RemoveItem(source, actionData.itemForSale, actionData.forSaleBy)
                xPlayer.addMoney(actionData.receivedMoney - (actionData.receivedMoney * actionData.societyPercentage))
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
                    if account then
                        local money = actionData.receivedMoney*actionData.societyPercentage
                        account.addMoney(money)
                        xPlayer.showNotification(TranslateCap("rewardMoney", money))
                    else
                        return
                    end
                end)
            else 
                TriggerEvent("stopFarming", source)
                xPlayer.showNotification(TranslateCap("missingItem", actionData.itemForSaleLabel, number, actionData.forSaleBy))
                return 
            end 
        end 
    else
        TriggerEvent("stopFarming", source)
    end
end)
