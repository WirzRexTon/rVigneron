Config = {
    Locale = GetConvar('esx:locale', 'en'), -- La langue / The language (Don't forget the esx:locale in the server.cfg and es_extended/config.lua)
    keyMenu = "F6", -- Press to open the winemaker actions menu 
    Farming = {
        Harvest = {
            [1] = {
                item = "grape", -- item received for harvesting
                label = "Grape Harvest", -- Label for blips 
                harvestCount = 1, -- Number of items received each time
                time = 3, -- Time it takes for an item to be harvested (in seconds) 
                position = vector3(-1745.6905517578, 2380.1508789063, 45.757413482666), -- Position of the action (vector3)
                helpNotification = "Press ~INPUT_PICKUP~ to pick up grapes", -- Message for showHelpNotification
                blipsId = 286, blipsColor = 50, blipsScale = 0.6 -- Blip options (https://docs.fivem.net/docs/game-references/blips/)
            }
        },
        Treatment = {
            [1] = {
                label = "Wine Making", -- Label for blips 
                receivedItem = 'wine', -- Item received at each treatment/manufacturing
                receivedItemCount = 1, -- Number of items received at each manufacture/treatment
                time = 5, -- Time to make/process this item (in seconds)
                itemForProcessing = -- The items required to make a bottle of wine
                    {
                        {item = 'grape', label = "Grape", itemCount = 2}, -- item = item, label = label, itemCount = Number of items required 
                        {item = 'wineyeast', label = "wine-making yeast", itemCount = 1}, 
                        {item = 'water', label = "Eau", itemCount = 1}, 
                    }, 
                position = vector3(-1933.5610351563, 2039.4328613281, 139.9564465332), -- Position of the action (vector3)
                helpNotification = "Press ~INPUT_PICKUP~ to make wine.", -- Message for showHelpNotification
                blipsId = 286, blipsColor = 50, blipsScale = 0.6 -- Blip options (https://docs.fivem.net/docs/game-references/blips/)
            },
        },
        Sale = {
            [1] = {
                label = "Wine Sales", -- Label for blips
                receivedMoney = 30, -- Price the item is worth
                societyPercentage = 0.30, -- Percentage that the company takes (example: 0.30 for 30%)
                time  = 3, -- Time to sell this item (in seconds) 
                itemForSale = "wine", -- item for sale 
                itemForSaleLabel = "Vin", -- Label of the item on sale
                forSaleBy = 2, -- Number of items required for each sale
                position = vector3(202.314453125, -26.093729019165, 68.8983259277), -- Position of the action (vector3)
                helpNotification = "Press ~INPUT_PICKUP~ to sell your wine", -- Message for showHelpNotification
                blipsId = 286, blipsColor = 50, blipsScale = 0.6 -- Blip options (https://docs.fivem.net/docs/game-references/blips/)
            },
        }
    },
    JobActions = {
        Blips = { -- https://docs.fivem.net/docs/game-references/blips/
            {
                coords = vector3(-1888.5941162109, 2050.6589355469, 140.45442199707),
                label = "Winegrower", -- Name on the map (Left side)
                id = 85, -- Id of the blip
                color = 19,  -- Color of the blip
                scale = 0.7 -- Scale of the blip 
            }
        },
        Locker = {
            [1] = {
                label = "Working clothes", -- Name of the outfit in the menu 
                grade = 0, -- Grade required to take the outfit
                clothes = {
                    male = {
                        ['tshirt_1'] = 88, ['tshirt_2'] = 0,
                        ['torso_1'] = 215, ['torso_2'] = 6,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 4,
                        ['pants_1'] = 35, ['pants_2'] = 0,
                        ['shoes_1'] = 51, ['shoes_2'] = 0,
                        ['helmet_1'] = -1, ['helmet_2'] = 0,
                        ['chain_1'] = 0, ['chain_2'] = 0,
                        ['ears_1'] = -1, ['ears_2'] = 0,
                        ['mask_1'] = 0,  ['mask_2'] = 0,
                        ['bags_1'] = 71, ['bags_2'] = 0
                    },
                    female = {
                        ['tshirt_1'] = 36, ['tshirt_2'] = 1,
                        ['torso_1'] = 48, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 44,
                        ['pants_1'] = 34, ['pants_2'] = 0,
                        ['shoes_1'] = 27, ['shoes_2'] = 0,
                        ['helmet_1'] = 0, ['helmet_2'] = 0,
                        ['chain_1'] = 0, ['chain_2'] = 0,
                        ['ears_1'] = -1, ['ears_2'] = 0
                    }
                },
            },
        },
        AnnounceMessage = {
            {label = "Winemaker closed", title = "Announce", message = "The winemaker is closed for now!"},
            {label = "Winemaker open", title = "Announce", message = "The winemaker is open!"},
            {label = "Recruitment", title = "Announce", message = "The winemaker is hiring employees!"},
        },        
        Points = {
            {
                name = "Clothes", -- Name of the point 
                grade = 0, -- Minimal grade required to access the point 
                coords = vec3(-1908.9298095703, 2071.9333496094, 140.3863067627), -- The position in vector3
                text = "Press ~INPUT_PICKUP~ to open the locker room!", -- The message for the showHelpNotification
                action = function() -- The action that will be performed when the person presses E
                    rVigneron.openLockers()
                end,
                actionRange = 1.5, -- Distance to display the showHelpNotification
                markerId = 21, markerRange = 3, markerColorR = 255, markerColorG = 255, markerColorB = 255, sizeX = 0.5, sizeY = 0.5, sizeZ = 0.5-- Marker options (https://docs.fivem.net/docs/game-references/markers/)
            },
            {
                name = "BossAction", -- Name of the point 
                grade = 4, -- Minimal grade required to access the point 
                coords = vec3(-1911.8521728516, 2079.7719726563, 140.3837890625), -- The position in vector3
                text = "Press ~INPUT_PICKUP~ to open the pattern actions!", -- The message for the showHelpNotification
                action = function() -- The action that will be performed when the person presses E
                    RageUI.CloseAll()
                    TriggerEvent('esx_society:openBossMenu', "vigne", function (data, menu)
                        menu.close()
                        RageUI.CloseAll()
                    end, {wash = false}) 
                end,
                actionRange = 1.5, -- Distance to display the showHelpNotification
                markerId = 21, markerRange = 3, markerColorR = 255, markerColorG = 255, markerColorB = 255, sizeX = 0.5, sizeY = 0.5, sizeZ = 0.5-- Marker options (https://docs.fivem.net/docs/game-references/markers/)
            },

            {
                name = "Storage", -- Name of the point 
                grade = 0, -- Minimal grade required to access the point 
                coords = vec3(-1911.5894775391, 2074.1704101563, 140.38638305664), -- The position in vector3
                text = "Press ~INPUT_PICKUP~ to open storage!", -- The message for the showHelpNotification
                action = function() -- The action that will be performed when the person presses E
                    exports.ox_inventory:openInventory('stash', {id = 'society_vigne'})
                end,
                actionRange = 1.5, -- Distance to display the showHelpNotification
                markerId = 21, markerRange = 3, markerColorR = 255, markerColorG = 255, markerColorB = 255, sizeX = 0.5, sizeY = 0.5, sizeZ = 0.5-- Marker options (https://docs.fivem.net/docs/game-references/markers/)
            },
        }
    }
}